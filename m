Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2DFA58B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfKMCXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:23:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbfKMBwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0E4322459;
        Wed, 13 Nov 2019 01:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609958;
        bh=tXZk9214sgJzo8KjHLglNwAtrSjYARemGMUZSBxff4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ge6dWYaMV8mar/DvWjuENnr+5+/YyoNZ51Zo4ZOltUIreUypXOuHvEeMA7i2l2CQ8
         ajQQodDBvTzawvVPvnOnGs1FXFDvXgdPnNGuZCr96Y/Jm/dZGNec0zg/ziskQe/bfR
         PQ/T4BeJUp/bngt22DpXj2gzVUSY61J3t/BCCoR8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 091/209] media: rcar-vin: fix redeclaration of symbol
Date:   Tue, 12 Nov 2019 20:48:27 -0500
Message-Id: <20191113015025.9685-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

