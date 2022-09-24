Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCF35E8CB8
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiIXMw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIXMw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:52:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0A7109779
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 05:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D2853CE0B49
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 12:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D6EC433C1;
        Sat, 24 Sep 2022 12:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664023972;
        bh=4a2SmALZbLCSILgbaQE0MUpPHfh9xXie7ER5P2pUjbs=;
        h=Subject:To:From:Date:From;
        b=XhB4Psr0E/cIyADal3olp6JW7uwqwpSVyjD5avJOds4wsEexAE/mouah3qc5tBKqF
         jRWC9n49L5fuwUm+P7joKNcY5gXqq6elZE2bgxtDUmqWSSZCCrkAhZ7XGaJ1bpT74g
         CBvvkAEKyXRpM9pO2SqfBaLYGkeWy1tfHSSkpRFc=
Subject: patch "slimbus: qcom-ngd: use correct error in message of pdr_add_lookup()" added to char-misc-testing
To:     krzysztof.kozlowski@linaro.org, gregkh@linuxfoundation.org,
        srinivas.kandagatla@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Sep 2022 14:52:49 +0200
Message-ID: <166402396919793@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    slimbus: qcom-ngd: use correct error in message of pdr_add_lookup()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 5038d21dde818fe74ba1fcb6f2cee35b8c2ebbf2 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Fri, 16 Sep 2022 13:29:07 +0100
Subject: slimbus: qcom-ngd: use correct error in message of pdr_add_lookup()
 failure

Use correct error code, instead of previous 'ret' value, when printing
error from pdr_add_lookup() failure.

Fixes: e1ae85e1830e ("slimbus: qcom-ngd-ctrl: add Protection Domain Restart Support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220916122910.170730-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 0aa8408464ad..f4f330b9fa72 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1581,8 +1581,9 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 
 	pds = pdr_add_lookup(ctrl->pdr, "avs/audio", "msm/adsp/audio_pd");
 	if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
+		ret = PTR_ERR(pds);
 		dev_err(dev, "pdr add lookup failed: %d\n", ret);
-		return PTR_ERR(pds);
+		return ret;
 	}
 
 	platform_driver_register(&qcom_slim_ngd_driver);
-- 
2.37.3


