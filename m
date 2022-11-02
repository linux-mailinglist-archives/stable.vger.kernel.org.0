Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E94615AB2
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiKBDjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiKBDjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:39:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A44111E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F390561729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B29FC433D6;
        Wed,  2 Nov 2022 03:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360344;
        bh=WU9ukT8HbcXcDJwuBLa+/Uz00o+if7Q/xKF4SC+Hc2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xl53MGEi6T2yTG6JkgxyAfDFtsTV5/lfHvjBorZ/+HeFZH1q7w5ScF+YCBKgeLQZa
         tWtNiUB5XI3wV1dXrgApUqNBdHIouhA5+EHpRtnZQpVUVtXwNSmYBI6zgdrNtaEyUT
         ws6jpy7lF7WlA20L7pYzCZQ0HfHyF044hlTxmByI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@kernel.org>
Subject: [PATCH 4.14 21/60] usb: bdc: change state when port disconnected
Date:   Wed,  2 Nov 2022 03:34:42 +0100
Message-Id: <20221102022051.774898869@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

commit fb8f60dd1b67520e0e0d7978ef17d015690acfc1 upstream.

When port is connected and then disconnected, the state stays as
configured. Which is incorrect as the port is no longer configured,
but in a not attached state.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: efed421a94e6 ("usb: gadget: Add UDC driver for Broadcom USB3.0 device controller IP BDC")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/1664997235-18198-1-git-send-email-justinpopo6@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/bdc/bdc_udc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/bdc/bdc_udc.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_udc.c
@@ -156,6 +156,7 @@ static void bdc_uspc_disconnected(struct
 	bdc->delayed_status = false;
 	bdc->reinit = reinit;
 	bdc->test_mode = false;
+	usb_gadget_set_state(&bdc->gadget, USB_STATE_NOTATTACHED);
 }
 
 /* TNotify wkaeup timer */


