Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC3E44184C
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhKAJpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234072AbhKAJoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 519DC613A7;
        Mon,  1 Nov 2021 09:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758963;
        bh=xVN+tuD72jEaxUbrrSNkVumd7VGK1bDnzJPn6ufC6Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=at7aOPxtj90FCH6v3XlgfucvaIzYjg11A8P3c3SwFqJb+odmTyInQoscjqKF1L+JX
         5Ym4HOV0NBywcJvxBc0eQz2la/wclN5e+2c3MpizHBf+/ktnIbBx0nMBueaezMadOJ
         0jNsvq2bH7+xfDuolJi92i6Yrys7+IVzMmJ6Ia48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Aric Cyr <aric.cyr@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 056/125] drm/amd/display: Fix deadlock when falling back to v2 from v3
Date:   Mon,  1 Nov 2021 10:17:09 +0100
Message-Id: <20211101082543.773829070@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit ad76744b041d8c87ef1c9adbb04fb7eaa20a179e upstream.

[Why]
A deadlock in the kernel occurs when we fallback from the V3 to V2
add_topology_to_display or remove_topology_to_display because they
both try to acquire the dtm_mutex but recursive locking isn't
supported on mutex_lock().

[How]
Make the mutex_lock/unlock more fine grained and move them up such that
they're only required for the psp invocation itself.

Fixes: bf62221e9d0e ("drm/amd/display: Add DCN3.1 HDCP support")

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
@@ -105,6 +105,7 @@ static enum mod_hdcp_status mod_hdcp_rem
 	dtm_cmd->dtm_status = TA_DTM_STATUS__GENERIC_FAILURE;
 
 	psp_dtm_invoke(psp, dtm_cmd->cmd_id);
+	mutex_unlock(&psp->dtm_context.mutex);
 
 	if (dtm_cmd->dtm_status != TA_DTM_STATUS__SUCCESS) {
 		status = mod_hdcp_remove_display_from_topology_v2(hdcp, index);
@@ -115,8 +116,6 @@ static enum mod_hdcp_status mod_hdcp_rem
 		HDCP_TOP_REMOVE_DISPLAY_TRACE(hdcp, display->index);
 	}
 
-	mutex_unlock(&psp->dtm_context.mutex);
-
 	return status;
 }
 
@@ -218,6 +217,7 @@ static enum mod_hdcp_status mod_hdcp_add
 	dtm_cmd->dtm_in_message.topology_update_v3.link_hdcp_cap = link->hdcp_supported_informational;
 
 	psp_dtm_invoke(psp, dtm_cmd->cmd_id);
+	mutex_unlock(&psp->dtm_context.mutex);
 
 	if (dtm_cmd->dtm_status != TA_DTM_STATUS__SUCCESS) {
 		status = mod_hdcp_add_display_to_topology_v2(hdcp, display);
@@ -227,8 +227,6 @@ static enum mod_hdcp_status mod_hdcp_add
 		HDCP_TOP_ADD_DISPLAY_TRACE(hdcp, display->index);
 	}
 
-	mutex_unlock(&psp->dtm_context.mutex);
-
 	return status;
 }
 


