Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58924BE920
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352440AbiBUKEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:04:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353502AbiBUJ53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB748D;
        Mon, 21 Feb 2022 01:26:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B49B60F8C;
        Mon, 21 Feb 2022 09:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337A0C340E9;
        Mon, 21 Feb 2022 09:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435588;
        bh=42zi/zigIyIUQ1oqsPKN7CLx5IlCRHcYsWZ5A3UZKvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwxlS6l8PdgXLhcc7De8Y+jd5TpTkWUAz7INUaaKoR40P/6z2o/f3B0oDkCl54j7E
         iRmgcYO3EeEijY1UgnKWc2SySWAercv4qzGfb5lk47JvOwfGKfmqbip8QIFcDYJYL4
         LDwXDCtBvGY652G2X5IObxm7TGajO7N2Mxt0Pil0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.16 184/227] i2c: qcom-cci: dont put a device tree node before i2c_add_adapter()
Date:   Mon, 21 Feb 2022 09:50:03 +0100
Message-Id: <20220221084940.937091035@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

commit 02a4a69667a2ad32f3b52ca906f19628fbdd8a01 upstream.

There is a minor chance for a race, if a pointer to an i2c-bus subnode
is stored and then reused after releasing its reference, and it would
be sufficient to get one more reference under a loop over children
subnodes.

Fixes: e517526195de ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -558,7 +558,7 @@ static int cci_probe(struct platform_dev
 		cci->master[idx].adap.quirks = &cci->data->quirks;
 		cci->master[idx].adap.algo = &cci_algo;
 		cci->master[idx].adap.dev.parent = dev;
-		cci->master[idx].adap.dev.of_node = child;
+		cci->master[idx].adap.dev.of_node = of_node_get(child);
 		cci->master[idx].master = idx;
 		cci->master[idx].cci = cci;
 
@@ -643,8 +643,10 @@ static int cci_probe(struct platform_dev
 			continue;
 
 		ret = i2c_add_adapter(&cci->master[i].adap);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(cci->master[i].adap.dev.of_node);
 			goto error_i2c;
+		}
 	}
 
 	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
@@ -656,8 +658,10 @@ static int cci_probe(struct platform_dev
 
 error_i2c:
 	for (--i ; i >= 0; i--) {
-		if (cci->master[i].cci)
+		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
+			of_node_put(cci->master[i].adap.dev.of_node);
+		}
 	}
 error:
 	disable_irq(cci->irq);
@@ -673,8 +677,10 @@ static int cci_remove(struct platform_de
 	int i;
 
 	for (i = 0; i < cci->data->num_masters; i++) {
-		if (cci->master[i].cci)
+		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
+			of_node_put(cci->master[i].adap.dev.of_node);
+		}
 		cci_halt(cci, i);
 	}
 


