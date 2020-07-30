Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB3232D82
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgG3ILR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbgG3ILQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:11:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BFD62083B;
        Thu, 30 Jul 2020 08:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096676;
        bh=pPkQLeSdC79szNzt2x3yTOozgIyr3fuTsPjDtCh2NTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvFFUA1xN6j/nLA9amUNGg3kOiiXpRQpZmVCWNZhuh12ft9OAUvLhLRHs5sZZq+nY
         wvCidVYG7Tq5T6rssUqk+Oo2dznvGLLv5Iyt+kmweI9kTyvuxzRG3DI9Y8phCFc5TW
         2eJjm33IfYi7LdM4TojGHlLM/4hPhuRnAXuEFPNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        syzbot+4cd84f527bf4a10fc9c1@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/54] ax88172a: fix ax88172a_unbind() failures
Date:   Thu, 30 Jul 2020 10:04:57 +0200
Message-Id: <20200730074422.087254866@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit c28d9a285668c799eeae2f7f93e929a6028a4d6d ]

If ax88172a_unbind() fails, make sure that the return code is
less than zero so that cleanup is done properly and avoid UAF.

Fixes: a9a51bd727d1 ("ax88172a: fix information leak on short answers")
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reported-by: syzbot+4cd84f527bf4a10fc9c1@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88172a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index 6b1d03b73eeb8..6b734c7ffec39 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -245,6 +245,7 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = asix_read_cmd(dev, AX_CMD_READ_NODE_ID, 0, 0, ETH_ALEN, buf);
 	if (ret < ETH_ALEN) {
 		netdev_err(dev->net, "Failed to read MAC address: %d\n", ret);
+		ret = -EIO;
 		goto free;
 	}
 	memcpy(dev->net->dev_addr, buf, ETH_ALEN);
-- 
2.25.1



