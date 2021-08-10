Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684CB3E7E4B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhHJRcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhHJRcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1658960EE7;
        Tue, 10 Aug 2021 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616716;
        bh=KwI4/+UcX8eSloMdRdXEFzkZ+lE6cIU+gP6RivqvFA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFfjg5QG93H9RwreYdSG92PQT6n55wq9o8iAnZvR6ZucN6X/ylUd4lDKKqs1+Iesz
         mqP8rmZMm3nRYWPRSLIVn7YMm5ZImBILDXhhvKxG3R3ubVF0u4XrEsJr7IvaPmRB1F
         S77S/8B5PMbAfbQNKrK65/LJWSgSWEci4bjp+eeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Subject: [PATCH 4.19 16/54] net: pegasus: fix uninit-value in get_interrupt_interval
Date:   Tue, 10 Aug 2021 19:30:10 +0200
Message-Id: <20210810172944.717718772@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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
index b7a0df95d4b0..9f1777e56d7d 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -750,12 +750,16 @@ static inline void disable_net_traffic(pegasus_t *pegasus)
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
@@ -770,6 +774,8 @@ static inline void get_interrupt_interval(pegasus_t *pegasus)
 		}
 	}
 	pegasus->intr_interval = interval;
+
+	return 0;
 }
 
 static void set_carrier(struct net_device *net)
@@ -1188,7 +1194,9 @@ static int pegasus_probe(struct usb_interface *intf,
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



