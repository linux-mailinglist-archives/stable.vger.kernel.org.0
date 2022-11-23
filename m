Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B6F6355BB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbiKWJXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237598AbiKWJWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:22:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598F910AD2D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED0DE61B4C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91E5C433D6;
        Wed, 23 Nov 2022 09:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195325;
        bh=Pgxsdvoa2KvgzRryZ9k7P8lB7Jk+R897S8XyFUhfWdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1h3Yu3JITtUe5SO9WOfdL/99vAx0Quj5L3lW7GDSlwOwOiL/ut2CqnX8pz98RycrN
         v9Og50v5OzrRA/vC7CutAaVX17H2ztBgyxAaN50c+OdrHN220PWdxiW9JlXa4q+Lfo
         o6/Aju5LVtsZ7vsVBXdT5QzkUAvbwoMhYIfQ+e18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Aishwarya Kothari <aishwarya.kothari@toradex.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/149] drm/panel: simple: set bpc field for logic technologies displays
Date:   Wed, 23 Nov 2022 09:50:35 +0100
Message-Id: <20221123084559.799206984@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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
index b7b37082a9d7..1a87cc445b5e 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2655,6 +2655,7 @@ static const struct display_timing logictechno_lt161010_2nh_timing = {
 static const struct panel_desc logictechno_lt161010_2nh = {
 	.timings = &logictechno_lt161010_2nh_timing,
 	.num_timings = 1,
+	.bpc = 6,
 	.size = {
 		.width = 154,
 		.height = 86,
@@ -2684,6 +2685,7 @@ static const struct display_timing logictechno_lt170410_2whc_timing = {
 static const struct panel_desc logictechno_lt170410_2whc = {
 	.timings = &logictechno_lt170410_2whc_timing,
 	.num_timings = 1,
+	.bpc = 8,
 	.size = {
 		.width = 217,
 		.height = 136,
-- 
2.35.1



