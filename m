Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E237C4F30AB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350154AbiDEJzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244537AbiDEJOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:14:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FC6381A9;
        Tue,  5 Apr 2022 02:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61BC5B80DA1;
        Tue,  5 Apr 2022 09:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5909C385A1;
        Tue,  5 Apr 2022 09:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149233;
        bh=RgygLs90P80dA/tn0louJwqPh2WnY93FIS08MYA5D50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHyy46fcIzbpju43RY6Dit4p+7SXef0BMuO+rFBjiYPS/JO1AR0xR6n02yx0+Xfx0
         zWKvfYuGIa1fC+vhNI0a9+dGYKtCKUPZEn4ZWl6liuDZpjO7Ocoi4rI+Ec7+TZaBNd
         CRW731skZUaamDSTl5VOBb+8ayIEjLnMiL7sCzPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0643/1017] staging: r8188eu: release_firmware is not called if allocation fails
Date:   Tue,  5 Apr 2022 09:25:56 +0200
Message-Id: <20220405070413.369654764@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Michael Straube <straube.linux@gmail.com>

[ Upstream commit 39850edf2befe27bcb3d6c37b6ee76d2ee4df903 ]

In function load_firmware() release_firmware() is not called if the
allocation of pFirmware->szFwBuffer fails or if fw->size is greater
than FW_8188E_SIZE.

Move the call to release_firmware() to the exit label at the end of
the function to fix this.

Fixes: 8cd574e6af54 ("staging: r8188eu: introduce new hal dir for RTL8188eu driver")
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Link: https://lore.kernel.org/r/20220107103620.15648-4-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/hal/rtl8188e_hal_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c
index 92c3c39e098f..8656d4061059 100644
--- a/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/r8188eu/hal/rtl8188e_hal_init.c
@@ -540,10 +540,10 @@ static int load_firmware(struct rt_firmware *pFirmware, struct device *device)
 	}
 	memcpy(pFirmware->szFwBuffer, fw->data, fw->size);
 	pFirmware->ulFwLength = fw->size;
-	release_firmware(fw);
 	dev_dbg(device, "!bUsedWoWLANFw, FmrmwareLen:%d+\n", pFirmware->ulFwLength);
 
 Exit:
+	release_firmware(fw);
 	return rtStatus;
 }
 
-- 
2.34.1



