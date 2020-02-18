Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 271441631EC
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgBRUDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbgBRUDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BFFB24125;
        Tue, 18 Feb 2020 20:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056214;
        bh=jm14cuJBTP7GwLRT1+HvrOAskCL2iqjqaGpy9rNhLDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdKso1XdYk4I2J0c9ZwsWdgN88pIis4Bkma/W7cPDApZq1HJ80DIeerupfOh4pPXE
         kI0E7bVkghXfPiXQ1N5VS1M3aZmNMqDKqS36Tic5h36J5JhgT389mk4lgj39r9D/Cs
         Aljh4Yyn5N7F0R6g1mONhSdvTtmX5/nC1I7h8Ync=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Sean Paul <sean@poorly.run>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
Subject: [PATCH 5.5 41/80] drm/mst: Fix possible NULL pointer dereference in drm_dp_mst_process_up_req()
Date:   Tue, 18 Feb 2020 20:55:02 +0100
Message-Id: <20200218190436.290258677@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

commit 8ccb5bf7619c6523e7a4384a84b72e7be804298c upstream.

According to DP specification, DP_SINK_EVENT_NOTIFY is also a
broadcast message but as this function only handles
DP_CONNECTION_STATUS_NOTIFY I will only make the static
analyzer that caught this issue happy by not calling
drm_dp_get_mst_branch_device_by_guid() with a NULL guid, causing
drm_dp_mst_process_up_req() to return in the "if (!mstb)" right
bellow.

Fixes: 9408cc94eb04 ("drm/dp_mst: Handle UP requests asynchronously")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Sean Paul <sean@poorly.run>
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
[added cc to stable]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200129232448.84704-1-jose.souza@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_mst_topology.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3772,7 +3772,8 @@ drm_dp_mst_process_up_req(struct drm_dp_
 		else if (msg->req_type == DP_RESOURCE_STATUS_NOTIFY)
 			guid = msg->u.resource_stat.guid;
 
-		mstb = drm_dp_get_mst_branch_device_by_guid(mgr, guid);
+		if (guid)
+			mstb = drm_dp_get_mst_branch_device_by_guid(mgr, guid);
 	} else {
 		mstb = drm_dp_get_mst_branch_device(mgr, hdr->lct, hdr->rad);
 	}


