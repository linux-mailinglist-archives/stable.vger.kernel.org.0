Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80433E25A4
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244375AbhHFIVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244210AbhHFIU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C54C611C6;
        Fri,  6 Aug 2021 08:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238011;
        bh=mBenjGICbGqU4sL6JcNUEpVkieVEjgsM+z7KIGEOHJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jx0WI//TE2wkksvZuZsGSPPl5PFp8lFvpieA6AVfVotBVrJlxE/akoOlcdgnfKpZk
         qSAYmZP4xIDH6E/aEAKTj9WuEtU26vcSySWqk37dAFw/6SRcXJJETeAbQXkIw0QGi+
         uGnZ1dFvzCQd1+exSIHrBjjDxOoHxQ4ZGLalYBOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 18/35] regulator: mtk-dvfsrc: Fix wrong dev pointer for devm_regulator_register
Date:   Fri,  6 Aug 2021 10:17:01 +0200
Message-Id: <20210806081114.321583628@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit ea986908ccfcc53204a03bb0841227e1b26578c4 ]

If use dev->parent, the regulator_unregister will not be called when this
driver is unloaded. Fix it by using dev instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210702142140.2678130-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mtk-dvfsrc-regulator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/mtk-dvfsrc-regulator.c b/drivers/regulator/mtk-dvfsrc-regulator.c
index d3d876198d6e..234af3a66c77 100644
--- a/drivers/regulator/mtk-dvfsrc-regulator.c
+++ b/drivers/regulator/mtk-dvfsrc-regulator.c
@@ -179,8 +179,7 @@ static int dvfsrc_vcore_regulator_probe(struct platform_device *pdev)
 	for (i = 0; i < regulator_init_data->size; i++) {
 		config.dev = dev->parent;
 		config.driver_data = (mt_regulators + i);
-		rdev = devm_regulator_register(dev->parent,
-					       &(mt_regulators + i)->desc,
+		rdev = devm_regulator_register(dev, &(mt_regulators + i)->desc,
 					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(dev, "failed to register %s\n",
-- 
2.30.2



