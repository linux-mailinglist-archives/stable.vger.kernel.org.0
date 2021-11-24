Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C9A45BFA9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345087AbhKXNAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347467AbhKXM6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:58:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B2A661101;
        Wed, 24 Nov 2021 12:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757236;
        bh=HHNgnnC0YH+UQ2SkIlv++jtsxO7zKOpuQ4wWcjuxFCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7VYZW4zxN0qSOVsjybTY/PCEExeFYb0O1YdCc+rWBSBdXsbIN+GpICbYo+Ijfbr7
         GTVWb9YuydAx46uuaVbn2Ovcsg9sDwKnIy2D5W50ZsTQk/OYS/Y1j3rumzSpDnMLiX
         dO8huHzIylE3IfCg8eKZvgMK0Ognk/WppPaaJyqI=
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
Subject: [PATCH 4.19 102/323] media: rcar-csi2: Add checking to rcsi2_start_receiver()
Date:   Wed, 24 Nov 2021 12:54:52 +0100
Message-Id: <20211124115722.409157428@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index dc5ae8025832a..23f55514b002a 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -474,6 +474,8 @@ static int rcsi2_start(struct rcar_csi2 *priv)
 
 	/* Code is validated in set_fmt. */
 	format = rcsi2_code_to_fmt(priv->mf.code);
+	if (!format)
+		return -EINVAL;
 
 	/*
 	 * Enable all Virtual Channels.
-- 
2.33.0



