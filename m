Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8A92171A6
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgGGPXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729957AbgGGPXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6460206F6;
        Tue,  7 Jul 2020 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135397;
        bh=uIk4ESIW5Mg7M/v0OCJWVJvllWdahzivRGgMbeGe7dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tS7alWj3w8W43903DmvzOKviX+0VNQaf0uU8C+8Ur/DKrzzuKvyzOAmDq+P9oTtNB
         nzJFfcTMUI2zaPFe1ZfcHNCFYMRq8kZ6EBdTFmzjFEnfBesywbvpv854gloGGYWdt/
         1q4GM5QqWZ+Pj7F+XWQ6KcDYssKbl1lFXDx1rMyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tetsuhiro Kohada <kohada.t2@gmail.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 004/112] exfat: move setting VOL_DIRTY over exfat_remove_entries()
Date:   Tue,  7 Jul 2020 17:16:09 +0200
Message-Id: <20200707145801.142772468@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

[ Upstream commit 3bcfb701099acf96b0e883bf5544f96af473aa1d ]

Move setting VOL_DIRTY over exfat_remove_entries() to avoid unneeded
leaving VOL_DIRTY on -ENOTEMPTY.

Fixes: 5f2aa075070c ("exfat: add inode operations")
Cc: stable@vger.kernel.org # v5.7
Reported-by: Tetsuhiro Kohada <kohada.t2@gmail.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 3bf1dbadab691..2c9c783177213 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -984,7 +984,6 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
 		goto unlock;
 	}
 
-	exfat_set_vol_flags(sb, VOL_DIRTY);
 	exfat_chain_set(&clu_to_free, ei->start_clu,
 		EXFAT_B_TO_CLU_ROUND_UP(i_size_read(inode), sbi), ei->flags);
 
@@ -1012,6 +1011,7 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
 	num_entries++;
 	brelse(bh);
 
+	exfat_set_vol_flags(sb, VOL_DIRTY);
 	err = exfat_remove_entries(dir, &cdir, entry, 0, num_entries);
 	if (err) {
 		exfat_msg(sb, KERN_ERR,
-- 
2.25.1



