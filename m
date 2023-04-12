Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADE46DF134
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 11:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjDLJ4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 05:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDLJ4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 05:56:01 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DF47295;
        Wed, 12 Apr 2023 02:55:56 -0700 (PDT)
Received: (Authenticated sender: cyril@debamax.com)
        by mail.gandi.net (Postfix) with ESMTPA id 877F71C0003;
        Wed, 12 Apr 2023 09:55:53 +0000 (UTC)
From:   Cyril Brulebois <cyril@debamax.com>
To:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Rob Herring <robh@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        linux-kernel@vger.kernel.org, Cyril Brulebois <cyril@debamax.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] drm/ofdrm: Update expected device name
Date:   Wed, 12 Apr 2023 11:55:09 +0200
Message-Id: <20230412095509.2196162-3-cyril@debamax.com>
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

Given the code similarity it is likely to affect ofdrm in the same way.

It might be better to iterate on all possible nodes, but updating the
hardcoded device from "of-display" to "of-display.0" is likely to help
as a first step.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217328
Link: https://bugs.debian.org/1033058
Fixes: 241d2fb56a18 ("of: Make OF framebuffer device names unique")
Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Cyril Brulebois <cyril@debamax.com>
---
 drivers/gpu/drm/tiny/ofdrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/ofdrm.c b/drivers/gpu/drm/tiny/ofdrm.c
index 6e349ca42485..92df021d71df 100644
--- a/drivers/gpu/drm/tiny/ofdrm.c
+++ b/drivers/gpu/drm/tiny/ofdrm.c
@@ -1390,7 +1390,7 @@ MODULE_DEVICE_TABLE(of, ofdrm_of_match_display);
 
 static struct platform_driver ofdrm_platform_driver = {
 	.driver = {
-		.name = "of-display",
+		.name = "of-display.0",
 		.of_match_table = ofdrm_of_match_display,
 	},
 	.probe = ofdrm_probe,
-- 
2.30.2

