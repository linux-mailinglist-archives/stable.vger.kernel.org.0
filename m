Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B82837C7CD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbhELQCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237744AbhELP4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3499D61453;
        Wed, 12 May 2021 15:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833301;
        bh=tvYm0EGFUqeYlgwdXWIFOc77jLjBntRRaa/VugxJFn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etw1GVda/jxnhPcRw1lPXAZ9MCRZp5hh9MTEt91sh6AhF+Z58kpN4nOEj1alQjNR2
         zhhvIL807rUtBztUzncFunIpJ+5Mefpaa1QvV5mBgIL0XvPMVhJHwHExQDazedAu2h
         rAu50b+g+Xo5nvWC9KUbzsWQxR5kQL1dzRiZdbBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.11 068/601] drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
Date:   Wed, 12 May 2021 16:42:25 +0200
Message-Id: <20210512144830.051154699@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

commit d919d3d6cdb31d0f9fe06c880f683a24f2838813 upstream.

[Why & How]
According to DP spec, CLEAR_PAYLOAD_ID_TABLE is a path broadcast request
message and current implementation is incorrect. Fix it.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210224101521.6713-3-Wayne.Lin@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1154,6 +1154,7 @@ static void build_clear_payload_id_table
 
 	req.req_type = DP_CLEAR_PAYLOAD_ID_TABLE;
 	drm_dp_encode_sideband_req(&req, msg);
+	msg->path_msg = true;
 }
 
 static int build_enum_path_resources(struct drm_dp_sideband_msg_tx *msg,
@@ -2824,7 +2825,8 @@ static int set_hdr_from_dst_qlock(struct
 
 	req_type = txmsg->msg[0] & 0x7f;
 	if (req_type == DP_CONNECTION_STATUS_NOTIFY ||
-		req_type == DP_RESOURCE_STATUS_NOTIFY)
+		req_type == DP_RESOURCE_STATUS_NOTIFY ||
+		req_type == DP_CLEAR_PAYLOAD_ID_TABLE)
 		hdr->broadcast = 1;
 	else
 		hdr->broadcast = 0;


