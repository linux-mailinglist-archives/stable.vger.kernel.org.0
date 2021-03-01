Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFB7328D1B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhCATFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233166AbhCAS6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:58:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D045664D5D;
        Mon,  1 Mar 2021 17:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619604;
        bh=hCcmAs2PRbDTnVNOZNBB4hD3hhROgsAcI6qeae1n1Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AE57zBPcXlC8k7SlJ6GV74AwjpJ2G14crVKbew3oMir1QfaGENNNOH2YlNdT10uL
         RlGBhOIL9eT5qxHVgGOcBIVKDXf+Ukgp0d4VAORmT8G0fY5h6a+wN+ZfCDeGdHc5fX
         RgV8PNTU6979FkUYs9ICQL7zX1EZGxjsH/0UVqIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Bernstein <eric.bernstein@amd.com>,
        Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 514/663] drm/amd/display: Remove Assert from dcn10_get_dig_frontend
Date:   Mon,  1 Mar 2021 17:12:42 +0100
Message-Id: <20210301161207.284575433@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Bernstein <eric.bernstein@amd.com>

commit 83e6667b675f101fb66659dfa72e45d08773d763 upstream.

[Why]
In some cases, this function is called when DIG BE is not
connected to DIG FE, in which case a value of zero isn't
invalid and assert should not be hit.

[How]
Remove assert and handle ENGINE_ID_UNKNOWN result in calling
function.

Signed-off-by: Eric Bernstein <eric.bernstein@amd.com>
Acked-by: Bindu Ramamurthy <bindu.r@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_link_encoder.c |    1 -
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c        |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_link_encoder.c
@@ -480,7 +480,6 @@ unsigned int dcn10_get_dig_frontend(stru
 		break;
 	default:
 		// invalid source select DIG
-		ASSERT(false);
 		result = ENGINE_ID_UNKNOWN;
 	}
 
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -526,6 +526,8 @@ void dcn30_init_hw(struct dc *dc)
 
 					fe = dc->links[i]->link_enc->funcs->get_dig_frontend(
 										dc->links[i]->link_enc);
+					if (fe == ENGINE_ID_UNKNOWN)
+						continue;
 
 					for (j = 0; j < dc->res_pool->stream_enc_count; j++) {
 						if (fe == dc->res_pool->stream_enc[j]->id) {


