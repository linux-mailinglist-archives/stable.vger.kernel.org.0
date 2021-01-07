Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746582ED26D
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbhAGOdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbhAGOdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 771B72054F;
        Thu,  7 Jan 2021 14:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029975;
        bh=9TrlDS/outYL/wOzZR5B6X8FKiqISaoB09581E3i/RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFsHL39+HrukZyCY8pCESWpU3qXHNfp4VaFhUHq2LRHwQGg33uh86k34ViAwNgFDT
         u8dwDu22qtsoM5RRELthuMl8pnMwS0fnxJBzuSfLj1xY/qzjSr3byWCOJB9nErk/Mw
         gF+3nGL8K0fcRIflgA5pZu8nA82Kzo+cvHytHZPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stylon Wang <stylon.wang@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Andre Tomt <andre@tomt.net>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 01/20] Revert "drm/amd/display: Fix memory leaks in S3 resume"
Date:   Thu,  7 Jan 2021 15:33:56 +0100
Message-Id: <20210107143052.592801948@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

This reverts commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362.

This leads to blank screens on some boards after replugging a
display.  Revert until we understand the root cause and can
fix both the leak and the blank screen after replug.

Cc: Stylon Wang <stylon.wang@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Andre Tomt <andre@tomt.net>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2278,8 +2278,7 @@ void amdgpu_dm_update_connector_after_de
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
-			aconnector->num_modes = drm_add_edid_modes(connector, aconnector->edid);
-			drm_connector_list_update(connector);
+			drm_add_edid_modes(connector, aconnector->edid);
 
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,


