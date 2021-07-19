Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93EB3CE016
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346096AbhGSPNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345622AbhGSPML (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9B536135C;
        Mon, 19 Jul 2021 15:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709959;
        bh=clzoqKNetUcJ+lkLQDWwtYU9CiEyEKAkHpiyoVX86Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDCVq3Exqxh/2gG35oSrrWAu22TJplYUA/IRpz0M/9LxGAZ7W0EldZdxoxNN8vbyd
         rYF/gq0kUKBv2Atr0rP5MIWF5J9soxoakyOPnCqVciflbOGitGaSBYj3NQhXb1GqQd
         MJMdsvEvrutk4txZiolpu40+z5POzU2Tq3EeLjPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Lyude Paul <lyude@redhat.com>, dri-devel@lists.freedesktop.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
Subject: [PATCH 5.10 017/243] drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()
Date:   Mon, 19 Jul 2021 16:50:46 +0200
Message-Id: <20210719144941.475992307@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

commit 24ff3dc18b99c4b912ab1746e803ddb3be5ced4c upstream.

Commit 3769e4c0af5b ("drm/dp_mst: Avoid to mess up payload table by
ports in stale topology") added to calls to drm_dbg_kms() but it
missed the first parameter, the drm device breaking the build.

Fixes: 3769e4c0af5b ("drm/dp_mst: Avoid to mess up payload table by ports in stale topology")
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210616194415.36926-1-jose.souza@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3385,7 +3385,9 @@ int drm_dp_update_payload_part1(struct d
 			mutex_unlock(&mgr->lock);
 
 			if (skip) {
-				drm_dbg_kms("Virtual channel %d is not in current topology\n", i);
+				drm_dbg_kms(mgr->dev,
+					    "Virtual channel %d is not in current topology\n",
+					    i);
 				continue;
 			}
 			/* Validated ports don't matter if we're releasing
@@ -3400,7 +3402,8 @@ int drm_dp_update_payload_part1(struct d
 						payload->start_slot = req_payload.start_slot;
 						continue;
 					} else {
-						drm_dbg_kms("Fail:set payload to invalid sink");
+						drm_dbg_kms(mgr->dev,
+							    "Fail:set payload to invalid sink");
 						mutex_unlock(&mgr->payload_lock);
 						return -EINVAL;
 					}


