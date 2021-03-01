Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C670A329124
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbhCAUTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243018AbhCAUN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6540652B0;
        Mon,  1 Mar 2021 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621704;
        bh=hmR2cfOvkHnlt3Cg+y69VLZhqFEKTwIBrtpN9F+o8YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqibHKqMSfeWqO7Djzo5NXXL/yjBZGDXitU6JUrydbNpQWqW4yOFckxR+UIwiXd1G
         5C+1N/eepbkzmZDig+n9zCw8Hc2YwHX51NyCBR6u88tl4jyPhQp5tmTCIrWZCJdsnQ
         zZhneaxyF6QdeVujMfX+3GKbQYNFQglGmJWxwAZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Bernstein <eric.bernstein@amd.com>,
        Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 613/775] drm/amd/display: Remove Assert from dcn10_get_dig_frontend
Date:   Mon,  1 Mar 2021 17:13:01 +0100
Message-Id: <20210301161231.696477061@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
@@ -539,6 +539,8 @@ void dcn30_init_hw(struct dc *dc)
 
 					fe = dc->links[i]->link_enc->funcs->get_dig_frontend(
 										dc->links[i]->link_enc);
+					if (fe == ENGINE_ID_UNKNOWN)
+						continue;
 
 					for (j = 0; j < dc->res_pool->stream_enc_count; j++) {
 						if (fe == dc->res_pool->stream_enc[j]->id) {


