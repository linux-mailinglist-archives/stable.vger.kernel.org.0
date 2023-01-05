Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1726165EC2D
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjAENHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbjAENGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:06:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC475AC61;
        Thu,  5 Jan 2023 05:06:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9111B81AD2;
        Thu,  5 Jan 2023 13:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C7BC433EF;
        Thu,  5 Jan 2023 13:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923993;
        bh=U+cQHrDmIK+r9qwVg+CRg/eCGO+GgpLzZ8wc3TPMRA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+xAFU6ZkOhDiUD2ZAuNrfqE5in3Pf/YQelImqB46sDX1Y+IW4k6qrIG+Zw1SkndD
         9K5Ne7W3J0mA9uBzfm4jFUVe0yIYnlN8buHIyd2cqdSuRUtlpcvcdD96gHubuYignY
         0g+r2VT/Nt9Ywyw8POAAQzzrvsjkFGZnimWCpPaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Mackerras <paulus@samba.org>,
        linux-ppp@vger.kernel.org,
        syzbot+41cab52ab62ee99ed24a@syzkaller.appspotmail.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 200/251] ppp: associate skb with a device at tx
Date:   Thu,  5 Jan 2023 13:55:37 +0100
Message-Id: <20230105125344.006663457@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 9f225444467b98579cf28d94f4ad053460dfdb84 ]

Syzkaller triggered flow dissector warning with the following:

r0 = openat$ppp(0xffffffffffffff9c, &(0x7f0000000000), 0xc0802, 0x0)
ioctl$PPPIOCNEWUNIT(r0, 0xc004743e, &(0x7f00000000c0))
ioctl$PPPIOCSACTIVE(r0, 0x40107446, &(0x7f0000000240)={0x2, &(0x7f0000000180)=[{0x20, 0x0, 0x0, 0xfffff034}, {0x6}]})
pwritev(r0, &(0x7f0000000040)=[{&(0x7f0000000140)='\x00!', 0x2}], 0x1, 0x0, 0x0)

[    9.485814] WARNING: CPU: 3 PID: 329 at net/core/flow_dissector.c:1016 __skb_flow_dissect+0x1ee0/0x1fa0
[    9.485929]  skb_get_poff+0x53/0xa0
[    9.485937]  bpf_skb_get_pay_offset+0xe/0x20
[    9.485944]  ? ppp_send_frame+0xc2/0x5b0
[    9.485949]  ? _raw_spin_unlock_irqrestore+0x40/0x60
[    9.485958]  ? __ppp_xmit_process+0x7a/0xe0
[    9.485968]  ? ppp_xmit_process+0x5b/0xb0
[    9.485974]  ? ppp_write+0x12a/0x190
[    9.485981]  ? do_iter_write+0x18e/0x2d0
[    9.485987]  ? __import_iovec+0x30/0x130
[    9.485997]  ? do_pwritev+0x1b6/0x240
[    9.486016]  ? trace_hardirqs_on+0x47/0x50
[    9.486023]  ? __x64_sys_pwritev+0x24/0x30
[    9.486026]  ? do_syscall_64+0x3d/0x80
[    9.486031]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd

Flow dissector tries to find skb net namespace either via device
or via socket. Neigher is set in ppp_send_frame, so let's manually
use ppp->dev.

Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-ppp@vger.kernel.org
Reported-by: syzbot+41cab52ab62ee99ed24a@syzkaller.appspotmail.com
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 6287d2ad77c6..f6cf25cba16e 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1541,6 +1541,8 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 	int len;
 	unsigned char *cp;
 
+	skb->dev = ppp->dev;
+
 	if (proto < 0x8000) {
 #ifdef CONFIG_PPP_FILTER
 		/* check if we should pass this packet */
-- 
2.35.1



