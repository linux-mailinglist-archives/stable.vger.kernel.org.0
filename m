Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9335AAF71
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbiIBMiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbiIBMhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:37:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2050A10FF;
        Fri,  2 Sep 2022 05:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D9076211C;
        Fri,  2 Sep 2022 12:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E96C433D7;
        Fri,  2 Sep 2022 12:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121402;
        bh=c38qPjBlwIU12u9Uk9yjYbiD99ZrXmEcOmC9gitduTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqttkCobkVthfNQpMlcz/MgOtRr3YoPpZVHIsbyHxM29Q45QXdxtrIb5TU1iJdcbE
         mICdr+t5XhsHvOMBUj4oaif9YxwFROyX/hPTY68BSQ6DtE38oQNrOhsBOdnDzzOn06
         G0I6t/63niYKsJ3pVOd7BuUWCKA387TVk91KscNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        Sainath Grandhi <sainath.grandhi@intel.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/42] net: ipvtap - add __init/__exit annotations to module init/exit funcs
Date:   Fri,  2 Sep 2022 14:18:32 +0200
Message-Id: <20220902121359.087699818@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121358.773776406@linuxfoundation.org>
References: <20220902121358.773776406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit 4b2e3a17e9f279325712b79fb01d1493f9e3e005 ]

Looks to have been left out in an oversight.

Cc: Mahesh Bandewar <maheshb@google.com>
Cc: Sainath Grandhi <sainath.grandhi@intel.com>
Fixes: 235a9d89da97 ('ipvtap: IP-VLAN based tap driver')
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20220821130808.12143-1-zenczykowski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvtap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index 0bcc07f346c3e..2e517e30c5ac1 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -193,7 +193,7 @@ static struct notifier_block ipvtap_notifier_block __read_mostly = {
 	.notifier_call	= ipvtap_device_event,
 };
 
-static int ipvtap_init(void)
+static int __init ipvtap_init(void)
 {
 	int err;
 
@@ -227,7 +227,7 @@ static int ipvtap_init(void)
 }
 module_init(ipvtap_init);
 
-static void ipvtap_exit(void)
+static void __exit ipvtap_exit(void)
 {
 	rtnl_link_unregister(&ipvtap_link_ops);
 	unregister_netdevice_notifier(&ipvtap_notifier_block);
-- 
2.35.1



