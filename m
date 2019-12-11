Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69BFB11B4D5
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbfLKPWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732557AbfLKPWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 895262073D;
        Wed, 11 Dec 2019 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077727;
        bh=3ArXGiMkiz38pZ0JixrmLD6V1Xs1RlgO+YskVi7oH3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwJ6TOXkPhY1CRvbs50bUwSeyRZPzCEERcs67LTqkSnSTbYpZRVGpY9FHudWfqFQS
         dmDtrDyXUCf6ZX+mf+TjdK0VucgSc6taA+svDv10whQ3CbI6EBfN7Le8dBeuANkKRt
         C3SShn4nlE4omuwhpeLjurizCfStBG9zuJvZRxF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Rob Herring <robh@kernel.org>,
        Wenzhen Yu <wenzhen.yu@mediatek.com>,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 146/243] clk: mediatek: Drop __init from mtk_clk_register_cpumuxes()
Date:   Wed, 11 Dec 2019 16:05:08 +0100
Message-Id: <20191211150349.023552012@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

commit 28f1186a26f7e4e5df7be454710da26c810effb6 upstream.

This function is used from more places than just __init code. Removing
__init silences a section mismatch warning here.

Cc: Sean Wang <sean.wang@mediatek.com>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Wenzhen Yu <wenzhen.yu@mediatek.com>
Cc: Weiyi Lu <weiyi.lu@mediatek.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/mediatek/clk-cpumux.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/clk/mediatek/clk-cpumux.c
+++ b/drivers/clk/mediatek/clk-cpumux.c
@@ -53,7 +53,7 @@ static const struct clk_ops clk_cpumux_o
 	.set_parent = clk_cpumux_set_parent,
 };
 
-static struct clk __init *
+static struct clk *
 mtk_clk_register_cpumux(const struct mtk_composite *mux,
 			struct regmap *regmap)
 {
@@ -84,9 +84,9 @@ mtk_clk_register_cpumux(const struct mtk
 	return clk;
 }
 
-int __init mtk_clk_register_cpumuxes(struct device_node *node,
-				     const struct mtk_composite *clks, int num,
-				     struct clk_onecell_data *clk_data)
+int mtk_clk_register_cpumuxes(struct device_node *node,
+			      const struct mtk_composite *clks, int num,
+			      struct clk_onecell_data *clk_data)
 {
 	int i;
 	struct clk *clk;


