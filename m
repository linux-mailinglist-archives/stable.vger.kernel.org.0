Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA004D830F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239491AbiCNMMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242462AbiCNMKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:10:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07FD140A7;
        Mon, 14 Mar 2022 05:08:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8BFAB80DF0;
        Mon, 14 Mar 2022 12:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F157DC340E9;
        Mon, 14 Mar 2022 12:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259700;
        bh=ggBfsXFAbHLCW/U0wi05vrwQYAKaP3g9I/kK8Sip/XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPKE+r6JKoiejyCfmftOWSZViyA8PphMSlZvVKr6QHTK1gsnRKmMWZMdM3DGK/pGi
         ScmIOYGtO/vOqXJsd5+Ln4H7DbktB9WogA2Qx9GW+tyQu3L2W9XOfw07kE21dgi42A
         K9gf1yiZAl/LNbgRjQ9ovcELhloOb2pxLhvd9gYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Paul Durrant <paul@xen.org>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/110] Revert "xen-netback: Check for hotplug-status existence before watching"
Date:   Mon, 14 Mar 2022 12:54:10 +0100
Message-Id: <20220314112744.933992422@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

[ Upstream commit e8240addd0a3919e0fd7436416afe9aa6429c484 ]

This reverts commit 2afeec08ab5c86ae21952151f726bfe184f6b23d.

The reasoning in the commit was wrong - the code expected to setup the
watch even if 'hotplug-status' didn't exist. In fact, it relied on the
watch being fired the first time - to check if maybe 'hotplug-status' is
already set to 'connected'. Not registering a watch for non-existing
path (which is the case if hotplug script hasn't been executed yet),
made the backend not waiting for the hotplug script to execute. This in
turns, made the netfront think the interface is fully operational, while
in fact it was not (the vif interface on xen-netback side might not be
configured yet).

This was a workaround for 'hotplug-status' erroneously being removed.
But since that is reverted now, the workaround is not necessary either.

More discussion at
https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u

Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Reviewed-by: Michael Brown <mbrown@fensystems.co.uk>
Link: https://lore.kernel.org/r/20220222001817.2264967-2-marmarek@invisiblethingslab.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 3fad58d22155..990360d75cb6 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -824,15 +824,11 @@ static void connect(struct backend_info *be)
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	if (xenbus_exists(XBT_NIL, dev->nodename, "hotplug-status")) {
-		err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
-					   NULL, hotplug_status_changed,
-					   "%s/%s", dev->nodename,
-					   "hotplug-status");
-		if (err)
-			goto err;
+	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
+				   hotplug_status_changed,
+				   "%s/%s", dev->nodename, "hotplug-status");
+	if (!err)
 		be->have_hotplug_status_watch = 1;
-	}
 
 	netif_tx_wake_all_queues(be->vif->dev);
 
-- 
2.34.1



