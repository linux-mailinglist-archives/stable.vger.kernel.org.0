Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF962E3F62
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503356AbgL1O3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:29:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:37592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503355AbgL1O3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:29:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CA22221F0;
        Mon, 28 Dec 2020 14:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165736;
        bh=R92SEvHeLAvXYKXb3dh4dW6TqVPMF1IA50HX4skct8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXmFvsurzHkuHxV9joR9eYQAt94H7/aZvMrcHNZAn4Uti+xDIv0KgUYGilHoKZmgE
         w7arEeIzjec0CfciZ1wZysC8UVUYItHWAzYqoaJBkR92fjWP5OEpYqUYGO4XJ+iMjm
         JmWZCZAf6PsC6bjHph0Db1KfqWVf4K7FfvvH1nNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kris Karas <bugs-a17@moonlit-rail.com>,
        Oleg Vasilev <oleg.vasilev@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 636/717] drm/amdgpu: only set DP subconnector type on DP and eDP connectors
Date:   Mon, 28 Dec 2020 13:50:34 +0100
Message-Id: <20201228125051.394410135@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 05211e7fbbf042dd7f51155ebe64eb2ecacb25cb upstream.

Fixes a crash in drm_object_property_set_value() because the property
is not set for internal DP ports that connect to a bridge chips
(e.g., DP to VGA or DP to LVDS).

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=210739
Fixes: 65bf2cf95d3ade ("drm/amdgpu: utilize subconnector property for DP through atombios")
Tested-By: Kris Karas <bugs-a17@moonlit-rail.com>
Cc: Oleg Vasilev <oleg.vasilev@intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1414,10 +1414,12 @@ out:
 		pm_runtime_put_autosuspend(connector->dev->dev);
 	}
 
-	drm_dp_set_subconnector_property(&amdgpu_connector->base,
-					 ret,
-					 amdgpu_dig_connector->dpcd,
-					 amdgpu_dig_connector->downstream_ports);
+	if (connector->connector_type == DRM_MODE_CONNECTOR_DisplayPort ||
+	    connector->connector_type == DRM_MODE_CONNECTOR_eDP)
+		drm_dp_set_subconnector_property(&amdgpu_connector->base,
+						 ret,
+						 amdgpu_dig_connector->dpcd,
+						 amdgpu_dig_connector->downstream_ports);
 	return ret;
 }
 


