Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFBA25945E
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgIAPiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731414AbgIAPiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:38:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C53120866;
        Tue,  1 Sep 2020 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974728;
        bh=gwf4wWC0vORa2uGQfb3OiUSJDKLfwwSQvhew2ikLsvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUzB/yg1X9RzeBsOM8LJ1aJU7pqbuk9dS1Xc3V8Bs9HJOZZhq7SHw0Ftna6hMYgb8
         cWTlftY6jNxrQ/ZXSeNTm6A7L6DToFIfjJfMUvFAWDRCTVo0V+yO1/0Da3XMnE05QQ
         nO33px790AR1GL88y4bnf0Q4jVygd0bF3Pg/YuvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Changming Liu <charley.ashbringer@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 071/255] USB: sisusbvga: Fix a potential UB casued by left shifting a negative value
Date:   Tue,  1 Sep 2020 17:08:47 +0200
Message-Id: <20200901151004.133937256@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changming Liu <charley.ashbringer@gmail.com>

[ Upstream commit 2b53a19284f537168fb506f2f40d7fda40a01162 ]

The char buffer buf, receives data directly from user space,
so its content might be negative and its elements are left
shifted to form an unsigned integer.

Since left shifting a negative value is undefined behavior, thus
change the char to u8 to elimintate this UB.

Signed-off-by: Changming Liu <charley.ashbringer@gmail.com>
Link: https://lore.kernel.org/r/20200711043018.928-1-charley.ashbringer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/sisusbvga/sisusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index fc8a5da4a07c9..0734e6dd93862 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -761,7 +761,7 @@ static int sisusb_write_mem_bulk(struct sisusb_usb_data *sisusb, u32 addr,
 	u8   swap8, fromkern = kernbuffer ? 1 : 0;
 	u16  swap16;
 	u32  swap32, flag = (length >> 28) & 1;
-	char buf[4];
+	u8 buf[4];
 
 	/* if neither kernbuffer not userbuffer are given, assume
 	 * data in obuf
-- 
2.25.1



