Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D70563556F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbiKWJSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237418AbiKWJSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:18:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914C98F3D7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:18:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCF8961B4D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF848C433C1;
        Wed, 23 Nov 2022 09:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195084;
        bh=YeMfzna7H0lZEaGhE908T2fvpo6mTj7Cd4M+hkiWy54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tz+OmYUvvLRXndAaDpwSIXsxl1nc4K1HPUbWVjPC9Iudgwux/4bHBcYXYwUej88W3
         mjaU4guxSIep5DdNIBaQSZtIGcy1wUYVq+/bnmpsk0fgcczqCMd0vOgUnqwKAPx5wP
         MZquTCyAMb/TF8aUaCBOO58ZEeRD6j9HMhR6s/i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Jun <chenjun102@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/156] Input: i8042 - fix leaking of platform device on module removal
Date:   Wed, 23 Nov 2022 09:51:40 +0100
Message-Id: <20221123084603.045182117@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jun <chenjun102@huawei.com>

[ Upstream commit 81cd7e8489278d28794e7b272950c3e00c344e44 ]

Avoid resetting the module-wide i8042_platform_device pointer in
i8042_probe() or i8042_remove(), so that the device can be properly
destroyed by i8042_exit() on module unload.

Fixes: 9222ba68c3f4 ("Input: i8042 - add deferred probe support")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Link: https://lore.kernel.org/r/20221109034148.23821-1-chenjun102@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index bb76ff2f6b1d..dc40f6099dcf 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1540,8 +1540,6 @@ static int i8042_probe(struct platform_device *dev)
 {
 	int error;
 
-	i8042_platform_device = dev;
-
 	if (i8042_reset == I8042_RESET_ALWAYS) {
 		error = i8042_controller_selftest();
 		if (error)
@@ -1579,7 +1577,6 @@ static int i8042_probe(struct platform_device *dev)
 	i8042_free_aux_ports();	/* in case KBD failed but AUX not */
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return error;
 }
@@ -1589,7 +1586,6 @@ static int i8042_remove(struct platform_device *dev)
 	i8042_unregister_ports();
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return 0;
 }
-- 
2.35.1



