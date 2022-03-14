Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351E74D815C
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiCNLkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239173AbiCNLkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:40:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7DF433A9;
        Mon, 14 Mar 2022 04:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F959B80DC3;
        Mon, 14 Mar 2022 11:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3E3C340EC;
        Mon, 14 Mar 2022 11:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257891;
        bh=TL2Y6XQCURGc8QUOBoEvs5HooHQLG4mO1QPY66eFQaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T11ORkm0sUOt3TqpvIURfGa/CgMh3hCm1t6laeod+m+F1bf8O6hcA7Vh7RMEVIBZa
         +v7gSUZ7Liv1x8gzNTTsddjNhgAa/MBB3jDzXwV/47OYnui7NbigODXxDqg0qgv2XC
         wkvCB/PbSi1tFuy91TVfbUppKcv8I0U+saWPx2us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Paul Durrant <paul@xen.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/30] Revert "xen-netback: remove hotplug-status once it has served its purpose"
Date:   Mon, 14 Mar 2022 12:34:32 +0100
Message-Id: <20220314112732.192015961@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.785042288@linuxfoundation.org>
References: <20220314112731.785042288@linuxfoundation.org>
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

[ Upstream commit 0f4558ae91870692ce7f509c31c9d6ee721d8cdc ]

This reverts commit 1f2565780e9b7218cf92c7630130e82dcc0fe9c2.

The 'hotplug-status' node should not be removed as long as the vif
device remains configured. Otherwise the xen-netback would wait for
re-running the network script even if it was already called (in case of
the frontent re-connecting). But also, it _should_ be removed when the
vif device is destroyed (for example when unbinding the driver) -
otherwise hotplug script would not configure the device whenever it
re-appear.

Moving removal of the 'hotplug-status' node was a workaround for nothing
calling network script after xen-netback module is reloaded. But when
vif interface is re-created (on xen-netback unbind/bind for example),
the script should be called, regardless of who does that - currently
this case is not handled by the toolstack, and requires manual
script call. Keeping hotplug-status=connected to skip the call is wrong
and leads to not configured interface.

More discussion at
https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u

Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://lore.kernel.org/r/20220222001817.2264967-1-marmarek@invisiblethingslab.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 78c56149559c..6b678ab0a31f 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -499,6 +499,7 @@ static void backend_disconnect(struct backend_info *be)
 		unsigned int queue_index;
 
 		xen_unregister_watchers(vif);
+		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 #ifdef CONFIG_DEBUG_FS
 		xenvif_debugfs_delif(vif);
 #endif /* CONFIG_DEBUG_FS */
-- 
2.34.1



