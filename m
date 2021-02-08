Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC1F3137D7
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhBHPcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233734AbhBHP1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:27:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5856264F22;
        Mon,  8 Feb 2021 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797368;
        bh=ioxTXhTaBLo6ys1vAP1V4SXpdQMw7n1dC61Zm2pmJAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1MVi1ZTzdNcd4RUdXJNedhgyxmUPA6OCdUnwLIBcMAQVzA2hRMT9gWE2EKh4aKZv
         9VlezDBcBi6FMicnDZf5bSaark3ul6R8oq6CJYCmPcU9yWKRAjZ1heV21fzDE1daZt
         wLN08NvCfJsMkvNGbqCPhIC3Xk0ZBPfStnpmlbOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stylon Wang <stylon.wang@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 085/120] drm/amd/display: Revert "Fix EDID parsing after resume from suspend"
Date:   Mon,  8 Feb 2021 16:01:12 +0100
Message-Id: <20210208145821.795935438@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

commit 1a10e5244778169a5a53a527d7830cf0438132a1 upstream.

This reverts commit b24bdc37d03a0478189e20a50286092840f414fa.
It caused memory leak after S3 on 4K HDMI displays.

Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2278,8 +2278,6 @@ void amdgpu_dm_update_connector_after_de
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
-			drm_add_edid_modes(connector, aconnector->edid);
-
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,
 						    aconnector->edid);


