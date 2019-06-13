Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6D744240
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbfFMQUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731075AbfFMIjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:39:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BA2B21479;
        Thu, 13 Jun 2019 08:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415157;
        bh=4cgkUSX3uc8F7sC9vRowliq9Lg2bN35c0ik/kD0q2pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaGVLF4M487Evpbuo5LbdHF9DlqgQHuOLB3CqKiVoSok/GgvbzySPC9NW8H3K5CAr
         kUyCUmRfpzg/pXoGbtcfrSymaowQ6HA1+yXb8xDFiWL7IajlEeGtddxgIuj6Dcb5dH
         CS9ebEMKC2rATmSov4dIhPIkfl+ISX8W7q+RAVNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/118] drm/nouveau/kms/gf119-gp10x: push HeadSetControlOutputResource() mthd when encoders change
Date:   Thu, 13 Jun 2019 10:32:42 +0200
Message-Id: <20190613075644.947418321@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a0b694d0af21c9993d1a39a75fd814bd48bf7eb4 ]

HW has error checks in place which check that pixel depth is explicitly
provided on DP, while HDMI has a "default" setting that we use.

In multi-display configurations with identical modelines, but different
protocols (HDMI + DP, in this case), it was possible for the DP head to
get swapped to the head which previously drove the HDMI output, without
updating HeadSetControlOutputResource(), triggering the error check and
hanging the core update.

Reported-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/head.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/nouveau/dispnv50/head.c
index 4f57e5379796..d81a99bb2ac3 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -306,7 +306,7 @@ nv50_head_atomic_check(struct drm_crtc *crtc, struct drm_crtc_state *state)
 			asyh->set.or = head->func->or != NULL;
 		}
 
-		if (asyh->state.mode_changed)
+		if (asyh->state.mode_changed || asyh->state.connectors_changed)
 			nv50_head_atomic_check_mode(head, asyh);
 
 		if (asyh->state.color_mgmt_changed ||
-- 
2.20.1



