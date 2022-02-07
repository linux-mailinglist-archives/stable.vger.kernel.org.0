Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A834ABBB4
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384727AbiBGL3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383325AbiBGLWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:22:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C93DC043181;
        Mon,  7 Feb 2022 03:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0393B81158;
        Mon,  7 Feb 2022 11:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FDCC004E1;
        Mon,  7 Feb 2022 11:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232929;
        bh=BrOeKKIu/c6Ewayd+Wwum8dmrbUTc5f982drrQndTvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETIl3L5Yt4Kdn/V8kuVOqxK7Yw1cMqHIlmAVyBhxTzpJsPO6nSzcQZ0+0bCgxU7H6
         d2SyDlLkvG5dTUF5mCrN8uCVODS8lM/1tV75uoOOXfEUChYUp9fqmvuj+xkSKaOMQE
         zKSSbJKblz0IEq2B9RyzwpGa9y1N8N+0mspl+8nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.10 36/74] net: ieee802154: hwsim: Ensure proper channel selection at probe time
Date:   Mon,  7 Feb 2022 12:06:34 +0100
Message-Id: <20220207103758.416535720@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 1293fccc9e892712d910ec96079d3717307f1d2d upstream.

Drivers are expected to set the PHY current_channel and current_page
according to their default state. The hwsim driver is advertising being
configured on channel 13 by default but that is not reflected in its own
internal pib structure. In order to ensure that this driver consider the
current channel as being 13 internally, we at least need to set the
pib->channel field to 13.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[stefan@datenfreihafen.org: fixed assigment from page to channel]
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20220125121426.848337-2-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -786,6 +786,7 @@ static int hwsim_add_one(struct genl_inf
 		goto err_pib;
 	}
 
+	pib->channel = 13;
 	rcu_assign_pointer(phy->pib, pib);
 	phy->idx = idx;
 	INIT_LIST_HEAD(&phy->edges);


