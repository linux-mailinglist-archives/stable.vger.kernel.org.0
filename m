Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B70912185C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfLPR7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728769AbfLPR72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:59:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F5A21582;
        Mon, 16 Dec 2019 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519168;
        bh=sRaGSy+8FdAqGaH6XBe/JTP4pm6si35gdWrw7STTI28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctKBsIcwAj/o5gL2+LVKeDK2hghtAG2kV9aUl/kkcFTVfJN8pJ6dcEQ9KCWlSE63r
         1PRbZTn6x0ciRsQp9NV8jSTGoYR8S14VS9f/p1lQ7AiwExW1zERHLJB1DzTRgT34a2
         bev6kcSNKCe/cIbTh5qzvSlzehEAqURx8ifiK4DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.14 222/267] pinctrl: samsung: Fix device node refcount leaks in init code
Date:   Mon, 16 Dec 2019 18:49:08 +0100
Message-Id: <20191216174914.720020696@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit a322b3377f4bac32aa25fb1acb9e7afbbbbd0137 upstream.

Several functions use for_each_child_of_node() loop with a break to find
a matching child node.  Although each iteration of
for_each_child_of_node puts the previous node, but early exit from loop
misses it.  This leads to leak of device node.

Cc: <stable@vger.kernel.org>
Fixes: 9a2c1c3b91aa ("pinctrl: samsung: Allow grouping multiple pinmux/pinconf nodes")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/samsung/pinctrl-samsung.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -277,6 +277,7 @@ static int samsung_dt_node_to_map(struct
 						&reserved_maps, num_maps);
 		if (ret < 0) {
 			samsung_dt_free_map(pctldev, *map, *num_maps);
+			of_node_put(np);
 			return ret;
 		}
 	}
@@ -761,8 +762,10 @@ static struct samsung_pmx_func *samsung_
 		if (!of_get_child_count(cfg_np)) {
 			ret = samsung_pinctrl_create_function(dev, drvdata,
 							cfg_np, func);
-			if (ret < 0)
+			if (ret < 0) {
+				of_node_put(cfg_np);
 				return ERR_PTR(ret);
+			}
 			if (ret > 0) {
 				++func;
 				++func_cnt;
@@ -773,8 +776,11 @@ static struct samsung_pmx_func *samsung_
 		for_each_child_of_node(cfg_np, func_np) {
 			ret = samsung_pinctrl_create_function(dev, drvdata,
 						func_np, func);
-			if (ret < 0)
+			if (ret < 0) {
+				of_node_put(func_np);
+				of_node_put(cfg_np);
 				return ERR_PTR(ret);
+			}
 			if (ret > 0) {
 				++func;
 				++func_cnt;


