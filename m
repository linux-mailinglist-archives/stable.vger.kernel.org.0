Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D7C529009
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239593AbiEPUEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348133AbiEPT60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBE949250;
        Mon, 16 May 2022 12:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D745B81612;
        Mon, 16 May 2022 19:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B49C385AA;
        Mon, 16 May 2022 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730610;
        bh=E6IEgSzYAeio9Qxj1EaJrujKdyR+K6hkdC/qFq7fLfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpXxfd5mBgi0D7dwb7R6DKO8VatY/KecuPsBaYcw4zt55w4NgQ+RCQR8s/TFvNvAP
         B3qC+5P79njWpKe6qJQix1PD7Fnbj9GuGJkegrUpDIzp/7tCsyLoH/lfzjLwrjgaN+
         u4U63OWwjgacB52l10p6bhp9N03mn94HMZXTj7fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bla=C5=BE=20Hrastnik?= <blaz@mxxn.io>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/102] platform/surface: aggregator: Fix initialization order when compiling as builtin module
Date:   Mon, 16 May 2022 21:35:47 +0200
Message-Id: <20220516193624.377408906@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 44acfc22c7d055d9c4f8f0974ee28422405b971a ]

When building the Surface Aggregator Module (SAM) core, registry, and
other SAM client drivers as builtin modules (=y), proper initialization
order is not guaranteed. Due to this, client driver registration
(triggered by device registration in the registry) races against bus
initialization in the core.

If any attempt is made at registering the device driver before the bus
has been initialized (i.e. if bus initialization fails this race) driver
registration will fail with a message similar to:

    Driver surface_battery was unable to register with bus_type surface_aggregator because the bus was not initialized

Switch from module_init() to subsys_initcall() to resolve this issue.
Note that the serdev subsystem uses postcore_initcall() so we are still
able to safely register the serdev device driver for the core.

Fixes: c167b9c7e3d6 ("platform/surface: Add Surface Aggregator subsystem")
Reported-by: Blaž Hrastnik <blaz@mxxn.io>
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20220429195738.535751-1-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/aggregator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/surface/aggregator/core.c b/drivers/platform/surface/aggregator/core.c
index c61bbeeec2df..54f86df77a37 100644
--- a/drivers/platform/surface/aggregator/core.c
+++ b/drivers/platform/surface/aggregator/core.c
@@ -816,7 +816,7 @@ static int __init ssam_core_init(void)
 err_bus:
 	return status;
 }
-module_init(ssam_core_init);
+subsys_initcall(ssam_core_init);
 
 static void __exit ssam_core_exit(void)
 {
-- 
2.35.1



