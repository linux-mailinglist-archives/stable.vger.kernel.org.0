Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7E8561BAD
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbiF3NsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbiF3NsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:48:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504B72FE58;
        Thu, 30 Jun 2022 06:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D869961FF6;
        Thu, 30 Jun 2022 13:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B15C34115;
        Thu, 30 Jun 2022 13:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596873;
        bh=H1bSBWVGZV+5s+ZnLeAHu/3Oh13Lb4XGnzywVcrTRGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrVaP03gZJbAyPhYUiIQes732k4BHogb7QAY/xEXd4MqwYZWkssXszHqPwD2DcWDA
         pFgqUZBJ5iAERlkFf/PErjb8+SBkcqSm6gdkUa5h7glOniLZr0meMGkywzNn4dG+DV
         I2eUu5GzROI9c46ddkhZJ2AJzNn+9ObyAS41dlRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 4.9 12/29] usb: chipidea: udc: check request status before setting device address
Date:   Thu, 30 Jun 2022 15:46:12 +0200
Message-Id: <20220630133231.566016004@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yang <xu.yang_2@nxp.com>

commit b24346a240b36cfc4df194d145463874985aa29b upstream.

The complete() function may be called even though request is not
completed. In this case, it's necessary to check request status so
as not to set device address wrongly.

Fixes: 10775eb17bee ("usb: chipidea: udc: update gadget states according to ch9")
cc: <stable@vger.kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20220623030242.41796-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/udc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -921,6 +921,9 @@ isr_setup_status_complete(struct usb_ep
 	struct ci_hdrc *ci = req->context;
 	unsigned long flags;
 
+	if (req->status < 0)
+		return;
+
 	if (ci->setaddr) {
 		hw_usb_set_address(ci, ci->address);
 		ci->setaddr = false;


