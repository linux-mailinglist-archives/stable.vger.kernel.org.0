Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B056676FC0
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjAVPYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbjAVPYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AFC222CD
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C382FB80B1F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17030C433D2;
        Sun, 22 Jan 2023 15:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401091;
        bh=RB5461b5Ysqa7Gf70x+9pUy40oBsumD3xjaFjQaQyZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqQ7E35VQima4oVQWK2dhs90KbYqpdoY8lPwxIDTCRN9AwDzzc3AUfC/GW634qX9Y
         HNENVEyj+pwxIFM70P4XOmbQymgBp3MFJ7T7MiJVI/btlUqk3xn1XOHyBhXKRaGlsS
         lGDelqUjBKqX3xSx4oIdfBPHtCz1MZil7V/bOHUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: [PATCH 6.1 107/193] usb: host: ehci-fsl: Fix module alias
Date:   Sun, 22 Jan 2023 16:03:56 +0100
Message-Id: <20230122150251.216557209@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 5d3d01ae15d2f37ed0325c99ab47ef0ae5d05f3c upstream.

Commit ca07e1c1e4a6 ("drivers:usb:fsl:Make fsl ehci drv an independent
driver module") changed DRV_NAME which was used for MODULE_ALIAS as well.
Starting from this the module alias didn't match the platform device
name created in fsl-mph-dr-of.c
Change DRV_NAME to match the driver name for host mode in fsl-mph-dr-of.
This is needed for module autoloading on ls1021a.

Fixes: ca07e1c1e4a6 ("drivers:usb:fsl:Make fsl ehci drv an independent driver module")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20230120122714.3848784-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-fsl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -29,7 +29,7 @@
 #include "ehci-fsl.h"
 
 #define DRIVER_DESC "Freescale EHCI Host controller driver"
-#define DRV_NAME "ehci-fsl"
+#define DRV_NAME "fsl-ehci"
 
 static struct hc_driver __read_mostly fsl_ehci_hc_driver;
 


