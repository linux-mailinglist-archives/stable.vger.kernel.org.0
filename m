Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E9A12C997
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbfL2SLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:11:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbfL2RnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F2C227BF;
        Sun, 29 Dec 2019 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641403;
        bh=loWKuHkkqjOSD2aMPmunp/waJ3OQs3KwgTb3RYmc2z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rY3V7fZQTaJx9jpYpjawgi6bA71AsxpdYNrqtDtdfIaiaAeCJJJs1ZtKLOh74i6uM
         fMBHqj7Ee2XRO8nzDRB8spjNQxkx+oMSK53fcPjCB6W6MOQGtFMtr+gu0FMPk8yWrn
         +ydqizfkeilIsCdrmFmjWU8lMm2avYW6CCKjEy0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Zhou <Jing.Zhou@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/434] drm/amd/display: verify stream link before link test
Date:   Sun, 29 Dec 2019 18:21:43 +0100
Message-Id: <20191229172705.274515486@linuxfoundation.org>
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

From: Jing Zhou <Jing.Zhou@amd.com>

[ Upstream commit b131932215c993ea5adf8192d1de2e8d6b23048d ]

[Why]
DP1.2 LL CTS test failure.

[How]
The failure is caused by not verify stream link is equal
to link, only check stream and link is not null.

Signed-off-by: Jing Zhou <Jing.Zhou@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
index 79438c4f1e20..a519dbc5ecb6 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
@@ -277,7 +277,8 @@ void dp_retrain_link_dp_test(struct dc_link *link,
 		if (pipes[i].stream != NULL &&
 			!pipes[i].top_pipe && !pipes[i].prev_odm_pipe &&
 			pipes[i].stream->link != NULL &&
-			pipes[i].stream_res.stream_enc != NULL) {
+			pipes[i].stream_res.stream_enc != NULL &&
+			pipes[i].stream->link == link) {
 			udelay(100);
 
 			pipes[i].stream_res.stream_enc->funcs->dp_blank(
-- 
2.20.1



