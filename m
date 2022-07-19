Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260B8579AA6
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbiGSMRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbiGSMPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:15:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6215B545D3;
        Tue, 19 Jul 2022 05:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1C7D61748;
        Tue, 19 Jul 2022 12:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D5EC341C6;
        Tue, 19 Jul 2022 12:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232331;
        bh=Xm0MwoDW/hV6tsQcoq3CJwBjGnfYANhsNhn7svWmwSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rr3rk3j7d1Q6VkXj8qt2R6X40e+d31mmcauwPBPdUJkW2vvIFrms/5UR6aLrdl3Yf
         I3mUO88SFp8NNcdnmCrR5vMABDt2YEZibKspP6dBUS3o+FrUkDMUWrTj6eXZMlODAO
         KgCekK20J3qBsn5/Co8jhN530gNMpTaO4rigo6L0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>, Paul Durrant <paul@xen.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 007/112] xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue
Date:   Tue, 19 Jul 2022 13:53:00 +0200
Message-Id: <20220719114626.723728058@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 94e8100678889ab428e68acadf042de723f094b9 upstream.

xenvif_rx_next_skb() is expecting the rx queue not being empty, but
in case the loop in xenvif_rx_action() is doing multiple iterations,
the availability of another skb in the rx queue is not being checked.

This can lead to crashes:

[40072.537261] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
[40072.537407] IP: xenvif_rx_skb+0x23/0x590 [xen_netback]
[40072.537534] PGD 0 P4D 0
[40072.537644] Oops: 0000 [#1] SMP NOPTI
[40072.537749] CPU: 0 PID: 12505 Comm: v1-c40247-q2-gu Not tainted 4.12.14-122.121-default #1 SLE12-SP5
[40072.537867] Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 11/23/2021
[40072.537999] task: ffff880433b38100 task.stack: ffffc90043d40000
[40072.538112] RIP: e030:xenvif_rx_skb+0x23/0x590 [xen_netback]
[40072.538217] RSP: e02b:ffffc90043d43de0 EFLAGS: 00010246
[40072.538319] RAX: 0000000000000000 RBX: ffffc90043cd7cd0 RCX: 00000000000000f7
[40072.538430] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffc90043d43df8
[40072.538531] RBP: 000000000000003f R08: 000077ff80000000 R09: 0000000000000008
[40072.538644] R10: 0000000000007ff0 R11: 00000000000008f6 R12: ffffc90043ce2708
[40072.538745] R13: 0000000000000000 R14: ffffc90043d43ed0 R15: ffff88043ea748c0
[40072.538861] FS: 0000000000000000(0000) GS:ffff880484600000(0000) knlGS:0000000000000000
[40072.538988] CS: e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[40072.539088] CR2: 0000000000000080 CR3: 0000000407ac8000 CR4: 0000000000040660
[40072.539211] Call Trace:
[40072.539319] xenvif_rx_action+0x71/0x90 [xen_netback]
[40072.539429] xenvif_kthread_guest_rx+0x14a/0x29c [xen_netback]

Fix that by stopping the loop in case the rx queue becomes empty.

Cc: stable@vger.kernel.org
Fixes: 98f6d57ced73 ("xen-netback: process guest rx packets in batches")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://lore.kernel.org/r/20220713135322.19616-1-jgross@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/rx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -495,6 +495,7 @@ void xenvif_rx_action(struct xenvif_queu
 	queue->rx_copy.completed = &completed_skbs;
 
 	while (xenvif_rx_ring_slots_available(queue) &&
+	       !skb_queue_empty(&queue->rx_queue) &&
 	       work_done < RX_BATCH_SIZE) {
 		xenvif_rx_skb(queue);
 		work_done++;


