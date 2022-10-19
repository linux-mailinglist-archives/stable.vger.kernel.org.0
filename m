Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB23604231
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiJSK4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbiJSK4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:56:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E67E1DF39;
        Wed, 19 Oct 2022 03:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F72FB824C0;
        Wed, 19 Oct 2022 09:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E79C433C1;
        Wed, 19 Oct 2022 09:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170660;
        bh=aNGCEolK+NBSlxH63pf5dpYKtguBt0WmtFibHave+zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIfNX64xA4LpwsAYX47F5cctsfN0knfsh2fvR2hiwBGhk9OoptSeLbWtNdaSTxBZr
         0SpLPMzegt0itQNaWotKYWpTJ9b7MBrgCj/EczDGqaEhRL5mhCYP51AXrhPO46KbWr
         qXVrtBxjigVTaYPxRRhw6Yu2aKPJ8VGWku4PtmGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernard Zhao <bernard@vivo.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 738/862] drm/amd: fix potential memory leak
Date:   Wed, 19 Oct 2022 10:33:45 +0200
Message-Id: <20221019083322.561013906@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3cd7c91655c5..6d721fadcbee 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -1720,6 +1720,7 @@ static struct clock_source *dcn30_clock_source_create(
 	}
 
 	BREAK_TO_DEBUGGER();
+	kfree(clk_src);
 	return NULL;
 }
 
-- 
2.35.1



