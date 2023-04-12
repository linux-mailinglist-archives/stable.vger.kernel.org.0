Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C726DEE90
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjDLImn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjDLImV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:42:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E52F1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB93263079
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA996C433EF;
        Wed, 12 Apr 2023 08:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288904;
        bh=nS414579cCkCyebrkAtx/4frSjcIZbbiJFvk+50Bu24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iqd/fjAM8Qwl0sAEjAooKFro9B4q9Stb6jFmasmqsLoW9atKdzZhfPO7XWapDFbEs
         93OaTtiQ062oLJuPYYccbzwDujXenLn19iuiUvagUIUu+kkpyXyo+be5QBk5pLeMGy
         30eevnjyNEwid70rAL/oUxwhcB5eXZN5gVAfUNOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wayne Chang <waynec@nvidia.com>,
        Haotien Hsu <haotienh@nvidia.com>
Subject: [PATCH 6.1 062/164] usb: xhci: tegra: fix sleep in atomic call
Date:   Wed, 12 Apr 2023 10:33:04 +0200
Message-Id: <20230412082839.457652988@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Chang <waynec@nvidia.com>

commit 4c7f9d2e413dc06a157c4e5dccde84aaf4655eb3 upstream.

When we set the dual-role port to Host mode, we observed the following
splat:
[  167.057718] BUG: sleeping function called from invalid context at
include/linux/sched/mm.h:229
[  167.057872] Workqueue: events tegra_xusb_usb_phy_work
[  167.057954] Call trace:
[  167.057962]  dump_backtrace+0x0/0x210
[  167.057996]  show_stack+0x30/0x50
[  167.058020]  dump_stack_lvl+0x64/0x84
[  167.058065]  dump_stack+0x14/0x34
[  167.058100]  __might_resched+0x144/0x180
[  167.058140]  __might_sleep+0x64/0xd0
[  167.058171]  slab_pre_alloc_hook.constprop.0+0xa8/0x110
[  167.058202]  __kmalloc_track_caller+0x74/0x2b0
[  167.058233]  kvasprintf+0xa4/0x190
[  167.058261]  kasprintf+0x58/0x90
[  167.058285]  tegra_xusb_find_port_node.isra.0+0x58/0xd0
[  167.058334]  tegra_xusb_find_port+0x38/0xa0
[  167.058380]  tegra_xusb_padctl_get_usb3_companion+0x38/0xd0
[  167.058430]  tegra_xhci_id_notify+0x8c/0x1e0
[  167.058473]  notifier_call_chain+0x88/0x100
[  167.058506]  atomic_notifier_call_chain+0x44/0x70
[  167.058537]  tegra_xusb_usb_phy_work+0x60/0xd0
[  167.058581]  process_one_work+0x1dc/0x4c0
[  167.058618]  worker_thread+0x54/0x410
[  167.058650]  kthread+0x188/0x1b0
[  167.058672]  ret_from_fork+0x10/0x20

The function tegra_xusb_padctl_get_usb3_companion eventually calls
tegra_xusb_find_port and this in turn calls kasprintf which might sleep
and so cannot be called from an atomic context.

Fix this by moving the call to tegra_xusb_padctl_get_usb3_companion to
the tegra_xhci_id_work function where it is really needed.

Fixes: f836e7843036 ("usb: xhci-tegra: Add OTG support")
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Signed-off-by: Haotien Hsu <haotienh@nvidia.com>
Link: https://lore.kernel.org/r/20230327095548.1599470-1-haotienh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1225,6 +1225,9 @@ static void tegra_xhci_id_work(struct wo
 
 	mutex_unlock(&tegra->lock);
 
+	tegra->otg_usb3_port = tegra_xusb_padctl_get_usb3_companion(tegra->padctl,
+								    tegra->otg_usb2_port);
+
 	if (tegra->host_mode) {
 		/* switch to host mode */
 		if (tegra->otg_usb3_port >= 0) {
@@ -1339,9 +1342,6 @@ static int tegra_xhci_id_notify(struct n
 	}
 
 	tegra->otg_usb2_port = tegra_xusb_get_usb2_port(tegra, usbphy);
-	tegra->otg_usb3_port = tegra_xusb_padctl_get_usb3_companion(
-							tegra->padctl,
-							tegra->otg_usb2_port);
 
 	tegra->host_mode = (usbphy->last_event == USB_EVENT_ID) ? true : false;
 


