Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4FB59A369
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353451AbiHSQkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353439AbiHSQjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:39:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED4E72856;
        Fri, 19 Aug 2022 09:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A07061826;
        Fri, 19 Aug 2022 16:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757F4C433C1;
        Fri, 19 Aug 2022 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925287;
        bh=2gIMAlHBijR6NYq4wraQ4wNTunf1yxbOHYK0ZS1AzLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mf+57hpT20VIA1Ro1qkqcHVEX0uUSb5gZlI9nUBTVeedbzn72XF8pWWGWPCFCVcw9
         9q+VgPGUkh2zsnFV34UL0rVqMzzp/8PcwRTa42NidUmRnoW60KMsJ8yBwAog1WH64k
         H4wa+IQvAl04rk0ktEGDnq9+cEoanBDCP2uCXGo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 414/545] video: fbdev: sis: fix typos in SiS_GetModeID()
Date:   Fri, 19 Aug 2022 17:43:04 +0200
Message-Id: <20220819153847.958790385@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Rustam Subkhankulov <subkhankulov@ispras.ru>

[ Upstream commit 3eb8fccc244bfb41a7961969e4db280d44911226 ]

The second operand of a '&&' operator has no impact on expression
result for cases 400 and 512 in SiS_GetModeID().

Judging by the logic and the names of the variables, in both cases a
typo was made.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sis/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/sis/init.c b/drivers/video/fbdev/sis/init.c
index fde27feae5d0..d6b2ce95a859 100644
--- a/drivers/video/fbdev/sis/init.c
+++ b/drivers/video/fbdev/sis/init.c
@@ -355,12 +355,12 @@ SiS_GetModeID(int VGAEngine, unsigned int VBFlags, int HDisplay, int VDisplay,
 		}
 		break;
 	case 400:
-		if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth >= 800) && (LCDwidth >= 600))) {
+		if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth >= 800) && (LCDheight >= 600))) {
 			if(VDisplay == 300) ModeIndex = ModeIndex_400x300[Depth];
 		}
 		break;
 	case 512:
-		if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth >= 1024) && (LCDwidth >= 768))) {
+		if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth >= 1024) && (LCDheight >= 768))) {
 			if(VDisplay == 384) ModeIndex = ModeIndex_512x384[Depth];
 		}
 		break;
-- 
2.35.1



