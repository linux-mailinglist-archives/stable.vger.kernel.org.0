Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DFB5519F9
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243762AbiFTNEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244553AbiFTNDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:03:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA041E3DB;
        Mon, 20 Jun 2022 05:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7AB061449;
        Mon, 20 Jun 2022 12:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C508EC341C6;
        Mon, 20 Jun 2022 12:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729890;
        bh=KJ2SapzxlRMwj2wOaVCg3xVM4XQkTl/+A3xCbWmz0Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwq3XoJsTtp50Jks7sEpSIi/toPXX7nGAUAiNuyAAsOP3jUp1TSmktnyDZAfRGRFQ
         gwL5V/eDfCrlfyEZdy5mqNJpj10m5aldQgqlZSqrF4i7EzJ5WtxM0J0jS5LTpkETFt
         ijYG5DoavehZLo2jZ2SW/ucOxbsY1Tlj3cB7qR5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 5.18 107/141] usb: dwc2: Fix memory leak in dwc2_hcd_init
Date:   Mon, 20 Jun 2022 14:50:45 +0200
Message-Id: <20220620124732.706983940@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 3755278f078460b021cd0384562977bf2039a57a upstream.

usb_create_hcd will alloc memory for hcd, and we should
call usb_put_hcd to free it when platform_get_resource()
fails to prevent memory leak.
goto error2 label instead error1 to fix this.

Fixes: 856e6e8e0f93 ("usb: dwc2: check return value after calling platform_get_resource()")
Cc: stable <stable@kernel.org>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220530085413.44068-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5190,7 +5190,7 @@ int dwc2_hcd_init(struct dwc2_hsotg *hso
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		retval = -EINVAL;
-		goto error1;
+		goto error2;
 	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);


