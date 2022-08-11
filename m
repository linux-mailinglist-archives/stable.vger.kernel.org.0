Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6F059034E
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbiHKQVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237916AbiHKQU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:20:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA48EB02B3;
        Thu, 11 Aug 2022 09:03:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BC64B82182;
        Thu, 11 Aug 2022 16:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA56C433D6;
        Thu, 11 Aug 2022 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233794;
        bh=dfGDc5y7t1OJDZv5DDOhjgv3vAFicA7oBOPSO6VEFVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ue5BWd73wF3zzmgULqka0NNmbdwuECVo1I59zAbslPKkD36R/z9fvEK580HnCXfmE
         gMiWk7Y/A3JCy7svM4QFz7otUb9ydQ621cO04d7hMBaUH5GuTRdEYJnITQLZUG1ifO
         KkQ82rYvBqF7GUy8g6ZanNwQW18p306iODEDmIL8Xl/6CVAsdzxaAFxL5Qh0HfWeMW
         flHnKPyxGdL/0fjcFrxXdzvA0tWkso4WxnxYSdzm4rLY1MiEbRs3y1jd2tVy6t7+7l
         vvU5/kRMrQusCwkevgFmQMJb0RFGXZmyyv6e9eZ9N68u2jrBAmLBQcda4pY0MD7lgh
         PpkkJBW4BoY/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 56/69] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Date:   Thu, 11 Aug 2022 11:56:05 -0400
Message-Id: <20220811155632.1536867-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>

[ Upstream commit 5588d628027092e66195097bdf6835ddf64418b3 ]

DisplayLink ethernet devices require NTB buffers larger then 32kb
in order to run with highest performance.

This patch is changing upper limit of the rx and tx buffers.
Those buffers are initialized with CDC_NCM_NTB_DEF_SIZE_RX and
CDC_NCM_NTB_DEF_SIZE_TX which is 16kb so by default no device is
affected by increased limit.

Rx and tx buffer is increased under two conditions:
 - Device need to advertise that it supports higher buffer size in
   dwNtbMaxInMaxSize and dwNtbMaxOutMaxSize.
 - cdc_ncm/rx_max and cdc_ncm/tx_max driver parameters must be adjusted
   with udev rule or ethtool.

Summary of testing and performance results:
Tests were performed on following devices:
 - DisplayLink DL-3xxx family device
 - DisplayLink DL-6xxx family device
 - ASUS USB-C2500 2.5G USB3 ethernet adapter
 - Plugable USB3 1G USB3 ethernet adapter
 - EDIMAX EU-4307 USB-C ethernet adapter
 - Dell DBQBCBC064 USB-C ethernet adapter

Performance measurements were done with:
 - iperf3 between two linux boxes
 - http://openspeedtest.com/ instance running on local test machine

Insights from tests results:
 - All except one from third party usb adapters were not affected by
   increased buffer size to their advertised dwNtbOutMaxSize and
   dwNtbInMaxSize.
   Devices were generally reaching 912-940Mbps both download and upload.

   Only EDIMAX adapter experienced decreased download size from
   929Mbps to 827Mbps with iper3, with openspeedtest decrease was from
   968Mbps to 886Mbps.

 - DisplayLink DL-3xxx family devices experienced performance increase
   with iperf3 download from 300Mbps to 870Mbps and
   upload from 782Mbps to 844Mbps.
   With openspeedtest download increased from 556Mbps to 873Mbps
   and upload from 727Mbps to 973Mbps

 - DiplayLink DL-6xxx family devices are not affected by
   increased buffer size.

Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220720060518.541-2-lukasz.spintzyk@synaptics.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/usb/cdc_ncm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
index f7cb3ddce7fb..2d207cb4837d 100644
--- a/include/linux/usb/cdc_ncm.h
+++ b/include/linux/usb/cdc_ncm.h
@@ -53,8 +53,8 @@
 #define USB_CDC_NCM_NDP32_LENGTH_MIN		0x20
 
 /* Maximum NTB length */
-#define	CDC_NCM_NTB_MAX_SIZE_TX			32768	/* bytes */
-#define	CDC_NCM_NTB_MAX_SIZE_RX			32768	/* bytes */
+#define	CDC_NCM_NTB_MAX_SIZE_TX			65536	/* bytes */
+#define	CDC_NCM_NTB_MAX_SIZE_RX			65536	/* bytes */
 
 /* Initial NTB length */
 #define	CDC_NCM_NTB_DEF_SIZE_TX			16384	/* bytes */
-- 
2.35.1

