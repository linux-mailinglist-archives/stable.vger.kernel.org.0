Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13AE312C78F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbfL2Rnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728940AbfL2Rnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3033820718;
        Sun, 29 Dec 2019 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641425;
        bh=i7pFDxDMxBxFq1gXluXcIXMqojXanOmX46ZyKYyuAJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRfIHeTwa8uGxTLVcbgvNqxN2m3NvES6yZQQ452KfL7sqeMGYpqLX7tZRwgTPfLrc
         m76Ck8SzTxMRa7ciuCnh8w5PAXDBzGoe5C17qAilJri4euUjhRwrS+0Ol2ptXwS6rs
         TOTKE1vZZZ0MobxMpIHgMwRmvZOPfUSUbNcavMhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikita Lipski <mikita.lipski@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/434] drm/amd/display: Rebuild mapped resources after pipe split
Date:   Sun, 29 Dec 2019 18:21:51 +0100
Message-Id: <20191229172705.703095248@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikita Lipski <mikita.lipski@amd.com>

[ Upstream commit 387596ef2859c37d564ce15abddbc9063a132e2c ]

[why]
The issue is specific for linux, as on timings such as 8K@60
or 4K@144 DSC should be working in combination with ODM Combine
in order to ensure that we can run those timings. The validation
for those timings was passing, but when pipe split was happening
second pipe wasn't being programmed.

[how]
Rebuild mapped resources if we split stream for ODM.

Signed-off-by: Mikita Lipski <mikita.lipski@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 3980c7b78259..ebe67c34dabf 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2474,6 +2474,7 @@ bool dcn20_fast_validate_bw(
 							&context->res_ctx, dc->res_pool,
 							pipe, hsplit_pipe))
 						goto validate_fail;
+					dcn20_build_mapped_resource(dc, context, pipe->stream);
 				} else
 					dcn20_split_stream_for_mpc(
 						&context->res_ctx, dc->res_pool,
-- 
2.20.1



