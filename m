Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0EB37C32A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhELPRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233963AbhELPPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D88D661946;
        Wed, 12 May 2021 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831915;
        bh=jkaV2nmw3Gi8Q5AUWIBWA7kjbfP1eMYNfSxPqktk22w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNPGGDviCypv24pfX5P8u0Rdn2IJy4ZD64NlKl9tXLADH/f5ZsT6HLqx6O8+kUw4/
         rkRAT57WbSR/COXZA6/HB5tDW3QupXI+nkFSlWFxIrTd8i8/3GV3VuXjz8PYrD4LZx
         FKo0SPfK6v/rh6uUK/DfFVLL+/WLH4IhKn/NFIKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 065/530] drm/dp_mst: Revise broadcast msg lct & lcr
Date:   Wed, 12 May 2021 16:42:55 +0200
Message-Id: <20210512144821.895553542@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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


