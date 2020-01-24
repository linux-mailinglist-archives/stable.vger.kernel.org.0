Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5333147C75
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388122AbgAXJwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:52:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387647AbgAXJwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:52:08 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37F24214AF;
        Fri, 24 Jan 2020 09:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859528;
        bh=vOaRV2Zsxz6eJLQKgsaifaCqnX5DT8SKtVnN+eF/u9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqHIYuw2CjXoc8kvIZqFEieXHeu/0HxyEffu+19366ylgX4QpUP47wJzHT3jJYSK+
         Zy6vCbqxbIGTvaoTAorqDZJMgoBz7FpRAoHm88bji4amAofKkGT8BIu8v5D3aRj2yE
         e+0bEgmLrP0V+ES8QYDjh6ctWzlo0ETrSmTsGseA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 114/343] regulator: pv88060: Fix array out-of-bounds access
Date:   Fri, 24 Jan 2020 10:28:52 +0100
Message-Id: <20200124092935.028747442@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 7cd415f875591bc66c5ecb49bf84ef97e80d7b0e ]

Fix off-by-one while iterating current_limits array.
The valid index should be 0 ~ n_current_limits -1.

Fixes: f307a7e9b7af ("regulator: pv88060: new regulator driver")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pv88060-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pv88060-regulator.c b/drivers/regulator/pv88060-regulator.c
index a9446056435f9..1f2d8180506bc 100644
--- a/drivers/regulator/pv88060-regulator.c
+++ b/drivers/regulator/pv88060-regulator.c
@@ -135,7 +135,7 @@ static int pv88060_set_current_limit(struct regulator_dev *rdev, int min,
 	int i;
 
 	/* search for closest to maximum */
-	for (i = info->n_current_limits; i >= 0; i--) {
+	for (i = info->n_current_limits - 1; i >= 0; i--) {
 		if (min <= info->current_limits[i]
 			&& max >= info->current_limits[i]) {
 			return regmap_update_bits(rdev->regmap,
-- 
2.20.1



