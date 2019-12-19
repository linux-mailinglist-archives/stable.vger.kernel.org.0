Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED55126D24
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfLSSlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbfLSSlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:41:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609E124680;
        Thu, 19 Dec 2019 18:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780882;
        bh=AB+p3H+XIRVovI0BE08arTH7WbvtmV9U6TTbS0sF+04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TixPVddIPiOwYZoak/4Dl1TQYoWmisHvX5PulLEueZZQpfj3rDl8cGbD/JcY6YPmX
         fmQK0UQ59+hETK/vYSFXmxbUP4KvtujOb0KtMikA8HBP0sbsNyaj6ruh61k284oSqK
         yaH08Z249uexi3Ck0F2U5JHqBVXLcidZzAnHIm4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.4 118/162] pinctrl: samsung: Fix device node refcount leaks in init code
Date:   Thu, 19 Dec 2019 19:33:46 +0100
Message-Id: <20191219183214.932860984@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
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
@@ -286,6 +286,7 @@ static int samsung_dt_node_to_map(struct
 						&reserved_maps, num_maps);
 		if (ret < 0) {
 			samsung_dt_free_map(pctldev, *map, *num_maps);
+			of_node_put(np);
 			return ret;
 		}
 	}
@@ -753,8 +754,10 @@ static struct samsung_pmx_func *samsung_
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
@@ -765,8 +768,11 @@ static struct samsung_pmx_func *samsung_
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


