Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7980E24FAB6
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHXIdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgHXId0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06913206F0;
        Mon, 24 Aug 2020 08:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258006;
        bh=4CNSfVrCBAZQkhDGS1J1IlqaAAqRPrPo8zCzlL0vzx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btzR8/g2fMZy85OD4fnQAjSGjwrZoSWKFtQA/0c4yffhLXIs8NjcCW6iVlyY9HWvq
         1cih+fWF1Uxj/Msixn8TMBgFdACXmCmn82TYh0X1WW1ekig1ye8uhCQHsvlzVqhw85
         QE00NMODi8Ub81yr8YC1CWdaUmYA7ANLzC5uk5kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stylon Wang <stylon.wang@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.8 039/148] drm/amd/display: Fix EDID parsing after resume from suspend
Date:   Mon, 24 Aug 2020 10:28:57 +0200
Message-Id: <20200824082415.919874230@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

commit b24bdc37d03a0478189e20a50286092840f414fa upstream.

[Why]
Resuming from suspend, CEA blocks from EDID are not parsed and no video
modes can support YUV420. When this happens, output bpc cannot go over
8-bit with 4K modes on HDMI.

[How]
In amdgpu_dm_update_connector_after_detect(), drm_add_edid_modes() is
called after drm_connector_update_edid_property() to fully parse EDID
and update display info.

Cc: stable@vger.kernel.org
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2184,6 +2184,7 @@ void amdgpu_dm_update_connector_after_de
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
+			drm_add_edid_modes(connector, aconnector->edid);
 
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,


