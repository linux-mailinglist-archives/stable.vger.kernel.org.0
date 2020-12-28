Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755682E407F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389251AbgL1OxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502109AbgL1OTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 819712063A;
        Mon, 28 Dec 2020 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165161;
        bh=30wRvLYMuuuOmbb8sDTf0kxDzspVdth8YwEHI/ToWGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCLS0iuibm14bO12+MEN7c/Nat9vCH3+WEZZYxW5ikYWAwSEkDvQ+pTV2aHdAYHT5
         CJDLESz4HqKfkuvXWlbB/0VKQAxLyzSW7lR2ZGlRBUwel5HG6zXwc0IpHVZ+z+kJAZ
         ODfI1V33AT6GCQwU4UksiOaReP7yHb2D/U/WLxdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 433/717] ubifs: Fix error return code in ubifs_init_authentication()
Date:   Mon, 28 Dec 2020 13:47:11 +0100
Message-Id: <20201228125041.716926890@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 3cded66330591cfd2554a3fd5edca8859ea365a2 ]

Fix to return PTR_ERR() error code from the error handling case where
ubifs_hash_get_desc() failed instead of 0 in ubifs_init_authentication(),
as done elsewhere in this function.

Fixes: 49525e5eecca5 ("ubifs: Add helper functions for authentication support")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/auth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index b93b3cd10bfd3..8c50de693e1d4 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -338,8 +338,10 @@ int ubifs_init_authentication(struct ubifs_info *c)
 	c->authenticated = true;
 
 	c->log_hash = ubifs_hash_get_desc(c);
-	if (IS_ERR(c->log_hash))
+	if (IS_ERR(c->log_hash)) {
+		err = PTR_ERR(c->log_hash);
 		goto out_free_hmac;
+	}
 
 	err = 0;
 
-- 
2.27.0



