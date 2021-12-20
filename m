Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E4147AB55
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhLTOgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhLTOf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:35:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA96AC061574;
        Mon, 20 Dec 2021 06:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A63EB80EE2;
        Mon, 20 Dec 2021 14:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5001C36AE7;
        Mon, 20 Dec 2021 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640010957;
        bh=78q+Ws+TAxCKq+1q6znTrWqC/zEihNtciNzJ3e+34XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgrpLWeMclkc7mcEk3H0lnp3VvbaZBfVGoyqfReDfRNAwlackAZGfqTTgHO1IxqdV
         zOH1Fk45s0Vd1vCNeyYPg12Ra77chgZbhnCb+myK0Y6Wm0PyLHknbMguZE0s0QDAOP
         pCtw9KunhppvCKNZgZgiE8RiYkH0ahTNWaIvlr1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f9f76f4a0766420b4a02@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 01/23] nfc: fix segfault in nfc_genl_dump_devices_done
Date:   Mon, 20 Dec 2021 15:34:02 +0100
Message-Id: <20211220143017.889032992@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
References: <20211220143017.842390782@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit fd79a0cbf0b2e34bcc45b13acf962e2032a82203 upstream.

When kmalloc in nfc_genl_dump_devices() fails then
nfc_genl_dump_devices_done() segfaults as below

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 25 Comm: kworker/0:1 Not tainted 5.16.0-rc4-01180-g2a987e65025e-dirty #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-6.fc35 04/01/2014
Workqueue: events netlink_sock_destruct_work
RIP: 0010:klist_iter_exit+0x26/0x80
Call Trace:
<TASK>
class_dev_iter_exit+0x15/0x20
nfc_genl_dump_devices_done+0x3b/0x50
genl_lock_done+0x84/0xd0
netlink_sock_destruct+0x8f/0x270
__sk_destruct+0x64/0x3b0
sk_destruct+0xa8/0xd0
__sk_free+0x2e8/0x3d0
sk_free+0x51/0x90
netlink_sock_destruct_work+0x1c/0x20
process_one_work+0x411/0x710
worker_thread+0x6fd/0xa80

Link: https://syzkaller.appspot.com/bug?id=fc0fa5a53db9edd261d56e74325419faf18bd0df
Reported-by: syzbot+f9f76f4a0766420b4a02@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20211208182742.340542-1-tadeusz.struk@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -632,8 +632,10 @@ static int nfc_genl_dump_devices_done(st
 {
 	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
 
-	nfc_device_iter_exit(iter);
-	kfree(iter);
+	if (iter) {
+		nfc_device_iter_exit(iter);
+		kfree(iter);
+	}
 
 	return 0;
 }


