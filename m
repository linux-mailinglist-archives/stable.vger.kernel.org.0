Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3595540AC0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351500AbiFGSXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352375AbiFGSRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D659BF89C;
        Tue,  7 Jun 2022 10:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38B09617A8;
        Tue,  7 Jun 2022 17:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4270EC385A5;
        Tue,  7 Jun 2022 17:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624288;
        bh=CdgY2UMdM7b4PIzezruemoOeBob9V9P4jF5Sqw7qqn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yI1AkgNEvZVdo3G67EjG2J7xNQeVuLTPGMt2Cyu83dm+7646HgQJBxQoOYxTVKWfq
         ZqZtDM3kiM6RKzSx5VRFZLSIr+lzWorEfkpy/G0cTA1usBNWfV76aKsMj7os+lLQMl
         TJ/tMBPBD795bYdZruOKCZyGZIJMYtvRHdUtxDls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagan Teki <jagan@amarulasolutions.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/667] drm/panel: panel-simple: Fix proper bpc for AM-1280800N3TZQW-T00H
Date:   Tue,  7 Jun 2022 18:58:59 +0200
Message-Id: <20220607164943.003208468@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Jagan Teki <jagan@amarulasolutions.com>

[ Upstream commit 7eafbecd2288c542ea15ea20cf1a7e64a25c21bc ]

AM-1280800N3TZQW-T00H panel support 8 bpc not 6 bpc as per
recent testing in i.MX8MM platform.

Fix it.

Fixes: bca684e69c4c ("drm/panel: simple: Add AM-1280800N3TZQW-T00H")
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211111094103.494831-1-jagan@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 93a1d6b41117..8dd7013c75f2 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -862,7 +862,7 @@ static const struct drm_display_mode ampire_am_1280800n3tzqw_t00h_mode = {
 static const struct panel_desc ampire_am_1280800n3tzqw_t00h = {
 	.modes = &ampire_am_1280800n3tzqw_t00h_mode,
 	.num_modes = 1,
-	.bpc = 6,
+	.bpc = 8,
 	.size = {
 		.width = 217,
 		.height = 136,
-- 
2.35.1



