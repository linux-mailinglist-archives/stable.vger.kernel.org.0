Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B2F38307F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbhEQO2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237832AbhEQO0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:26:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FFA061493;
        Mon, 17 May 2021 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260797;
        bh=XfB93B0iqSXfeJP3MGmy9gtOaMXAym7u33cGOrQejFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4S3he/gBWGUwvH+1E0alzOkL6775QRYa5l7bDhCJ9UznZU6Du6tbMcI/lZWNWyXY
         B6CNKV35zFoA6xgrMeIYvPylaQX69zpDMdpVWjrrR7QXyGD6AS5paT6jwJJfScFlVh
         GtRBr6630KEub6QTkUvSLdijOMCtKrFGUzBhUjow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Baoquan He <bhe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 238/363] kernel: kexec_file: fix error return code of kexec_calculate_store_digests()
Date:   Mon, 17 May 2021 16:01:44 +0200
Message-Id: <20210517140310.634696732@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 31d82c2c787d5cf65fedd35ebbc0c1bd95c1a679 ]

When vzalloc() returns NULL to sha_regions, no error return code of
kexec_calculate_store_digests() is assigned.  To fix this bug, ret is
assigned with -ENOMEM in this case.

Link: https://lkml.kernel.org/r/20210309083904.24321-1-baijiaju1990@gmail.com
Fixes: a43cac0d9dc2 ("kexec: split kexec_file syscall code to kexec_file.c")
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 5c3447cf7ad5..33400ff051a8 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -740,8 +740,10 @@ static int kexec_calculate_store_digests(struct kimage *image)
 
 	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
 	sha_regions = vzalloc(sha_region_sz);
-	if (!sha_regions)
+	if (!sha_regions) {
+		ret = -ENOMEM;
 		goto out_free_desc;
+	}
 
 	desc->tfm   = tfm;
 
-- 
2.30.2



