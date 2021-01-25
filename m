Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4BC304A97
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbhAZFDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:03:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbhAYSwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:52:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3892020665;
        Mon, 25 Jan 2021 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600713;
        bh=UhKbd6/nnSv82h6sGXoJaz3zk1cJMA3qsTWACfE7vq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSyV75n+hLJ7Jp5MM9PQqDwS+NIF31yGRpQMAd9L9Ewzl1FTxLd/XcHYTQe/o67Cd
         UQUhA8zQZPxXuDMziN4MOJdLZjQxh6ekXb+WIvLczAs0CnvHhkfU7P8n2oxaIefeI7
         YINzQaNQrrOPFS9+uCpeQYaPVVLsKlhSJKO34IOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Jeremy Cline <jcline@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/199] drm/amdkfd: Fix out-of-bounds read in kdf_create_vcrat_image_cpu()
Date:   Mon, 25 Jan 2021 19:38:34 +0100
Message-Id: <20210125183220.160534180@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Cline <jcline@redhat.com>

[ Upstream commit 8b335bff643f3b39935c7377dbcd361c5b605d98 ]

KASAN reported a slab-out-of-bounds read of size 1 in
kdf_create_vcrat_image_cpu().

This occurs when, for example, when on an x86_64 with a single NUMA node
because kfd_fill_iolink_info_for_cpu() is a no-op, but afterwards the
sub_type_hdr->length, which is out-of-bounds, is read and multiplied by
entries. Fortunately, entries is 0 in this case so the overall
crat_table->length is still correct.

Check if there were any entries before de-referencing sub_type_hdr which
may be pointing to out-of-bounds memory.

Fixes: b7b6c38529c9 ("drm/amdkfd: Calculate CPU VCRAT size dynamically (v2)")
Suggested-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Jeremy Cline <jcline@redhat.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index d7f67620f57ba..31d793ee0836e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1034,11 +1034,14 @@ static int kfd_create_vcrat_image_cpu(void *pcrat_image, size_t *size)
 				(struct crat_subtype_iolink *)sub_type_hdr);
 		if (ret < 0)
 			return ret;
-		crat_table->length += (sub_type_hdr->length * entries);
-		crat_table->total_entries += entries;
 
-		sub_type_hdr = (typeof(sub_type_hdr))((char *)sub_type_hdr +
-				sub_type_hdr->length * entries);
+		if (entries) {
+			crat_table->length += (sub_type_hdr->length * entries);
+			crat_table->total_entries += entries;
+
+			sub_type_hdr = (typeof(sub_type_hdr))((char *)sub_type_hdr +
+					sub_type_hdr->length * entries);
+		}
 #else
 		pr_info("IO link not available for non x86 platforms\n");
 #endif
-- 
2.27.0



