Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8EC5488CC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382614AbiFMOSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381967AbiFMOQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:16:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16D2A0076;
        Mon, 13 Jun 2022 04:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAE666124E;
        Mon, 13 Jun 2022 11:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E24C34114;
        Mon, 13 Jun 2022 11:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120604;
        bh=uocWnAIGDj1N1SgxSfZcGZiwjslXY7sezSgDHKrzoow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hm+gtZDNz1TC+N5Hb3qQxwix4MdH8CRoduU7rQIYR1g6ASqhx9GcY9krU17OcB0Bu
         DDTvTypCZ8x9k/a5qzvfYpFfmWKWgawGSjeVyHq4rNOzDDLtjDtzj6/ilE7gYPDR2I
         Gz5HNfxdNZm/eDsXoN5Ev6fp31gUg2TAKOkpRAU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 069/298] driver: base: fix UAF when driver_attach failed
Date:   Mon, 13 Jun 2022 12:09:23 +0200
Message-Id: <20220613094927.039700488@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index 97936ec49bde..7ca47e5b3c1f 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -617,7 +617,7 @@ int bus_add_driver(struct device_driver *drv)
 	if (drv->bus->p->drivers_autoprobe) {
 		error = driver_attach(drv);
 		if (error)
-			goto out_unregister;
+			goto out_del_list;
 	}
 	module_add_driver(drv->owner, drv);
 
@@ -644,6 +644,8 @@ int bus_add_driver(struct device_driver *drv)
 
 	return 0;
 
+out_del_list:
+	klist_del(&priv->knode_bus);
 out_unregister:
 	kobject_put(&priv->kobj);
 	/* drv->p is freed in driver_release()  */
-- 
2.35.1



