Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0630F1CAC86
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgEHMyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbgEHMyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:54:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24ACA2496A;
        Fri,  8 May 2020 12:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942443;
        bh=zFkS2/g/Apr0wc4izu9ZFX09jKuGiQjn4auE0yk/aQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaVNFmDD3c3W0Hlzy+pNT6YDKg46Z1F5ngYJEujFBuZ46KY6kJl5/P4nMsrfF1wJk
         0is3RM96IItgXgcBPlgAhgXIaSaIIatp4IyEihxOHwTt7+qLzT5n9J4VtMB0Uy344o
         1zyiNDq3oZCzTzqDD5kaScUZ4DK5urTwyJYsZ8bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zhan.liu@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 47/50] Revert "drm/amd/display: setting the DIG_MODE to the correct value."
Date:   Fri,  8 May 2020 14:35:53 +0200
Message-Id: <20200508123049.498428983@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhan Liu <Zhan.Liu@amd.com>

commit b73b7f48895a6a944a76a2d8cdd7feee72bb1f0b upstream.

This reverts commit 967a3b85bac91c55eff740e61bf270c2732f48b2.

Reason for revert: Root cause of this issue is found. The workaround is not needed anymore.

Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2768,15 +2768,6 @@ void core_link_enable_stream(
 					CONTROLLER_DP_TEST_PATTERN_VIDEOMODE,
 					COLOR_DEPTH_UNDEFINED);
 
-		/* This second call is needed to reconfigure the DIG
-		 * as a workaround for the incorrect value being applied
-		 * from transmitter control.
-		 */
-		if (!dc_is_virtual_signal(pipe_ctx->stream->signal))
-			stream->link->link_enc->funcs->setup(
-				stream->link->link_enc,
-				pipe_ctx->stream->signal);
-
 #ifdef CONFIG_DRM_AMD_DC_DSC_SUPPORT
 		if (pipe_ctx->stream->timing.flags.DSC) {
 			if (dc_is_dp_signal(pipe_ctx->stream->signal) ||


