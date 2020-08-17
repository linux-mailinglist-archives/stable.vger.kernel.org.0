Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEDB247435
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbgHQTGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387689AbgHQPoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:44:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D489122D00;
        Mon, 17 Aug 2020 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679048;
        bh=Z6K4uvy4C7W23CznrC/gasZ1erGhoQ4x23h6wbcUX98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9S2HUW+v8B8eTuf+uRI14G5riz3tduGZIEYQGKPSXi6ystDDzN1U9RQjKCmM6aih
         1QZCBhjT4n6r+ll3d+K9HvEjLsUCuC/a2v2SQvDZvhbLHdWsaF94MBD5emOTT5vPpj
         NSelAxKWx0n8hpEviKYfPkkJ5XSyyEfoqMmd7oSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 078/393] drm/nouveau/kms/nv50-: Fix disabling dithering
Date:   Mon, 17 Aug 2020 17:12:08 +0200
Message-Id: <20200817143823.400058467@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit fb2420b701edbf96c2b6d557f0139902f455dc2b ]

While we expose the ability to turn off hardware dithering for nouveau,
we actually make the mistake of turning it on anyway, due to
dithering_depth containing a non-zero value if our dithering depth isn't
also set to 6 bpc.

So, fix it by never enabling dithering when it's disabled.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Acked-by: Dave Airlie <airlied@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200627194657.156514-6-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/head.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/nouveau/dispnv50/head.c
index 8f6455697ba72..ed6819519f6d8 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -84,18 +84,20 @@ nv50_head_atomic_check_dither(struct nv50_head_atom *armh,
 {
 	u32 mode = 0x00;
 
-	if (asyc->dither.mode == DITHERING_MODE_AUTO) {
-		if (asyh->base.depth > asyh->or.bpc * 3)
-			mode = DITHERING_MODE_DYNAMIC2X2;
-	} else {
-		mode = asyc->dither.mode;
-	}
+	if (asyc->dither.mode) {
+		if (asyc->dither.mode == DITHERING_MODE_AUTO) {
+			if (asyh->base.depth > asyh->or.bpc * 3)
+				mode = DITHERING_MODE_DYNAMIC2X2;
+		} else {
+			mode = asyc->dither.mode;
+		}
 
-	if (asyc->dither.depth == DITHERING_DEPTH_AUTO) {
-		if (asyh->or.bpc >= 8)
-			mode |= DITHERING_DEPTH_8BPC;
-	} else {
-		mode |= asyc->dither.depth;
+		if (asyc->dither.depth == DITHERING_DEPTH_AUTO) {
+			if (asyh->or.bpc >= 8)
+				mode |= DITHERING_DEPTH_8BPC;
+		} else {
+			mode |= asyc->dither.depth;
+		}
 	}
 
 	asyh->dither.enable = mode;
-- 
2.25.1



