Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC05B2E3B86
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732668AbgL1NvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:51:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406476AbgL1Nu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16C3220791;
        Mon, 28 Dec 2020 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163418;
        bh=kD1KJvfZabHqHTEzjZ43wMKSV+u8GPIAS9zryJIfk4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKkYIyx4iO88NJb8+wn+btdBplLdLfn3r6QAj95ZwGxd/voJLGpD8153pbyucNiPO
         fDiec+fw74AkCP2eBmnz6W55lGp0Q8MFwZbd+ioCe7p3jw+Eqlg9RSfaCwm1H0Dbvo
         osjx3qxs9AhMPiDsuaDpmMot1TDswfpanjTtQbmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 280/453] ubifs: Fix error return code in ubifs_init_authentication()
Date:   Mon, 28 Dec 2020 13:48:36 +0100
Message-Id: <20201228124950.684089150@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index f985a3fbbb36a..b10418b5fb719 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -352,8 +352,10 @@ int ubifs_init_authentication(struct ubifs_info *c)
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



