Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B8111B622
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbfLKP7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731590AbfLKPOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 576E524658;
        Wed, 11 Dec 2019 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077250;
        bh=Bz+8WnJtqczywJSe0UW6YQd82hoa3y0kDAL/ZZjTorE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12NkmH7GcBDH8yyWoAdlMWmBYqxpc8PiIG/xGCBqnd79K8PCLS/TbCjgjfzpzgSyV
         uvMcFtne7+kDotJpGQQ6pxdip+zu99UI8Wvdo70aBnOjV1uKUzU+QfDo2tvBRctcdc
         VDImB/BbozoZ8IcKSSNPI5rMVWFkjXLnIctKhlF8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 127/134] s390/cpum_sf: Check for SDBT and SDB consistency
Date:   Wed, 11 Dec 2019 10:11:43 -0500
Message-Id: <20191211151150.19073-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 247f265fa502e7b17a0cb0cc330e055a36aafce4 ]

Each SBDT is located at a 4KB page and contains 512 entries.
Each entry of a SDBT points to a SDB, a 4KB page containing
sampled data. The last entry is a link to another SDBT page.

When an event is created the function sequence executed is:

  __hw_perf_event_init()
  +--> allocate_buffers()
       +--> realloc_sampling_buffers()
	    +---> alloc_sample_data_block()

Both functions realloc_sampling_buffers() and
alloc_sample_data_block() allocate pages and the allocation
can fail. This is handled correctly and all allocated
pages are freed and error -ENOMEM is returned to the
top calling function. Finally the event is not created.

Once the event has been created, the amount of initially
allocated SDBT and SDB can be too low. This is detected
during measurement interrupt handling, where the amount
of lost samples is calculated. If the number of lost samples
is too high considering sampling frequency and already allocated
SBDs, the number of SDBs is enlarged during the next execution
of cpumsf_pmu_enable().

If more SBDs need to be allocated, functions

       realloc_sampling_buffers()
       +---> alloc-sample_data_block()

are called to allocate more pages. Page allocation may fail
and the returned error is ignored. A SDBT and SDB setup
already exists.

However the modified SDBTs and SDBs might end up in a situation
where the first entry of an SDBT does not point to an SDB,
but another SDBT, basicly an SBDT without payload.
This can not be handled by the interrupt handler, where an SDBT
must have at least one entry pointing to an SBD.

Add a check to avoid SDBTs with out payload (SDBs) when enlarging
the buffer setup.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 3d8b12a9a6ff4..7511b71d29313 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -193,7 +193,7 @@ static int realloc_sampling_buffer(struct sf_buffer *sfb,
 				   unsigned long num_sdb, gfp_t gfp_flags)
 {
 	int i, rc;
-	unsigned long *new, *tail;
+	unsigned long *new, *tail, *tail_prev = NULL;
 
 	if (!sfb->sdbt || !sfb->tail)
 		return -EINVAL;
@@ -232,6 +232,7 @@ static int realloc_sampling_buffer(struct sf_buffer *sfb,
 			sfb->num_sdbt++;
 			/* Link current page to tail of chain */
 			*tail = (unsigned long)(void *) new + 1;
+			tail_prev = tail;
 			tail = new;
 		}
 
@@ -241,10 +242,22 @@ static int realloc_sampling_buffer(struct sf_buffer *sfb,
 		 * issue, a new realloc call (if required) might succeed.
 		 */
 		rc = alloc_sample_data_block(tail, gfp_flags);
-		if (rc)
+		if (rc) {
+			/* Undo last SDBT. An SDBT with no SDB at its first
+			 * entry but with an SDBT entry instead can not be
+			 * handled by the interrupt handler code.
+			 * Avoid this situation.
+			 */
+			if (tail_prev) {
+				sfb->num_sdbt--;
+				free_page((unsigned long) new);
+				tail = tail_prev;
+			}
 			break;
+		}
 		sfb->num_sdb++;
 		tail++;
+		tail_prev = new = NULL;	/* Allocated at least one SBD */
 	}
 
 	/* Link sampling buffer to its origin */
-- 
2.20.1

