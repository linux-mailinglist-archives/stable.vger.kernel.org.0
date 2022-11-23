Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B758F6354BF
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbiKWJJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237047AbiKWJIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:08:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422D36334
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:08:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC0CDB81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22233C433C1;
        Wed, 23 Nov 2022 09:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194519;
        bh=zRrtcxO3mtb3gKxu3WPEtvVkdAyfEjPyGaK50ToQ/2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUOj/risffhiANB3mt5thxSvIcfIka+Q4wpidwu92+VbKeK7xGT1B1ftDuYQNKWOH
         +u0oYQKO9ZlzhA05bGhVQIbmC9aGzkIaxLY83NtAwNdLmnvUAiJr/4EWDETYNAOT4M
         WfsmBgFG7RrjPvo0myhZYsey5fmN1Ega8NoJQDeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Jun <chenjun102@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/114] Input: i8042 - fix leaking of platform device on module removal
Date:   Wed, 23 Nov 2022 09:51:27 +0100
Message-Id: <20221123084555.745403481@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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
index 082afbf088d6..c9b51511b33d 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1544,8 +1544,6 @@ static int i8042_probe(struct platform_device *dev)
 {
 	int error;
 
-	i8042_platform_device = dev;
-
 	if (i8042_reset == I8042_RESET_ALWAYS) {
 		error = i8042_controller_selftest();
 		if (error)
@@ -1583,7 +1581,6 @@ static int i8042_probe(struct platform_device *dev)
 	i8042_free_aux_ports();	/* in case KBD failed but AUX not */
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return error;
 }
@@ -1593,7 +1590,6 @@ static int i8042_remove(struct platform_device *dev)
 	i8042_unregister_ports();
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return 0;
 }
-- 
2.35.1



