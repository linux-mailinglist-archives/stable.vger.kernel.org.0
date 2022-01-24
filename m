Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A7C49A94D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322424AbiAYDVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46344 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355957AbiAXUWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:22:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7554C61382;
        Mon, 24 Jan 2022 20:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51286C340E5;
        Mon, 24 Jan 2022 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055730;
        bh=OEEiLG+MaqoQuKa893H/hE0g8O4Jt/RefZPNUva1qyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmeRMhKbTAPDi0Bzv0Z0cVkF7E/S5S9tc8dnpj83MvhC+6Xdd88tn/1x1MKNJTyb7
         6J7byl8LO6AsvAk8g/gFk7SGasKSq5ySNzkaGAis9xt15sII72wqMcrpyzb+zWNzGc
         COVLOab7oNUPSd6xRriR+5e8ZO9ID5JCglfjUOEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/846] drm/amd/display: Fix out of bounds access on DNC31 stream encoder regs
Date:   Mon, 24 Jan 2022 19:35:37 +0100
Message-Id: <20220124184108.511512456@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit d374d3b493215d637b9e7be12a93f22caf4c1f97 ]

[Why]
During dcn31_stream_encoder_create, if PHYC/D get remapped to F/G on B0
then we'll index 5 or 6 into a array of length 5 - leading to an
access violation on some configs during device creation.

[How]
Software won't be touching PHYF/PHYG directly, so just extend the
array to cover all possible engine IDs.

Even if it does by try to access one of these registers by accident
the offset will be 0 and we'll get a warning during the access.

Fixes: 2fe9a0e1173f ("drm/amd/display: Fix DCN3 B0 DP Alt Mapping")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index 0fe570717ba01..d4fe5352421fc 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -470,7 +470,8 @@ static const struct dcn30_afmt_mask afmt_mask = {
 	SE_DCN3_REG_LIST(id)\
 }
 
-static const struct dcn10_stream_enc_registers stream_enc_regs[] = {
+/* Some encoders won't be initialized here - but they're logical, not physical. */
+static const struct dcn10_stream_enc_registers stream_enc_regs[ENGINE_ID_COUNT] = {
 	stream_enc_regs(0),
 	stream_enc_regs(1),
 	stream_enc_regs(2),
-- 
2.34.1



