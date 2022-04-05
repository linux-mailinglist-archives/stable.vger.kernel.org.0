Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2D94F3835
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376428AbiDELV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349427AbiDEJtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D856548;
        Tue,  5 Apr 2022 02:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF3D61576;
        Tue,  5 Apr 2022 09:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233ABC385A2;
        Tue,  5 Apr 2022 09:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151934;
        bh=Wo3qURxNOmx313HrkJXbHsYdZQWj33iWhYmabLSxV7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11KXF/+c4RDrMkKF/XMfiWkGIGpFxLEE8sGocp3iMNklFO5lCvBY80T0mPXIWRwuN
         oiJJDG4cPQ46cPnuMIxF3XiZktE+PfLd+qvc6cMWydHvdq/OePcb3XZ37EG2baCTk2
         aZIyVfc0MTUAMzEF7yQO/RN3byIQPBbBQDcFsUXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phillip Potter <phil@philpotter.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 577/913] staging: r8188eu: convert DBG_88E_LEVEL call in hal/rtl8188e_hal_init.c
Date:   Tue,  5 Apr 2022 09:27:19 +0200
Message-Id: <20220405070357.142720926@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 5ec394d58bdba731c2a33645be7018e71f72f287 ]

Convert DBG_88E_LEVEL macro call in hal/rtl8188e_hal_init.c to plain
dev_dbg call, as although the information is potentially useful, we should
be exposing it using standard kernel debugging functionality.

Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20211129002041.865-6-phil@philpotter.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/hal/rtl8188e_hal_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c
index 14758361960c..a677b2049ef3 100644
--- a/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c
@@ -573,7 +573,7 @@ static int load_firmware(struct rt_firmware *pFirmware, struct device *device)
 	memcpy(pFirmware->szFwBuffer, fw->data, fw->size);
 	pFirmware->ulFwLength = fw->size;
 	release_firmware(fw);
-	DBG_88E_LEVEL(_drv_info_, "+%s: !bUsedWoWLANFw, FmrmwareLen:%d+\n", __func__, pFirmware->ulFwLength);
+	dev_dbg(device, "!bUsedWoWLANFw, FmrmwareLen:%d+\n", pFirmware->ulFwLength);
 
 Exit:
 	return rtStatus;
-- 
2.34.1



