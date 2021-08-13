Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8F53EB80F
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241804AbhHMPKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241267AbhHMPK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9114C61107;
        Fri, 13 Aug 2021 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867399;
        bh=byG94AmVZNqU3uFJuThTk2DWZ7msoYeVVQYiggnX1lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OanTOigKDaG/ozjYThvTcYD0gXFDe/4NcmNnHl52zmim7gKdDj7R0tCKv3OLlcvfx
         aqS2TlH/4fj0jxgeYarNLkzFS1SH/9YLMSkCMotfOjSTm6pHdudFoAlj4Nct1zRrbG
         RDM5hscd0R1IIQKRnd+zjWzfiC3jr8NVpO2lzfCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Subject: [PATCH 4.9 07/30] net: pegasus: fix uninit-value in get_interrupt_interval
Date:   Fri, 13 Aug 2021 17:06:35 +0200
Message-Id: <20210813150522.683719309@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit af35fc37354cda3c9c8cc4961b1d24bdc9d27903 ]

Syzbot reported uninit value pegasus_probe(). The problem was in missing
error handling.

get_interrupt_interval() internally calls read_eprom_word() which can
fail in some cases. For example: failed to receive usb control message.
These cases should be handled to prevent uninit value bug, since
read_eprom_word() will not initialize passed stack variable in case of
internal failure.

Fail log:

BUG: KMSAN: uninit-value in get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
BUG: KMSAN: uninit-value in pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
CPU: 1 PID: 825 Comm: kworker/1:1 Not tainted 5.12.0-rc6-syzkaller #0
...
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
 pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
....

Local variable ----data.i@pegasus_probe created at:
 get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
 pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152
 get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
 pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152

Reported-and-tested-by: syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20210804143005.439-1-paskripkin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 5fe9f1273fe2..6cfc6faf9747 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -755,12 +755,16 @@ static inline void disable_net_traffic(pegasus_t *pegasus)
 	set_registers(pegasus, EthCtrl0, sizeof(tmp), &tmp);
 }
 
-static inline void get_interrupt_interval(pegasus_t *pegasus)
+static inline int get_interrupt_interval(pegasus_t *pegasus)
 {
 	u16 data;
 	u8 interval;
+	int ret;
+
+	ret = read_eprom_word(pegasus, 4, &data);
+	if (ret < 0)
+		return ret;
 
-	read_eprom_word(pegasus, 4, &data);
 	interval = data >> 8;
 	if (pegasus->usb->speed != USB_SPEED_HIGH) {
 		if (interval < 0x80) {
@@ -775,6 +779,8 @@ static inline void get_interrupt_interval(pegasus_t *pegasus)
 		}
 	}
 	pegasus->intr_interval = interval;
+
+	return 0;
 }
 
 static void set_carrier(struct net_device *net)
@@ -1191,7 +1197,9 @@ static int pegasus_probe(struct usb_interface *intf,
 				| NETIF_MSG_PROBE | NETIF_MSG_LINK);
 
 	pegasus->features = usb_dev_id[dev_index].private;
-	get_interrupt_interval(pegasus);
+	res = get_interrupt_interval(pegasus);
+	if (res)
+		goto out2;
 	if (reset_mac(pegasus)) {
 		dev_err(&intf->dev, "can't reset MAC\n");
 		res = -EIO;
-- 
2.30.2



