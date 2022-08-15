Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8A7593777
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243058AbiHOSou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243004AbiHOSnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:43:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9743D29CB8;
        Mon, 15 Aug 2022 11:26:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 537D2B8107A;
        Mon, 15 Aug 2022 18:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9521C433C1;
        Mon, 15 Aug 2022 18:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588006;
        bh=z/yU3AHakXSnub2TkT7CGnzttRrLNEnyvwIiYdqnSNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNcs/DR/cPVWg2Rfi0vtUtphgCKrGGCSd2oO0SnvdEOsvN7/h+EhOJ9XDvlVtIN9U
         t/BP2ZGIs5fwIUg2VnjoLIOxUFdgRky1S/jPxsJ0IVllirl1cnetJj1JfSvzku2Bo/
         b0tqODzHgLMCgGiZ/UYj66GnY2ZbDHow4YwsXcP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/779] media: atmel: atmel-sama7g5-isc: fix warning in configs without OF
Date:   Mon, 15 Aug 2022 19:58:30 +0200
Message-Id: <20220815180348.730259275@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 6a5d3f7ce75e..a4defc30cf41 100644
--- a/drivers/media/platform/atmel/atmel-sama7g5-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
@@ -587,11 +587,13 @@ static const struct dev_pm_ops microchip_xisc_dev_pm_ops = {
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



