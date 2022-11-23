Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC91A635815
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbiKWJuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238142AbiKWJtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A4810AD17
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BE1CB81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469AAC433D6;
        Wed, 23 Nov 2022 09:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196803;
        bh=tnZLFGjEAqxhqZfb8cO14Kfq/LMkQz8BVa1ZtgkQOWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEwTdoQXm9PK1EVsQVBRSr9Q+nneqd6IdUkVpeIDPvSoPy8PqBXJT7YbGaUpBG58c
         KwdqUfUhlwz+NuiP3CNURRWYVSfGGl/tazXSkabg2d0Uois6EYm21ygxmTKD9lo936
         ha/2sQSppLt4ZFAI/+babSUnZWv1YeqOCysaU00o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Aishwarya Kothari <aishwarya.kothari@toradex.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 128/314] drm/panel: simple: set bpc field for logic technologies displays
Date:   Wed, 23 Nov 2022 09:49:33 +0100
Message-Id: <20221123084631.337745683@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aishwarya Kothari <aishwarya.kothari@toradex.com>

[ Upstream commit 876153ab068b2507a19aa3ef481f5b00a2cc780f ]

In case bpc is not set for a panel it then throws a WARN(). Add bpc to
the panels logictechno_lt170410_2whc and logictechno_lt161010_2nh.

Fixes: 5728fe7fa539 ("drm/panel: simple: add display timings for logic technologies displays")
Signed-off-by: Aishwarya Kothari <aishwarya.kothari@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220831141622.39605-1-francesco.dolcini@toradex.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 1e716c23019a..eb938bfb0573 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2505,6 +2505,7 @@ static const struct display_timing logictechno_lt161010_2nh_timing = {
 static const struct panel_desc logictechno_lt161010_2nh = {
 	.timings = &logictechno_lt161010_2nh_timing,
 	.num_timings = 1,
+	.bpc = 6,
 	.size = {
 		.width = 154,
 		.height = 86,
@@ -2534,6 +2535,7 @@ static const struct display_timing logictechno_lt170410_2whc_timing = {
 static const struct panel_desc logictechno_lt170410_2whc = {
 	.timings = &logictechno_lt170410_2whc_timing,
 	.num_timings = 1,
+	.bpc = 8,
 	.size = {
 		.width = 217,
 		.height = 136,
-- 
2.35.1



