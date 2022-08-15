Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85AD5940FA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240084AbiHOU4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347007AbiHOU4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5C23C15E;
        Mon, 15 Aug 2022 12:11:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ACE8B810A3;
        Mon, 15 Aug 2022 19:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AAFC433C1;
        Mon, 15 Aug 2022 19:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590711;
        bh=yoQg6NKdMlJWBXAeCm7pQmdhWY0gthNK7cvvUtgPvxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaEyb97Xx8tDya1NemuXuHw7u9z2tnzBiJ8tbwHY5pZkVUgA4SLUNwLCkpKcuxvqH
         oOPkKM+PTi5Dzvcmeo9Z53LbkPL2YHjjd3qv9UL9TWy5Ms4OajZW7PLOq2uvK8O0/L
         HzW/GVwqDL/W6Swu8G9RqoQ9At2PMcRgiRcnfqc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0347/1095] media: atmel: atmel-sama7g5-isc: fix warning in configs without OF
Date:   Mon, 15 Aug 2022 19:55:46 +0200
Message-Id: <20220815180444.139026910@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 07a80b08bc54..e292a8d790a3 100644
--- a/drivers/media/platform/atmel/atmel-sama7g5-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
@@ -612,11 +612,13 @@ static const struct dev_pm_ops microchip_xisc_dev_pm_ops = {
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



