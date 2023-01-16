Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DED66C87F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbjAPQjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbjAPQjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:39:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5588F74D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:27:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F83F61058
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76654C433F0;
        Mon, 16 Jan 2023 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886477;
        bh=wiMRYrwCjihogfOJ8kN8+MjKHhiMLI6OOtGx8lIQc6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6XhIOsXmVfHE63UQ+dHYRdBdoze0CEvo7BsYbR09OtNq1r/q5nuO9aUPA9SwAima
         TAvoJSoRC8yRmj3VTGMguZ04i/kEh9DsL4sgi4S/UqruIle20bxCCqMgFuu48QIH9h
         EcqKvon2aoBvZNsM1OyrBHgM0s2YirNHoulgCL/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH 5.4 444/658] usb: dwc3: core: defer probe on ulpi_read_id timeout
Date:   Mon, 16 Jan 2023 16:48:52 +0100
Message-Id: <20230116154929.828585892@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
@@ -931,8 +931,13 @@ static int dwc3_core_init(struct dwc3 *d
 
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
 


