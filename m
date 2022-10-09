Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C284C5F94E1
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiJJAN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiJJAMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:12:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FB62A96D;
        Sun,  9 Oct 2022 16:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E0F060DB4;
        Sun,  9 Oct 2022 23:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3E1C433C1;
        Sun,  9 Oct 2022 23:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359405;
        bh=flhMqOyp2jHHYjkvWABjQ6X28xgOgGeP/qWxCP2QoLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXY7GBBUA9z8rwrz64Cv3ZJ4LLxHDaAHVnbqulwE9Eelp2Y4Io/x+MRYJT4/xaX08
         8jQKWq7d1u/wRkAUeJiNe05H+Re5SSxJbEcj1HlVIHNdCPSugeCWaOMYeFC1QjEjIf
         FR/eUAVj/iQx4N522K+zYiTnz9VzArsZoX/6oSM9axZyUBDJgv69momh2+kBOxE6vu
         VgRu0Aiyxnospb7A0xYI732PffR3NkW+TVf0KCiIIAeJuW6fVzRaI8/WJqstC3QgKv
         AXQQma7W5bsgdFPXHjGP0dilwHWob9h075s6gFVsivI8TTq7FRfAsBVdF8ph5m+XUo
         5+QHZUe5iU8Aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com,
        agustin.gutierrez@amd.com, Charlene.Liu@amd.com,
        michael.strauss@amd.com, mwen@igalia.com, Eric.Yang2@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 11/44] drm/amd: fix potential memory leak
Date:   Sun,  9 Oct 2022 19:48:59 -0400
Message-Id: <20221009234932.1230196-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Zhao <bernard@vivo.com>

[ Upstream commit 6160216fd2c97107e8a9ab39863b056d677fcd85 ]

This patch fix potential memory leak (clk_src) when function run
into last return NULL.

s/free/kfree/ - Alex

Signed-off-by: Bernard Zhao <bernard@vivo.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index 44ac1c2aabf5..b96e8089aaa3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -1719,6 +1719,7 @@ static struct clock_source *dcn30_clock_source_create(
 	}
 
 	BREAK_TO_DEBUGGER();
+	kfree(clk_src);
 	return NULL;
 }
 
-- 
2.35.1

