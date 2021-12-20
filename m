Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE0747AC3E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbhLTOme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:42:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35134 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbhLTOlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:41:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A840A61141;
        Mon, 20 Dec 2021 14:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9431AC36AE7;
        Mon, 20 Dec 2021 14:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011274;
        bh=Bj0uBuSc9jWNieSGpflWKchOXdyNFPMPTs8DMQKlBPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVTLgHS2OEu1gYsShI9vBMJ8m0jU/mKYXj7Bf3WC6+xD3P1ZNe5QRVeZ4x6yzwhSl
         5O/aymhorElvYBh3aOF0sKjModF74rzZKRNU8LViPt6A7xZqLXbyF9U70F6eXkkdKU
         y+y6XE7CB0qBdJd8gtMM2ps7TdJrm/tkfg4ahY+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f9f76f4a0766420b4a02@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 02/56] nfc: fix segfault in nfc_genl_dump_devices_done
Date:   Mon, 20 Dec 2021 15:33:55 +0100
Message-Id: <20211220143023.529863408@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -655,8 +655,10 @@ static int nfc_genl_dump_devices_done(st
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


