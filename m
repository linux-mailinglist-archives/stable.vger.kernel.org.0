Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E37505407
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbiDRNBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242373AbiDRM7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:59:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89B1205C3;
        Mon, 18 Apr 2022 05:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51625611FE;
        Mon, 18 Apr 2022 12:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF11C385A1;
        Mon, 18 Apr 2022 12:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285659;
        bh=0pNCm8cPtRNE2lPaj50F4TUTtqGyvvsngKx3mqhnaVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqIHTnzUMpX1GsCnY6tII6dexTo2YqF7H3DoFOtA286rj2HrFT7o1J+qbSlSS+5iH
         RVVbVzUpr/whMuVtKG040wHepVGtCdWxgOiEdU7gjcAZ7HfXL9p0rQ0ZWZ4cdm1M5Q
         GvU0BgN73yg3us+rLVRo1lkC4mJt3pA+pGEK1/Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 087/105] drm/amdgpu: Enable gfxoff quirk on MacBook Pro
Date:   Mon, 18 Apr 2022 14:13:29 +0200
Message-Id: <20220418121149.104870040@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Tomasz Moń <desowin@gmail.com>

commit 4593c1b6d159f1e5c35c07a7f125e79e5a864302 upstream.

Enabling gfxoff quirk results in perfectly usable graphical user
interface on MacBook Pro (15-inch, 2019) with Radeon Pro Vega 20 4 GB.

Without the quirk, X server is completely unusable as every few seconds
there is gpu reset due to ring gfx timeout.

Signed-off-by: Tomasz Moń <desowin@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1248,6 +1248,8 @@ static const struct amdgpu_gfxoff_quirk
 	{ 0x1002, 0x15dd, 0x103c, 0x83e7, 0xd3 },
 	/* GFXOFF is unstable on C6 parts with a VBIOS 113-RAVEN-114 */
 	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc6 },
+	/* Apple MacBook Pro (15-inch, 2019) Radeon Pro Vega 20 4 GB */
+	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
 	{ 0, 0, 0, 0, 0 },
 };
 


