Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE6D59483A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353926AbiHOXm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354246AbiHOXln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E95C6433;
        Mon, 15 Aug 2022 13:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B91D60DEB;
        Mon, 15 Aug 2022 20:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DD4C433C1;
        Mon, 15 Aug 2022 20:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594283;
        bh=o34sXTUOndZN7rms7dNvsb0g/+O2h6wCiBKKVS7Ego8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHim8nfmBydjRI28isEKeC0ViG3roT5k6w7B2S1tdkkjpQU9Cc/LQnIX5ZwxdLV2K
         79e2SjjvHsM/E3S6lNn3MposXO/3zErHatMow1VlPVpFVnfK4neRcjZzM7ZQGi/Sst
         0P4n1hJasux2HlY8eE+i1CNpAF68EkH+ftYG5JTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0371/1157] media: atmel: atmel-sama7g5-isc: fix warning in configs without OF
Date:   Mon, 15 Aug 2022 19:55:27 +0200
Message-Id: <20220815180454.551441709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit b2bae4b8e637dd751d27918a6b27bd5abcd08859 ]

All warnings (new ones prefixed by >>):

>> drivers/media/platform/atmel/atmel-sama7g5-isc.c:610:34: warning: unused variable 'microchip_xisc_of_match' [-Wunused-const-variable]
   static const struct of_device_id microchip_xisc_of_match[] = {
                                    ^
   13 warnings generated.

vim +/microchip_xisc_of_match +610 drivers/media/platform/atmel/atmel-sama7g5-isc.c

   609
 > 610  static const struct of_device_id microchip_xisc_of_match[] = {
   611          { .compatible = "microchip,sama7g5-isc" },
   612          { }
   613  };
   614  MODULE_DEVICE_TABLE(of, microchip_xisc_of_match);
   615

Fixed warning by guarding the atmel_isc_of_match by CONFIG_OF.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c9aa973884a1 ("media: atmel: atmel-isc: add microchip-xisc driver")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-sama7g5-isc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/atmel/atmel-sama7g5-isc.c b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
index 83b175070c06..8b11aa8340d7 100644
--- a/drivers/media/platform/atmel/atmel-sama7g5-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
@@ -591,11 +591,13 @@ static const struct dev_pm_ops microchip_xisc_dev_pm_ops = {
 	SET_RUNTIME_PM_OPS(xisc_runtime_suspend, xisc_runtime_resume, NULL)
 };
 
+#if IS_ENABLED(CONFIG_OF)
 static const struct of_device_id microchip_xisc_of_match[] = {
 	{ .compatible = "microchip,sama7g5-isc" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, microchip_xisc_of_match);
+#endif
 
 static struct platform_driver microchip_xisc_driver = {
 	.probe	= microchip_xisc_probe,
-- 
2.35.1



