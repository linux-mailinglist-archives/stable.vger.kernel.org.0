Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0141654876A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348594AbiFMK4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349476AbiFMKyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB6C2494F;
        Mon, 13 Jun 2022 03:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C589B80E93;
        Mon, 13 Jun 2022 10:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCCEC34114;
        Mon, 13 Jun 2022 10:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116085;
        bh=2LFwGuCsKCuYENEjOsRcLSDeb9bv9mIq1XjW2w4MUhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjaiGTj6aFN9D3ELdcsFARK3g0OW4TdApkXVs5bKwxMLfazIVzAiA43Q///6JmVVR
         7ESL4fgAGVdEfEkl/GtMXCSf/7Z8clPYFoD1JA3lB3pnnUqQ2WrjhuRekEoHDmMmPf
         I7NrjG+E7gr8w8KRLFC/uxaTkh9YU+DouYTsmjRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/411] drm/komeda: return early if drm_universal_plane_init() fails.
Date:   Mon, 13 Jun 2022 12:04:53 +0200
Message-Id: <20220613094929.107319038@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 98e915e325dd..a5f57b38d193 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
@@ -274,8 +274,10 @@ static int komeda_plane_add(struct komeda_kms_dev *kms,
 
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



