Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB7B6AEBAD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbjCGRrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjCGRrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:47:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ECE4C6D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:42:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C85F861514
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44E1C433EF;
        Tue,  7 Mar 2023 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210932;
        bh=FR43rAtmpHjBfY1MdgtzjRQNf3n2KZR6/hd8PI6mKKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6E59Y4rQN1G5Kz9KfdqmsLmpKkdcip5cXhmVmnalH7d513/00qvTmwYDQLwnbFFh
         ORnRQ0Cs/uQ37+k/KzJtf69fz5fuw9jYtK8zjQVoNep32KxkPZIKFj8lLtYc18P2d3
         isvMPlALUA4CNSrNsRinX9lYN98Lyun7NJilR5QY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0701/1001] drm: amd: display: Fix memory leakage
Date:   Tue,  7 Mar 2023 17:57:53 +0100
Message-Id: <20230307170052.044689668@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit 6b8701be1f66064ca72733c5f6e13748cdbf8397 ]

This commit fixes memory leakage in dc_construct_ctx() function.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 0cb8d1f934d12..c03e86e49fea3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -862,6 +862,7 @@ static bool dc_construct_ctx(struct dc *dc,
 
 	dc_ctx->perf_trace = dc_perf_trace_create();
 	if (!dc_ctx->perf_trace) {
+		kfree(dc_ctx);
 		ASSERT_CRITICAL(false);
 		return false;
 	}
-- 
2.39.2



