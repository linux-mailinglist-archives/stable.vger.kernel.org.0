Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1F8428FD8
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbhJKOBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237698AbhJKN7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2FFA60F4B;
        Mon, 11 Oct 2021 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960589;
        bh=uI2EKXIyFDiJCiGwG1SAnACv0IYFDOjalJyNNkJ8fzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NToKh69dqV6ZUqtdHNy0qc9rrtu0wsO4ej9uc7bIb+/Xtp1sh4dFUqeAcw6TGWByM
         bhIM9QJ3/Y6N9ske3nVVZzGbOIr4S2H3yFKaNEhRZldZIDPMeoXnpGitdz5dhippf8
         mH8xRY2nQ04pp7EEmwYzQjSjrMydHXVBjsPQ6txc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charlene Liu <charlene.liu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Zhan Liu <Zhan.Liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 017/151] drm/amd/display: Fix DCN3 B0 DP Alt Mapping
Date:   Mon, 11 Oct 2021 15:44:49 +0200
Message-Id: <20211011134518.411527068@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu, Zhan <Zhan.Liu@amd.com>

commit 2fe9a0e1173f4805669e7af34ea25af835274426 upstream.

[Why]
DCN3 B0 has a mux, which redirects PHYC and PHYD to PHYF and PHYG.

[How]
Fix DIG mapping.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Zhan Liu <Zhan.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit 4b7786d87fb3adf3e534c4f1e4f824d8700b786b)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -1284,6 +1284,12 @@ static struct stream_encoder *dcn31_stre
 	if (!enc1 || !vpg || !afmt)
 		return NULL;
 
+	if (ctx->asic_id.chip_family == FAMILY_YELLOW_CARP &&
+			ctx->asic_id.hw_internal_rev == YELLOW_CARP_B0) {
+		if ((eng_id == ENGINE_ID_DIGC) || (eng_id == ENGINE_ID_DIGD))
+			eng_id = eng_id + 3; // For B0 only. C->F, D->G.
+	}
+
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios,
 					eng_id, vpg, afmt,
 					&stream_enc_regs[eng_id],


