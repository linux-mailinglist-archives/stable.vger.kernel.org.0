Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF88328E2D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbhCATZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:25:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235765AbhCATSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:18:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F199764FA3;
        Mon,  1 Mar 2021 17:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619601;
        bh=Y5B3CohJ0Xl3YkF/OrgFnybXvjnQMwMebfIgIUc7t1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHk/Y0veaQrPRx5zfKQ09jLbFfWvdYa0usLlSdFStqud7QnhDT3X2Oi3Rh9NsaOia
         LcVKPhcLfQT40mrIcqUQgCKrSkimwKwipQV+Q1wTDS6ktnA06WLqSLDJavZKN+YeQ5
         eW3mP3O/xC0rNaVyRnSwOU/V6NjfU+S8TVkjiRao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jan=20Kokem=C3=BCller?= <jan.kokemueller@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 513/663] drm/amd/display: Add FPU wrappers to dcn21_validate_bandwidth()
Date:   Mon,  1 Mar 2021 17:12:41 +0100
Message-Id: <20210301161207.233869709@linuxfoundation.org>
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

From: Jan Kokemüller <jan.kokemueller@gmail.com>

commit 41401ac67791810dd880345962339aa1bedd3c0d upstream.

dcn21_validate_bandwidth() calls functions that use floating point math.
On my machine this sometimes results in simd exceptions when there are
other FPU users such as KVM virtual machines running. The screen freezes
completely in this case.

Wrapping the function with DC_FP_START()/DC_FP_END() seems to solve the
problem. This mirrors the approach used for dcn20_validate_bandwidth.

Tested on a AMD Ryzen 7 PRO 4750U (Renoir).

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206987
Signed-off-by: Jan Kokemüller <jan.kokemueller@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    2 -
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c |   20 ++++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -3248,7 +3248,7 @@ restore_dml_state:
 bool dcn20_validate_bandwidth(struct dc *dc, struct dc_state *context,
 		bool fast_validate)
 {
-	bool voltage_supported = false;
+	bool voltage_supported;
 	DC_FP_START();
 	voltage_supported = dcn20_validate_bandwidth_fp(dc, context, fast_validate);
 	DC_FP_END();
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1173,8 +1173,8 @@ void dcn21_calculate_wm(
 }
 
 
-bool dcn21_validate_bandwidth(struct dc *dc, struct dc_state *context,
-		bool fast_validate)
+static noinline bool dcn21_validate_bandwidth_fp(struct dc *dc,
+		struct dc_state *context, bool fast_validate)
 {
 	bool out = false;
 
@@ -1227,6 +1227,22 @@ validate_out:
 
 	return out;
 }
+
+/*
+ * Some of the functions further below use the FPU, so we need to wrap this
+ * with DC_FP_START()/DC_FP_END(). Use the same approach as for
+ * dcn20_validate_bandwidth in dcn20_resource.c.
+ */
+bool dcn21_validate_bandwidth(struct dc *dc, struct dc_state *context,
+		bool fast_validate)
+{
+	bool voltage_supported;
+	DC_FP_START();
+	voltage_supported = dcn21_validate_bandwidth_fp(dc, context, fast_validate);
+	DC_FP_END();
+	return voltage_supported;
+}
+
 static void dcn21_destroy_resource_pool(struct resource_pool **pool)
 {
 	struct dcn21_resource_pool *dcn21_pool = TO_DCN21_RES_POOL(*pool);


