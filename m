Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12564526A7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241280AbhKPCJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238103AbhKORym (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:54:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52C37632BB;
        Mon, 15 Nov 2021 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997587;
        bh=riSCkOPSPXxXO2ygGH3AOMcPVntOrlwwtdtdqB12rPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YZGmYsynKlP2K4AOMgP0b8hl89qsAifG5gCnIm7AWji+80P6Sdid64lowK9z4al5
         bzRw+c8AXIxKGchdkkJNOBX3c0/seBrGH7I9pBp+c8L1Ks7aN3guakH9aQypGDl/85
         zjblbt4i/kezPYGwtkEfXac3MJn1fMAdj65P2Qys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadezda Lutovinova <lutovinova@ispras.ru>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/575] media: rcar-csi2: Add checking to rcsi2_start_receiver()
Date:   Mon, 15 Nov 2021 17:58:47 +0100
Message-Id: <20211115165350.692539254@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit fc41665498332ad394b7db37f23e9394096ddc71 ]

If rcsi2_code_to_fmt() return NULL, then null pointer dereference occurs
in the next cycle. That should not be possible now but adding checking
protects from future bugs.
The patch adds checking if format is NULL.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 79f229756805e..d2d87a204e918 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -544,6 +544,8 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 
 	/* Code is validated in set_fmt. */
 	format = rcsi2_code_to_fmt(priv->mf.code);
+	if (!format)
+		return -EINVAL;
 
 	/*
 	 * Enable all supported CSI-2 channels with virtual channel and
-- 
2.33.0



