Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A324454D2
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhKDOR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231880AbhKDOR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8FFC611C4;
        Thu,  4 Nov 2021 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035290;
        bh=7GVP9ZmEGVTpLLR+MX++U7nu19yZXc1jomRbUneDCYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDtMeLlyZGJlGX5iF/fChQthNdv3j0uhJXjWrP+2KlH3OYNE1rU0KQyEG+9nMoB4o
         Hauv2+lk4we4VXPYpVWC+6EDeTSWGB66kWqxrvcjJggyYjXWItRtScnsCtuaQWp/fr
         WD5TSO5Z4zUMhEbgEtf6Dz2LZPPoeX+zD9jpoftw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikita Lipski <mikita.lipski@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 13/16] drm/amd/display: Revert "Directly retrain link from debugfs"
Date:   Thu,  4 Nov 2021 15:12:44 +0100
Message-Id: <20211104141200.291316186@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
References: <20211104141159.863820939@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Jacob <Anson.Jacob@amd.com>

commit 1131cadfd7563975f3a4efcc6f7c1fdc872db38b upstream.

This reverts commit f5b6a20c7ef40599095c796b0500d842ffdbc639.

This patch broke new settings from taking effect. Hotplug is
required for new settings to take effect.

Reviewed-by: Mikita Lipski <mikita.lipski@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -247,6 +247,7 @@ static ssize_t dp_link_settings_write(st
 {
 	struct amdgpu_dm_connector *connector = file_inode(f)->i_private;
 	struct dc_link *link = connector->dc_link;
+	struct dc *dc = (struct dc *)link->dc;
 	struct dc_link_settings prefer_link_settings;
 	char *wr_buf = NULL;
 	const uint32_t wr_buf_size = 40;
@@ -313,7 +314,7 @@ static ssize_t dp_link_settings_write(st
 	prefer_link_settings.lane_count = param[0];
 	prefer_link_settings.link_rate = param[1];
 
-	dp_retrain_link_dp_test(link, &prefer_link_settings, false);
+	dc_link_set_preferred_training_settings(dc, &prefer_link_settings, NULL, link, true);
 
 	kfree(wr_buf);
 	return size;


