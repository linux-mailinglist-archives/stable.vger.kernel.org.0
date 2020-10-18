Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99157291B78
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbgJRTbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732022AbgJRT1T (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:27:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA7D7222C8;
        Sun, 18 Oct 2020 19:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049239;
        bh=tI1+CMLt7XsKiR4Zum/43ZEg4i5X9EB8R3lNrLX8EWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9bd4jz9PDMU9IKmLg5hult8Y4Cs5LhXgAnHnONNInbJiMLvuO54MZUFnbw+t06+4
         PvkmV5SiK+gAzmP4VfQXeFNMqw4zUC+u0MhLVbr2bvXNFYAA+jQ91d2b9gQWK4735D
         jx7x2sBzoZdLunC/aOg3VDshPwg55BZ3E7uTV83Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 36/41] tty: ipwireless: fix error handling
Date:   Sun, 18 Oct 2020 15:26:30 -0400
Message-Id: <20201018192635.4056198-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192635.4056198-1-sashal@kernel.org>
References: <20201018192635.4056198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit db332356222d9429731ab9395c89cca403828460 ]

ipwireless_send_packet() can only return 0 on success and -ENOMEM on
error, the caller should check non zero for error condition

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Acked-by: David Sterba <dsterba@suse.com>
Link: https://lore.kernel.org/r/20200821161942.36589-1-ztong0001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/ipwireless/network.c | 4 ++--
 drivers/tty/ipwireless/tty.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/ipwireless/network.c b/drivers/tty/ipwireless/network.c
index c0dfb642383b2..dc7f4eb18e0a7 100644
--- a/drivers/tty/ipwireless/network.c
+++ b/drivers/tty/ipwireless/network.c
@@ -116,7 +116,7 @@ static int ipwireless_ppp_start_xmit(struct ppp_channel *ppp_channel,
 					       skb->len,
 					       notify_packet_sent,
 					       network);
-			if (ret == -1) {
+			if (ret < 0) {
 				skb_pull(skb, 2);
 				return 0;
 			}
@@ -133,7 +133,7 @@ static int ipwireless_ppp_start_xmit(struct ppp_channel *ppp_channel,
 					       notify_packet_sent,
 					       network);
 			kfree(buf);
-			if (ret == -1)
+			if (ret < 0)
 				return 0;
 		}
 		kfree_skb(skb);
diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 2685d59d27245..4f9690442507f 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -217,7 +217,7 @@ static int ipw_write(struct tty_struct *linux_tty,
 	ret = ipwireless_send_packet(tty->hardware, IPW_CHANNEL_RAS,
 			       buf, count,
 			       ipw_write_packet_sent_callback, tty);
-	if (ret == -1) {
+	if (ret < 0) {
 		mutex_unlock(&tty->ipw_tty_mutex);
 		return 0;
 	}
-- 
2.25.1

