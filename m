Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E50549225
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359373AbiFMMaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355536AbiFMM04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:26:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4D7580FE;
        Mon, 13 Jun 2022 04:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5386F61347;
        Mon, 13 Jun 2022 11:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6600EC34114;
        Mon, 13 Jun 2022 11:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118347;
        bh=n6SzDndHEPUeNrIaKwwJ4XJ47Vvoh3ClZO6TlxlfqHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLGHvM7/Z5fuyBh/fvR5RRJCeRzi7Xujgg/UW3vynnG0IQqdueztx3G+lXqsb0f95
         yTTHXvi69eM1ARbjqd7Cy3xrH1caldEvi3ZgXDFybNYo24bE6SGuqSTaz7bA/tUe/Y
         U2d+G48VrQmGEGziebZqS9ruSnm5pBq859b3AHZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/172] driver: base: fix UAF when driver_attach failed
Date:   Mon, 13 Jun 2022 12:10:03 +0200
Message-Id: <20220613094900.747026140@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Schspa Shi <schspa@gmail.com>

[ Upstream commit 310862e574001a97ad02272bac0fd13f75f42a27 ]

When driver_attach(drv); failed, the driver_private will be freed.
But it has been added to the bus, which caused a UAF.

To fix it, we need to delete it from the bus when failed.

Fixes: 190888ac01d0 ("driver core: fix possible missing of device probe")
Signed-off-by: Schspa Shi <schspa@gmail.com>
Link: https://lore.kernel.org/r/20220513112444.45112-1-schspa@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index a9c23ecebc7c..df85e928b97f 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -621,7 +621,7 @@ int bus_add_driver(struct device_driver *drv)
 	if (drv->bus->p->drivers_autoprobe) {
 		error = driver_attach(drv);
 		if (error)
-			goto out_unregister;
+			goto out_del_list;
 	}
 	module_add_driver(drv->owner, drv);
 
@@ -648,6 +648,8 @@ int bus_add_driver(struct device_driver *drv)
 
 	return 0;
 
+out_del_list:
+	klist_del(&priv->knode_bus);
 out_unregister:
 	kobject_put(&priv->kobj);
 	/* drv->p is freed in driver_release()  */
-- 
2.35.1



