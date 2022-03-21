Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1474E29D7
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349084AbiCUOHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348935AbiCUOFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137499F6EE;
        Mon, 21 Mar 2022 07:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67DA46132C;
        Mon, 21 Mar 2022 14:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA7DC340E8;
        Mon, 21 Mar 2022 14:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871300;
        bh=np3PsbtFyilrKjrzx10d3sqVMIWHD2rFyiUwMPptA/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aiv+LtvfRCmFQlLSbPX+I96QmaMvvgWIE5lKGujK97VMdiSkGhVEqpOXGojM0KoPe
         Ir1EKbujbgJJ8YSbuy7nRlUkYlqgYvXt+3l1raedf8rYgnN6GrGXyGZNYDXC4hhJwY
         jKZLEm0bE51QQXNxKOiMDHD0yQOWoS7YGeCuK02c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jocelyn Falempe <jfalempe@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.16 05/37] drm/mgag200: Fix PLL setup for g200wb and g200ew
Date:   Mon, 21 Mar 2022 14:52:47 +0100
Message-Id: <20220321133221.450651401@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jocelyn Falempe <jfalempe@redhat.com>

commit 40ce1121c1d76daf9048a86e36c83e469281b9fd upstream.

commit f86c3ed55920 ("drm/mgag200: Split PLL setup into compute and
 update functions") introduced a regression for g200wb and g200ew.
The PLLs are not set up properly, and VGA screen stays
black, or displays "out of range" message.

MGA1064_WB_PIX_PLLC_N/M/P was mistakenly replaced with
MGA1064_PIX_PLLC_N/M/P which have different addresses.

Patch tested on a Dell T310 with g200wb

Fixes: f86c3ed55920 ("drm/mgag200: Split PLL setup into compute and update functions")
Cc: stable@vger.kernel.org
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220308174321.225606-1-jfalempe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_pll.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_pll.c
+++ b/drivers/gpu/drm/mgag200/mgag200_pll.c
@@ -404,9 +404,9 @@ mgag200_pixpll_update_g200wb(struct mgag
 		udelay(50);
 
 		/* program pixel pll register */
-		WREG_DAC(MGA1064_PIX_PLLC_N, xpixpllcn);
-		WREG_DAC(MGA1064_PIX_PLLC_M, xpixpllcm);
-		WREG_DAC(MGA1064_PIX_PLLC_P, xpixpllcp);
+		WREG_DAC(MGA1064_WB_PIX_PLLC_N, xpixpllcn);
+		WREG_DAC(MGA1064_WB_PIX_PLLC_M, xpixpllcm);
+		WREG_DAC(MGA1064_WB_PIX_PLLC_P, xpixpllcp);
 
 		udelay(50);
 


