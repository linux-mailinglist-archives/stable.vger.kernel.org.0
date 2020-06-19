Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F2B201273
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392517AbgFSPVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392812AbgFSPVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D839320706;
        Fri, 19 Jun 2020 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580066;
        bh=7IiQDXdq9Z5dE9WWdDCDCvrJ4FHOUElT9vMdc58iVhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nqlq7OCvT3RA2ndRYvkBrNrCCIjKgvp0+uu1FozrZU/Zd4JQFwR+GcVQlpHexldSA
         OzVIBD0t5U4lW6i/N34vJfvqhG2SbR7Mww/wxILB9K4KiNGlrsA22KvExLF2XCSkuc
         erRiNpwp7tv7NbfiBEcziUxEgq4IRkgySkdjjc28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dale Zhao <dale.zhao@amd.com>,
        Sung Lee <sung.lee@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 108/376] drm/amd/display: Correct updating logic of dcn21s pipe VM flags
Date:   Fri, 19 Jun 2020 16:30:26 +0200
Message-Id: <20200619141715.458435986@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dale Zhao <dale.zhao@amd.com>

[ Upstream commit 2a28fe92220a116735ef45939b7edcfee83cc6b0 ]

[Why]:
Renoir's pipe VM flags are not correctly updated if pipe strategy has
changed during some scenarios. It will result in watermarks mistakenly
calculation, thus underflow and garbage appear.

[How]:
Correctly update pipe VM flags to pipes which have been populated.

Signed-off-by: Dale Zhao <dale.zhao@amd.com>
Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index a721bb401ef0..6d1736cf5c12 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1694,12 +1694,8 @@ static int dcn21_populate_dml_pipes_from_context(
 {
 	uint32_t pipe_cnt = dcn20_populate_dml_pipes_from_context(dc, context, pipes);
 	int i;
-	struct resource_context *res_ctx = &context->res_ctx;
 
-	for (i = 0; i < dc->res_pool->pipe_count; i++) {
-
-		if (!res_ctx->pipe_ctx[i].stream)
-			continue;
+	for (i = 0; i < pipe_cnt; i++) {
 
 		pipes[i].pipe.src.hostvm = 1;
 		pipes[i].pipe.src.gpuvm = 1;
-- 
2.25.1



