Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09402E3F6F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503470AbgL1O3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:29:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503454AbgL1O3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:29:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43B0C2242A;
        Mon, 28 Dec 2020 14:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165738;
        bh=f0MtBYQxwyMH24PPgtWnGMiKGObX0dd4D6wQQYlc8/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzjwRMqNRM1mD/sm80yTyXUaInwj8yNfX78Ei7/9THFM9iYDTs7Qm67Gg06bhAWYX
         RVzfn0cz/tIR+uRu3uH5X8uauL4AQUHB2eiqLLXFHobnuiSO0Wy7Q6ebBcZZRQKpMV
         iF/Li+m+ihimcTaUSRseAGgCEe06x+tuc1kRphjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>
Subject: [PATCH 5.10 637/717] drm/amd/display: Fix memory leaks in S3 resume
Date:   Mon, 28 Dec 2020 13:50:35 +0100
Message-Id: <20201228125051.444911072@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362 upstream.

EDID parsing in S3 resume pushes new display modes
to probed_modes list but doesn't consolidate to actual
mode list. This creates a race condition when
amdgpu_dm_connector_ddc_get_modes() re-initializes the
list head without walking the list and results in  memory leak.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=209987
Acked-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2278,7 +2278,8 @@ void amdgpu_dm_update_connector_after_de
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
-			drm_add_edid_modes(connector, aconnector->edid);
+			aconnector->num_modes = drm_add_edid_modes(connector, aconnector->edid);
+			drm_connector_list_update(connector);
 
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,


