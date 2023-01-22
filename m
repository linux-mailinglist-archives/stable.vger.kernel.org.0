Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B11676ED5
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjAVPOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjAVPOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:14:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F7E22030
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 970F0B80B0E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D81C433D2;
        Sun, 22 Jan 2023 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400490;
        bh=0FUf1dIc8oh/2qDlnkgUNM79R0enuTmGaXIF2er8DJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5a0kl9uezRZZvG+OeKhXof/RU5SnJpv8hd0FajBvAIuKkYOkAMGhg292XWqSEIhn
         ZxxeMqQURRBZMLo/2S6Nzry7MBI9JuP16AAfvfjHyg7ajoks0+bpaoKfuRXapeeFFJ
         gfK64x/0m3bcMEn8V0LIZkwPLcPqJMYy2am/LqaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 95/98] soc: qcom: apr: Make qcom,protection-domain optional again
Date:   Sun, 22 Jan 2023 16:04:51 +0100
Message-Id: <20230122150233.412197094@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit 599d41fb8ea8bd2a99ca9525dd69405020e43dda upstream.

APR should not fail if the service device tree node does not have
the qcom,protection-domain property, since this functionality does
not exist on older platforms such as MSM8916 and MSM8996.

Ignore -EINVAL (returned when the property does not exist) to fix
a regression on 6.2-rc1 that prevents audio from working:

  qcom,apr remoteproc0:smd-edge.apr_audio_svc.-1.-1:
    Failed to read second value of qcom,protection-domain
  qcom,apr remoteproc0:smd-edge.apr_audio_svc.-1.-1:
    Failed to add apr 3 svc

Fixes: 6d7860f5750d ("soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221229151648.19839-3-stephan@gerhold.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/apr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -319,9 +319,10 @@ static int apr_add_device(struct device
 		goto out;
 	}
 
+	/* Protection domain is optional, it does not exist on older platforms */
 	ret = of_property_read_string_index(np, "qcom,protection-domain",
 					    1, &adev->service_path);
-	if (ret < 0) {
+	if (ret < 0 && ret != -EINVAL) {
 		dev_err(dev, "Failed to read second value of qcom,protection-domain\n");
 		goto out;
 	}


