Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB6334C847
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhC2IVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232879AbhC2IUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B73F61481;
        Mon, 29 Mar 2021 08:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006014;
        bh=scYFnPO7AI/FT4LtJjU+VmWJqAOw/DeltX3UR58X2z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTtXNPJTTjZw+r9WO0DzsOG1fhKklqEG0E4zwsNh6KIvRCUT13skBTLNZvXGXgtXz
         xSWDcX8Emex1ujgkp9MLm95PGoOqnYAeOXPneIhJno/JK6UNDBz+yxCtS8gHCuwmA8
         QqaGwU1B9a+8/Bwr1r6wsz8tKRYSpN4axnXyxjaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Igor Kravchenko <Igor.Kravchenko@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 5.10 086/221] drm/amdgpu/display: restore AUX_DPHY_TX_CONTROL for DCN2.x
Date:   Mon, 29 Mar 2021 09:56:57 +0200
Message-Id: <20210329075632.079378620@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 5c458585c0141754cdcbf25feebb547dd671b559 upstream.

Commit 098214999c8f added fetching of the AUX_DPHY register
values from the vbios, but it also changed the default values
in the case when there are no values in the vbios.  This causes
problems with displays with high refresh rates.  To fix this,
switch back to the original default value for AUX_DPHY_TX_CONTROL.

Fixes: 098214999c8f ("drm/amd/display: Read VBIOS Golden Settings Tbl")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1426
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Igor Kravchenko <Igor.Kravchenko@amd.com>
Cc: Aric Cyr <Aric.Cyr@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_link_encoder.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_link_encoder.c
@@ -341,8 +341,7 @@ void enc2_hw_init(struct link_encoder *e
 	} else {
 		AUX_REG_WRITE(AUX_DPHY_RX_CONTROL0, 0x103d1110);
 
-		AUX_REG_WRITE(AUX_DPHY_TX_CONTROL, 0x21c4d);
-
+		AUX_REG_WRITE(AUX_DPHY_TX_CONTROL, 0x21c7a);
 	}
 
 	//AUX_DPHY_TX_REF_CONTROL'AUX_TX_REF_DIV HW default is 0x32;


