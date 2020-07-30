Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F717232E10
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgG3IJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729724AbgG3IJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:09:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E6382083B;
        Thu, 30 Jul 2020 08:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096585;
        bh=Qj/EIbY4v4NUqJrf0C80ed7XAxb3us5DbKBGQjx1TtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aFbFMgEnY13pnZfE1uf6m83h41/k865OMmxcpe2ltENi5PTNVz17axzQKL9QoP55
         Tog06BOENuRLyFD7Z1vqB6qumw0kJUo55ofP6Wh/B07vr/l3x9YnghGaR5vv+TDb6q
         QhzDlTZBN/y4d/1tfY3fFOKNjJhtut+sXUi8p0uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        syzbot+4cd84f527bf4a10fc9c1@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/61] ax88172a: fix ax88172a_unbind() failures
Date:   Thu, 30 Jul 2020 10:04:35 +0200
Message-Id: <20200730074421.674493904@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
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
index 2c50497cc4edc..7ec8992401fb4 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -217,6 +217,7 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = asix_read_cmd(dev, AX_CMD_READ_NODE_ID, 0, 0, ETH_ALEN, buf, 0);
 	if (ret < ETH_ALEN) {
 		netdev_err(dev->net, "Failed to read MAC address: %d\n", ret);
+		ret = -EIO;
 		goto free;
 	}
 	memcpy(dev->net->dev_addr, buf, ETH_ALEN);
-- 
2.25.1



