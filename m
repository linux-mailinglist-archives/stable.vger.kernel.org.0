Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99AD4F281B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiDEIKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbiDEH6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEBFA94F3;
        Tue,  5 Apr 2022 00:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7B17B81BB5;
        Tue,  5 Apr 2022 07:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0431DC34110;
        Tue,  5 Apr 2022 07:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145187;
        bh=q+HweTIoMRUDs33SD84jX+bq8GXDyO/WMF9zN2kpg1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3ufrs0JIHFLoBdo5Jee5+BMqjJOjrflFTA3ALTcXUlri/PyGt66oiYBUz0pzhHBy
         R5iU3ghO7lCecnhaP342e9jEJ3sdSYjwAtObi7Trhw3XDZ1WB1sYeMB5O6HlTY9ZoM
         AR7zo+E2+iJ6KWEm3LAOBr9vIEMRyBE/DYp3ykGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Z. Liu" <liuzx@knownsec.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0317/1126] video: fbdev: matroxfb: set maxvram of vbG200eW to the same as vbG200 to avoid black screen
Date:   Tue,  5 Apr 2022 09:17:44 +0200
Message-Id: <20220405070416.920628985@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Z. Liu <liuzx@knownsec.com>

[ Upstream commit 62d89a7d49afe46e6b9bbe9e23b004ad848dbde4 ]

Start from commit 11be60bd66d54 "matroxfb: add Matrox MGA-G200eW board
support", when maxvram is 0x800000, monitor become black w/ error message
said: "The current input timing is not supported by the monitor display.
Please change your input timing to 1920x1080@60Hz ...".

Fixes: 11be60bd66d5 ("matroxfb: add Matrox MGA-G200eW board support")
Signed-off-by: Z. Liu <liuzx@knownsec.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/matrox/matroxfb_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
index 5c82611e93d9..236521b19daf 100644
--- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -1377,7 +1377,7 @@ static struct video_board vbG200 = {
 	.lowlevel = &matrox_G100
 };
 static struct video_board vbG200eW = {
-	.maxvram = 0x800000,
+	.maxvram = 0x100000,
 	.maxdisplayable = 0x800000,
 	.accelID = FB_ACCEL_MATROX_MGAG200,
 	.lowlevel = &matrox_G100
-- 
2.34.1



