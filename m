Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6147551A92A
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbiEDRRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355540AbiEDRHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:07:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B57517DA;
        Wed,  4 May 2022 09:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14862B8278E;
        Wed,  4 May 2022 16:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73EDC385A4;
        Wed,  4 May 2022 16:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683265;
        bh=IIINfVmwi4MVCKx9RAdZyLjQxxX/j2tucRd/eLdKJW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J38fCjNNJnX8J42CYOzI+y5sg5vlXH517meZmAbQLjHsvn4u+AdZVjiZrOdLjH5Xg
         4C+B2uqWGzb5DdLqcxuw5DyzF4KR1K3N0NBpqdbXOKfGX4EsphQ3gfACfE+Hfg86c/
         q9ykF0D7h/zryDipD3yOtoyTY2HHiAlXQLnBEe/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/177] drm/amd/display: Fix memory leak in dcn21_clock_source_create
Date:   Wed,  4 May 2022 18:45:08 +0200
Message-Id: <20220504153103.497293099@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 65e54987508b6f0771f56bdfa3ee1926d52785ae ]

When dcn20_clk_src_construct() fails, we need to release clk_src.

Fixes: 6f4e6361c3ff ("drm/amd/display: Add Renoir resource (v2)")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index fbbdf9976183..5b8274b8c384 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1428,6 +1428,7 @@ static struct clock_source *dcn21_clock_source_create(
 		return &clk_src->base;
 	}
 
+	kfree(clk_src);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
-- 
2.35.1



