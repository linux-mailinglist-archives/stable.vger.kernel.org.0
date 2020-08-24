Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94EF24F906
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgHXIqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729104AbgHXIqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:46:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F0B3204FD;
        Mon, 24 Aug 2020 08:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258770;
        bh=PytyJQyEU46vyyqpShlG43bv0cszxenOGURoWaVe4Oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6I5P1Py7ZU3CgvrnzQ14lxyaMZzpsMdX4dcGdBGZl4e7Kig5Yj/shfXgG3dA3HLM
         3xSnhXjiMUdaGzVbXHIGmdT5VC4spJEnyqpCdhyOCT03Wy7LAfYL7+u7ULPqNOBikv
         XUQrdXuCXgQLIcG4+ltwVtHTueqDzGUgKqvg5vHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stylon Wang <stylon.wang@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 037/107] drm/amd/display: Fix EDID parsing after resume from suspend
Date:   Mon, 24 Aug 2020 10:30:03 +0200
Message-Id: <20200824082406.960304366@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
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
@@ -1434,6 +1434,7 @@ amdgpu_dm_update_connector_after_detect(
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
+			drm_add_edid_modes(connector, aconnector->edid);
 
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,


