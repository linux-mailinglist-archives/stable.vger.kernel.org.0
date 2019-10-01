Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADCBC3C74
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733080AbfJAQnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733060AbfJAQnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF4621855;
        Tue,  1 Oct 2019 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948229;
        bh=rl7ZIeGi2KWZp1Bkg/Y0Ga7FW5CfX8TJo1HQJxkG2+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fF6/HnCMAeVlm8/nUh3lmFhi6IAc0aOZcoFV6GvDk9mEmt3I5/x4+i3EKoU/IWUy9
         o4dv+it5AdmIbtc1ophOcIJlOV5kZRt3gizkIfTZ6NXr6dM0iHjSRrM52hhpMTfpu9
         x+pLvy0S7e9vnL75pg1uHcmUbcRl1cQaT4rmLU/o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/43] fuse: fix memleak in cuse_channel_open
Date:   Tue,  1 Oct 2019 12:42:55 -0400
Message-Id: <20191001164311.15993-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 9ad09b1976c562061636ff1e01bfc3a57aebe56b ]

If cuse_send_init fails, need to fuse_conn_put cc->fc.

cuse_channel_open->fuse_conn_init->refcount_set(&fc->count, 1)
                 ->fuse_dev_alloc->fuse_conn_get
                 ->fuse_dev_free->fuse_conn_put

Fixes: cc080e9e9be1 ("fuse: introduce per-instance fuse_dev structure")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/cuse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 8f68181256c00..f057c213c453a 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -518,6 +518,7 @@ static int cuse_channel_open(struct inode *inode, struct file *file)
 	rc = cuse_send_init(cc);
 	if (rc) {
 		fuse_dev_free(fud);
+		fuse_conn_put(&cc->fc);
 		return rc;
 	}
 	file->private_data = fud;
-- 
2.20.1

