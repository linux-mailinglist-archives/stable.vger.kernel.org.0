Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5FF54113C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355640AbiFGTea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355690AbiFGTdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:33:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604411AA3C9;
        Tue,  7 Jun 2022 11:13:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC061CE2444;
        Tue,  7 Jun 2022 18:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7E3C3411C;
        Tue,  7 Jun 2022 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625577;
        bh=Aoq/ZnXVcKk+p7VdfH7dk2D2Y56VczJQo9MgI9eHjA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBvsO6BjG3d/Ur100xfSwy+mw/4wMgl2PrO/gkahIMwnq+x6WAbrS21WFOMEaniGP
         y4ltBw27aA5AcjrmIfzU9Fj69PwWDKs9CI57TS2VZ0XozQHDH72y57D5kyqdRvNWjf
         ijrYvJSli9FIFQ9WkzkEQe/oryQn4s/EC6IV3up4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 067/772] drm/komeda: return early if drm_universal_plane_init() fails.
Date:   Tue,  7 Jun 2022 18:54:19 +0200
Message-Id: <20220607164951.014273684@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Liviu Dudau <liviu.dudau@arm.com>

[ Upstream commit c8f76c37cc3668ee45e081e76a15f24a352ebbdd ]

If drm_universal_plane_init() fails early we jump to the common cleanup code
that calls komeda_plane_destroy() which in turn could access the uninitalised
drm_plane and crash. Return early if an error is detected without going through
the common code.

Reported-by: Steven Price <steven.price@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/dri-devel/20211203100946.2706922-1-liviu.dudau@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_plane.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
index d63d83800a8a..d646e3ae1a23 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
@@ -275,8 +275,10 @@ static int komeda_plane_add(struct komeda_kms_dev *kms,
 
 	komeda_put_fourcc_list(formats);
 
-	if (err)
-		goto cleanup;
+	if (err) {
+		kfree(kplane);
+		return err;
+	}
 
 	drm_plane_helper_add(plane, &komeda_plane_helper_funcs);
 
-- 
2.35.1



