Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F326F6DF132
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 11:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjDLJz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 05:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjDLJzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 05:55:55 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF0C7DA4;
        Wed, 12 Apr 2023 02:55:51 -0700 (PDT)
Received: (Authenticated sender: cyril@debamax.com)
        by mail.gandi.net (Postfix) with ESMTPA id 954CF1C000B;
        Wed, 12 Apr 2023 09:55:48 +0000 (UTC)
From:   Cyril Brulebois <cyril@debamax.com>
To:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Rob Herring <robh@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        linux-kernel@vger.kernel.org, Cyril Brulebois <cyril@debamax.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] fbdev/offb: Update expected device name
Date:   Wed, 12 Apr 2023 11:55:08 +0200
Message-Id: <20230412095509.2196162-2-cyril@debamax.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230412095509.2196162-1-cyril@debamax.com>
References: <20230412095509.2196162-1-cyril@debamax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 241d2fb56a18 ("of: Make OF framebuffer device names unique"),
as spotted by Frédéric Bonnard, the historical "of-display" device is
gone: the updated logic creates "of-display.0" instead, then as many
"of-display.N" as required.

This means that offb no longer finds the expected device, which prevents
the Debian Installer from setting up its interface, at least on ppc64el.

It might be better to iterate on all possible nodes, but updating the
hardcoded device from "of-display" to "of-display.0" is confirmed to fix
the Debian Installer at the very least.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217328
Link: https://bugs.debian.org/1033058
Fixes: 241d2fb56a18 ("of: Make OF framebuffer device names unique")
Cc: stable@vger.kernel.org
Signed-off-by: Cyril Brulebois <cyril@debamax.com>
---
 drivers/video/fbdev/offb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/offb.c b/drivers/video/fbdev/offb.c
index b97d251d894b..6264c7184457 100644
--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -698,7 +698,7 @@ MODULE_DEVICE_TABLE(of, offb_of_match_display);
 
 static struct platform_driver offb_driver_display = {
 	.driver = {
-		.name = "of-display",
+		.name = "of-display.0",
 		.of_match_table = offb_of_match_display,
 	},
 	.probe = offb_probe_display,
-- 
2.30.2

