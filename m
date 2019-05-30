Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860AA2F223
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbfE3ESz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730306AbfE3DP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:29 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C06224547;
        Thu, 30 May 2019 03:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186128;
        bh=SnqwmFzw03K1gcPmMYOzxHxxvJbpotaVF5rgolxW8i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nspBsodjbrLd/8/s9iJpVKZg+LJz0J/qZFSauCBNZl/oIYei4WQhXfgBwJ94j2Abw
         1wz7EXb9M3rMDRn5AAC05iLogzpsS1/A+fUMnbUn2MskbpErLZWTro/g0bPr4bvh4i
         AdHSJe2ZABGg54JEOhlBGoFeCu57ubIYRyGNIpBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samson Tam <Samson.Tam@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 289/346] drm/amd/display: Link train only when link is DP and backend is enabled
Date:   Wed, 29 May 2019 20:06:02 -0700
Message-Id: <20190530030555.524480172@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 66acd4418d7de131ef3831e52a8af3d2480e5b15 ]

[Why]
In certain cases we do link training when we don't have a backend.

[How]
In dc_link_set_preferred_link_settings(), store preferred link settings
first and then verify that the link is DP and the link stream's backend is
enabled.  If either is false, then we will not do any link retraining.

Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 5af2ea1f201d3..68529acba015f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -524,6 +524,14 @@ void dc_link_set_preferred_link_settings(struct dc *dc,
 	struct dc_stream_state *link_stream;
 	struct dc_link_settings store_settings = *link_setting;
 
+	link->preferred_link_setting = store_settings;
+
+	/* Retrain with preferred link settings only relevant for
+	 * DP signal type
+	 */
+	if (!dc_is_dp_signal(link->connector_signal))
+		return;
+
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe = &dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe->stream && pipe->stream->sink
@@ -539,7 +547,10 @@ void dc_link_set_preferred_link_settings(struct dc *dc,
 
 	link_stream = link->dc->current_state->res_ctx.pipe_ctx[i].stream;
 
-	link->preferred_link_setting = store_settings;
+	/* Cannot retrain link if backend is off */
+	if (link_stream->dpms_off)
+		return;
+
 	if (link_stream)
 		decide_link_settings(link_stream, &store_settings);
 
-- 
2.20.1



