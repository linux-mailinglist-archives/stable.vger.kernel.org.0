Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2594998D0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453482AbiAXVaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42788 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450081AbiAXVTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:19:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC9F661469;
        Mon, 24 Jan 2022 21:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EEBC340E4;
        Mon, 24 Jan 2022 21:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059181;
        bh=jq3qAwfolb3vJnwEB5So1WRHousxwOrTd3MkQgUiNl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFOYP4WEMMAkzzx8m2oqlUi9RN1M4MjMTcH3c72v7edAKVQnbedS49WEZorGf3JPd
         PES7c2zjuCQ5LNsKp2coKvCgcjlB3m0s4mw0aqxpqy2V6fjHVPxDts1G47TR0RRp3M
         MRFlbqy6+H84NsVF/rIgjx+t8yutunYVprssKTwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0530/1039] of: base: Fix phandle argument length mismatch error message
Date:   Mon, 24 Jan 2022 19:38:39 +0100
Message-Id: <20220124184143.098307142@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 61de453b885cb..81b956ab2348e 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1349,9 +1349,9 @@ int of_phandle_iterator_next(struct of_phandle_iterator *it)
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



