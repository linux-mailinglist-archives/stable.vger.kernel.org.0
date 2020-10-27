Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D8A29B573
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794495AbgJ0PMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794492AbgJ0PMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:12:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A46421D41;
        Tue, 27 Oct 2020 15:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811525;
        bh=ww8mPCgIta2DTw14Ldjc/t6ai8FcjQRzSqbo6ouy0tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w69Fy0PuIaamkSdnuT4S2YX8Q7EkavGcA/HADpimj9MdXnSM5qZSUXMnN7BJF/iDd
         HmWhHA52d897kOdIo35pzAeXPzN2bd3Vl20TrUFbxVMth1JVt9Ev4E0LoCECZIBouO
         6KnCWXIuVKUid8Tnx9LVEhmHk1DTjX+AMLpsHCjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Grant <al.grant@foss.arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 525/633] perf: correct SNOOPX field offset
Date:   Tue, 27 Oct 2020 14:54:28 +0100
Message-Id: <20201027135547.400508721@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Grant <al.grant@foss.arm.com>

[ Upstream commit f3d301c1f2f5676465cdf3259737ea19cc82731f ]

perf_event.h has macros that define the field offsets in the
data_src bitmask in perf records. The SNOOPX and REMOTE offsets
were both 37. These are distinct fields, and the bitfield layout
in perf_mem_data_src confirms that SNOOPX should be at offset 38.

Fixes: 52839e653b5629bd ("perf tools: Add support for printing new mem_info encodings")
Signed-off-by: Al Grant <al.grant@foss.arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: https://lkml.kernel.org/r/4ac9f5cc-4388-b34a-9999-418a4099415d@foss.arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/perf_event.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 7b2d6fc9e6ed7..dc33e3051819d 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -1155,7 +1155,7 @@ union perf_mem_data_src {
 
 #define PERF_MEM_SNOOPX_FWD	0x01 /* forward */
 /* 1 free */
-#define PERF_MEM_SNOOPX_SHIFT	37
+#define PERF_MEM_SNOOPX_SHIFT  38
 
 /* locked instruction */
 #define PERF_MEM_LOCK_NA	0x01 /* not available */
-- 
2.25.1



