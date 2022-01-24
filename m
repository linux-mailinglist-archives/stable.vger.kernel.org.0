Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79601499403
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388199AbiAXUiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36182 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385324AbiAXUcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:32:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38729B80FA1;
        Mon, 24 Jan 2022 20:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A70C340E8;
        Mon, 24 Jan 2022 20:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056342;
        bh=cWCfpUm6/xCPD6xXNOQTKl0dLRuxo0mq3m5aeNsLg/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHNL9dE+flxwLFcjvWgUG/MAcZh7WHt4X5Op9QIuOkKiwmgBbiX+22vGcZ2CanoH0
         okBWBmAlcPvE0N/boh6d1CWsIHeYk+4ZTcQRyn1BPRBdUFvNga+O6rVZB3FhKYcMYF
         JLORgvK44mUQ7+xOVmrGkyjNMiyxPLaaB4GooCMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 452/846] of: base: Fix phandle argument length mismatch error message
Date:   Mon, 24 Jan 2022 19:39:29 +0100
Message-Id: <20220124184116.581350857@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 94a4950a4acff39b5847cc1fee4f65e160813493 ]

The cell_count field of of_phandle_iterator is the number of cells we
expect in the phandle arguments list when cells_name is missing. The
error message should show the number of cells we actually see.

Fixes: af3be70a3211 ("of: Improve of_phandle_iterator_next() error message")
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/96519ac55be90a63fa44afe01480c30d08535465.1640881913.git.baruch@tkos.co.il
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 0ac17256258d5..211c4da5abef6 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1327,9 +1327,9 @@ int of_phandle_iterator_next(struct of_phandle_iterator *it)
 		 * property data length
 		 */
 		if (it->cur + count > it->list_end) {
-			pr_err("%pOF: %s = %d found %d\n",
+			pr_err("%pOF: %s = %d found %td\n",
 			       it->parent, it->cells_name,
-			       count, it->cell_count);
+			       count, it->list_end - it->cur);
 			goto err;
 		}
 	}
-- 
2.34.1



