Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB8B667706
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239494AbjALOjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239173AbjALOiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:38:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811B25791C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EC4462031
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5FBC433EF;
        Thu, 12 Jan 2023 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533691;
        bh=vS3bJMolAcBL70DDI3T81pJRGP/GrbYN7aUvLJWiWJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzWOdZf8pfIyfR7CUvrGBZUeiPpaS6dEfk1RGIpt5Mbls285HfQCRvTtwDokQSOyl
         49Aq8iCV7fh1E3FK2npIrhlBZRj44BghLhP9ir7XwBMLax3ZXt4+V7VKSwqZulAtki
         8n/yQAgEuqMFzWwN3/Q9nfAQ0sB3hwPrF4wuYbpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH 5.10 560/783] usb: dwc3: core: defer probe on ulpi_read_id timeout
Date:   Thu, 12 Jan 2023 14:54:36 +0100
Message-Id: <20230112135550.216081562@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ferry Toth <ftoth@exalondelft.nl>

commit 63130462c919ece0ad0d9bb5a1f795ef8d79687e upstream.

Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
if extcon is present"), Dual Role support on Intel Merrifield platform
broke due to rearranging the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() masking the timeout on the first
test write. In the past dwc3 probe continued by calling dwc3_core_soft_reset()
followed by dwc3_get_extcon() which happend to return -EPROBE_DEFER.
On deferred probe ulpi_read_id() finally succeeded. Due to above mentioned
rearranging -EPROBE_DEFER is not returned and probe completes without phy.

On Intel Merrifield the timeout on the first test write issue is reproducible
but it is difficult to find the root cause. Using a mainline kernel and
rootfs with buildroot ulpi_read_id() succeeds. As soon as adding
ftrace / bootconfig to find out why, ulpi_read_id() fails and we can't
analyze the flow. Using another rootfs ulpi_read_id() fails even without
adding ftrace. We suspect the issue is some kind of timing / race, but
merely retrying ulpi_read_id() does not resolve the issue.

As we now changed ulpi_read_id() to return -ETIMEDOUT in this case, we
need to handle the error by calling dwc3_core_soft_reset() and request
-EPROBE_DEFER. On deferred probe ulpi_read_id() is retried and succeeds.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable@vger.kernel.org
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Link: https://lore.kernel.org/r/20221205201527.13525-3-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -960,8 +960,13 @@ static int dwc3_core_init(struct dwc3 *d
 
 	if (!dwc->ulpi_ready) {
 		ret = dwc3_core_ulpi_init(dwc);
-		if (ret)
+		if (ret) {
+			if (ret == -ETIMEDOUT) {
+				dwc3_core_soft_reset(dwc);
+				ret = -EPROBE_DEFER;
+			}
 			goto err0;
+		}
 		dwc->ulpi_ready = true;
 	}
 


