Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A175328A23
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbhCASMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238653AbhCASGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:06:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9BF7650BE;
        Mon,  1 Mar 2021 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620530;
        bh=cyYO7R/YFA4bYhrtrCdcWYU0gJWcDihPwJQksytHu/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4QeGCEz/kC9tzqmxlwTulKOlu7r8ezXA+iCPgwy5AB8Mprp5yIPOgzfFheUihZ7h
         5dbAWi0YU9MzZFrJl8weebkBx/p97k9kJESES0K4FO3BD0eZWq/aZS95tg5o9ELJwn
         tgPNj6BFskO17paeSk1NOczVSoctn/IczIYSVK84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Xiaojun <wangxiaojun11@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 186/775] drm: rcar-du: Fix the return check of of_parse_phandle and of_find_device_by_node
Date:   Mon,  1 Mar 2021 17:05:54 +0100
Message-Id: <20210301161210.823060139@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Xiaojun <wangxiaojun11@huawei.com>

[ Upstream commit 8d7d33f6be06f929ac2c5e8ea2323fec272790d4 ]

of_parse_phandle and of_find_device_by_node may return NULL
which cannot be checked by IS_ERR.

Fixes: 8de707aeb452 ("drm: rcar-du: kms: Initialize CMM instances")
Signed-off-by: Wang Xiaojun <wangxiaojun11@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

[Replace -ENODEV with -EINVAL]

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_kms.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index 72dda446355fe..7015e22872bbe 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -700,10 +700,10 @@ static int rcar_du_cmm_init(struct rcar_du_device *rcdu)
 		int ret;
 
 		cmm = of_parse_phandle(np, "renesas,cmms", i);
-		if (IS_ERR(cmm)) {
+		if (!cmm) {
 			dev_err(rcdu->dev,
 				"Failed to parse 'renesas,cmms' property\n");
-			return PTR_ERR(cmm);
+			return -EINVAL;
 		}
 
 		if (!of_device_is_available(cmm)) {
@@ -713,10 +713,10 @@ static int rcar_du_cmm_init(struct rcar_du_device *rcdu)
 		}
 
 		pdev = of_find_device_by_node(cmm);
-		if (IS_ERR(pdev)) {
+		if (!pdev) {
 			dev_err(rcdu->dev, "No device found for CMM%u\n", i);
 			of_node_put(cmm);
-			return PTR_ERR(pdev);
+			return -EINVAL;
 		}
 
 		of_node_put(cmm);
-- 
2.27.0



