Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3792106EB6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfKVLA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfKVLA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:00:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 915BE2073B;
        Fri, 22 Nov 2019 11:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420425;
        bh=tXZk9214sgJzo8KjHLglNwAtrSjYARemGMUZSBxff4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZmfBPyfKPEmgTLmPQp1RTmJ+TWc38OIbkWVZSZ7UAGfTbej7GZ/AAY/qmtXEa/ZO
         /cXN4cB3Vo+1cYsWraI0mPr32HecFPFMsZxXowfgJiczittfyIGCoB+oxqqnf9/WBB
         lSpGpiina8ILJ7Mjs0I9k/CUOD7DeN1jvgqCHWmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/220] media: rcar-vin: fix redeclaration of symbol
Date:   Fri, 22 Nov 2019 11:27:47 +0100
Message-Id: <20191122100920.111655154@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 4e673ed4e2bfac00b3c3043a84e007874c17c84d ]

When adding support for parallel subdev for Gen3 it was missed that the
symbol 'i' in rvin_group_link_notify() was already declared, remove the
dupe as it's only used as a loop variable this have no functional
change. This fixes warning:

    rcar-core.c:117:52: originally declared here
    rcar-core.c:173:30: warning: symbol 'i' shadows an earlier one

Fixes: 1284605dc821cebd ("media: rcar-vin: Handle parallel subdev in link_notify")

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index e1085e3ab3cc6..485fa3fa8b49a 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -174,7 +174,6 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 
 	if (csi_id == -ENODEV) {
 		struct v4l2_subdev *sd;
-		unsigned int i;
 
 		/*
 		 * Make sure the source entity subdevice is registered as
-- 
2.20.1



