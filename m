Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB462615AED
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiKBDoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiKBDoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:44:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9E726CD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:44:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FE96B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C08C433C1;
        Wed,  2 Nov 2022 03:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360647;
        bh=WU9ukT8HbcXcDJwuBLa+/Uz00o+if7Q/xKF4SC+Hc2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuOfPWIEBKeqEatge2KIufpxDxae8/CmG7mFfjb9P69H9EyLk4yMBnLrMuw6vSsBV
         JrxqpeIBl8jhNEhpVrbkNEr0m8IEuPGtJc08gv0nQB9xX0BFyW3njN2yJUZJ83YmIJ
         gk5uif2du9Qlewm/7SQ/gHM5Mq+SABeKzBHTUArk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@kernel.org>
Subject: [PATCH 4.9 13/44] usb: bdc: change state when port disconnected
Date:   Wed,  2 Nov 2022 03:34:59 +0100
Message-Id: <20221102022049.510555383@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
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


