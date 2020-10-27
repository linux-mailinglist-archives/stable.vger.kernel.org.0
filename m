Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E01429AE81
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753619AbgJ0OBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753611AbgJ0OBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:01:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 361B3221F8;
        Tue, 27 Oct 2020 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807266;
        bh=nE9sYJGW7Gd3tHtoSy/tIeKH2o8k6bvzAfO/B54u6P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hxil8a2XLQlKJg4jMvGZnPQJnruiEx4CMxPIhHezYZS4ioD2zzWK0/T/UejrkvchB
         1MLCXFz3EOMKsmHmthI3+o0xboT8XegxTh8VFPiLAs4FLKrDR59vrh3267mJQQPmz1
         Qum61d2VEyXziBKBxWLre2ZFmUJSLONjXnJ515Bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 104/112] tty: ipwireless: fix error handling
Date:   Tue, 27 Oct 2020 14:50:14 +0100
Message-Id: <20201027134905.471042795@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 345cebb07ae79..0b06b1847450f 100644
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



