Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D06313C94
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhBHSIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235062AbhBHSDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEA7F64EE4;
        Mon,  8 Feb 2021 17:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807176;
        bh=In9cRPXkUPqty5EIdtKMwciDBWNm5gmKCa+LSHFmNlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rB8EFx1JNwJg+2k+mZDEfrPrKVBd3+dBjmadisWQqU9ON1vt60IsOIV7i8eqpmjBx
         31dzUBKhtGrPVnusBMUc0wQT1sAkuu2af1Z8iBRqABxNA0o2E0I5FmMcuoDyu0vfYM
         55ntzIvZW6IKFXWVZZlHCjShEtZG1GmYaQLlxAO+iQWxJQ7KH3cjfRijr174epg/Jn
         wJk/fZP72ztMn/HFeRIPSb8jpGpNMD5hgp2w6nLRCrXe7EdHT/CZIAJmYUUtRKs/Bs
         3URUAgN39MWNPq6XrYF+jI2tfyVS38vkp14ubylw+RG3y+KDFK5681KNxPhthNuSTr
         DgPD+IY3+9vRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Lu <victorchengchi.lu@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 07/14] drm/amd/display: Fix dc_sink kref count in emulated_link_detect
Date:   Mon,  8 Feb 2021 12:59:19 -0500
Message-Id: <20210208175926.2092211-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175926.2092211-1-sashal@kernel.org>
References: <20210208175926.2092211-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Lu <victorchengchi.lu@amd.com>

[ Upstream commit 3ddc818d9bb877c64f5c649beab97af86c403702 ]

[why]
prev_sink is not used anywhere else in the function and the reference to
it from dc_link is replaced with a new dc_sink.

[how]
Change dc_sink_retain(prev_sink) to dc_sink_release(prev_sink).

Signed-off-by: Victor Lu <victorchengchi.lu@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3b07a316680c2..7b00e96705b6d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -668,8 +668,8 @@ static void emulated_link_detect(struct dc_link *link)
 	link->type = dc_connection_none;
 	prev_sink = link->local_sink;
 
-	if (prev_sink != NULL)
-		dc_sink_retain(prev_sink);
+	if (prev_sink)
+		dc_sink_release(prev_sink);
 
 	switch (link->connector_signal) {
 	case SIGNAL_TYPE_HDMI_TYPE_A: {
-- 
2.27.0

