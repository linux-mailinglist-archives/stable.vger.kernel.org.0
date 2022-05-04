Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF7751A727
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354740AbiEDRCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354576AbiEDQ6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:58:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C3118E15;
        Wed,  4 May 2022 09:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 235846179D;
        Wed,  4 May 2022 16:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0E0C385A5;
        Wed,  4 May 2022 16:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683033;
        bh=4QKeYGFyuX8Lgug/SAeFGpeUU2oQDWxhq6HgOSzsGzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ywhw2qVCWH5wgKBbCfSKMQ49uUqN1RMZ0abChdN5RR7/HYvqI5+1QMtu7im103BMW
         NwWyhSprPCUWAnbBpQkMjmndCDENiBl/t3MUpnxOa9TlbKMIYBVP/fkb+d+KPwh9dW
         j454z9eAxN54U2fkr/XHmW3GiVOUfG43hwdAbJP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 024/129] usb: dwc3: core: Only handle soft-reset in DCTL
Date:   Wed,  4 May 2022 18:43:36 +0200
Message-Id: <20220504153023.199211062@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit f4fd84ae0765a80494b28c43b756a95100351a94 upstream.

Make sure not to set run_stop bit or link state change request while
initiating soft-reset. Register read-modify-write operation may
unintentionally start the controller before the initialization completes
with its previous DCTL value, which can cause initialization failure.

Fixes: f59dcab17629 ("usb: dwc3: core: improve reset sequence")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/6aecbd78328f102003d40ccf18ceeebd411d3703.1650594792.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -275,7 +275,8 @@ static int dwc3_core_soft_reset(struct d
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg |= DWC3_DCTL_CSFTRST;
-	dwc3_writel(dwc->regs, DWC3_DCTL, reg);
+	reg &= ~DWC3_DCTL_RUN_STOP;
+	dwc3_gadget_dctl_write_safe(dwc, reg);
 
 	/*
 	 * For DWC_usb31 controller 1.90a and later, the DCTL.CSFRST bit


