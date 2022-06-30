Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37483561C7B
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiF3N7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbiF3N6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:58:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D806C53D36;
        Thu, 30 Jun 2022 06:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D968E620EB;
        Thu, 30 Jun 2022 13:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED37DC34115;
        Thu, 30 Jun 2022 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597086;
        bh=X4C8Nbn+3JxKOi8FBo6DgrM0JJTGwD8hbxya2lR5OiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8mBcOY3amU8uKcyR33gWNo8v+IH9jFiaUh1NNrjgQ4d2v35MdCSgO/rpfHXy5qU7
         blLgZT/rUbfM23nKi1TlMkulkhDrkPni0KRgcD77UznE5b9q7RpKqMXDTI+XBlLxS7
         1ptXiAzVifdRiJvHrMFDD71A27iDn1r7FM+5cdOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 4.19 23/49] usb: chipidea: udc: check request status before setting device address
Date:   Thu, 30 Jun 2022 15:46:36 +0200
Message-Id: <20220630133234.584944571@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
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
@@ -920,6 +920,9 @@ isr_setup_status_complete(struct usb_ep
 	struct ci_hdrc *ci = req->context;
 	unsigned long flags;
 
+	if (req->status < 0)
+		return;
+
 	if (ci->setaddr) {
 		hw_usb_set_address(ci, ci->address);
 		ci->setaddr = false;


