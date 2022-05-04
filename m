Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2AF51A609
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353787AbiEDQwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353735AbiEDQwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0795647068;
        Wed,  4 May 2022 09:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99AE961771;
        Wed,  4 May 2022 16:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BE1C385AA;
        Wed,  4 May 2022 16:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682911;
        bh=9E39mHLbOPtkiWOEOKFy56IbZL3g5wvMyD0A5kF6R7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfqJK91F/YwS7hhUynWLhE+qpQxFF1z5eg+MOIc72P/OJq02DBH9lWAhh1YmAG0fD
         DfsXZTcs4t/iNlhcINYPlS8I3KnPN9SYA4Wq5nLRITXrR/rjmZk49n+v65Dw5ax59W
         mcFLyBo3qgITZAonwW1a25IVygIBlPBT99Lr5vvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH 5.4 17/84] usb: misc: fix improper handling of refcount in uss720_probe()
Date:   Wed,  4 May 2022 18:43:58 +0200
Message-Id: <20220504152929.009802977@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit 0a96fa640dc928da9eaa46a22c46521b037b78ad upstream.

usb_put_dev shouldn't be called when uss720_probe succeeds because of
priv->usbdev. At the same time, priv->usbdev shouldn't be set to NULL
before destroy_priv in uss720_disconnect because usb_put_dev is in
destroy_priv.

Fix this by moving priv->usbdev = NULL after usb_put_dev.

Fixes: dcb4b8ad6a44 ("misc/uss720: fix memory leak in uss720_probe")
Cc: stable <stable@kernel.org>
Reviewed-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220407024001.11761-1-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/uss720.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -71,6 +71,7 @@ static void destroy_priv(struct kref *kr
 
 	dev_dbg(&priv->usbdev->dev, "destroying priv datastructure\n");
 	usb_put_dev(priv->usbdev);
+	priv->usbdev = NULL;
 	kfree(priv);
 }
 
@@ -736,7 +737,6 @@ static int uss720_probe(struct usb_inter
 	parport_announce_port(pp);
 
 	usb_set_intfdata(intf, pp);
-	usb_put_dev(usbdev);
 	return 0;
 
 probe_abort:
@@ -754,7 +754,6 @@ static void uss720_disconnect(struct usb
 	usb_set_intfdata(intf, NULL);
 	if (pp) {
 		priv = pp->private_data;
-		priv->usbdev = NULL;
 		priv->pp = NULL;
 		dev_dbg(&intf->dev, "parport_remove_port\n");
 		parport_remove_port(pp);


