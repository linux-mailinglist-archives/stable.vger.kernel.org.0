Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E677337CB3F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242519AbhELQe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241612AbhELQ1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5647C61DF2;
        Wed, 12 May 2021 15:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834858;
        bh=jkaV2nmw3Gi8Q5AUWIBWA7kjbfP1eMYNfSxPqktk22w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCUqEP4XCVABjxdASKDtpitOGzptGXDLHbDTsd7FQU8zmIRZxHMPR7exLEXt7zO7t
         gQiCyCvX3/kg5IygTVOfDU2aJQwhHKgwHBhe6vWIfELV/vaq7K/UKz65+fH89kgjBH
         TzgsVIIQYvEpXC+VnnQ6nVQAGF+v86nlmrFJrdWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.12 076/677] drm/dp_mst: Revise broadcast msg lct & lcr
Date:   Wed, 12 May 2021 16:42:02 +0200
Message-Id: <20210512144839.759185206@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

commit 419e91ea3143bf26991442465ac64d9461e98d96 upstream.

[Why & How]
According to DP spec, broadcast message LCT equals to 1 and LCR equals
to 6. Current implementation is incorrect. Fix it.
In addition, revise a bit the hdr->rad handling to include broadcast
case.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210224101521.6713-2-Wayne.Lin@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2829,10 +2829,15 @@ static int set_hdr_from_dst_qlock(struct
 	else
 		hdr->broadcast = 0;
 	hdr->path_msg = txmsg->path_msg;
-	hdr->lct = mstb->lct;
-	hdr->lcr = mstb->lct - 1;
-	if (mstb->lct > 1)
-		memcpy(hdr->rad, mstb->rad, mstb->lct / 2);
+	if (hdr->broadcast) {
+		hdr->lct = 1;
+		hdr->lcr = 6;
+	} else {
+		hdr->lct = mstb->lct;
+		hdr->lcr = mstb->lct - 1;
+	}
+
+	memcpy(hdr->rad, mstb->rad, hdr->lct / 2);
 
 	return 0;
 }


