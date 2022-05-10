Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD08521775
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243012AbiEJNZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242913AbiEJNZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:25:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE11A22406F;
        Tue, 10 May 2022 06:18:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5924A615F8;
        Tue, 10 May 2022 13:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8B0C385C6;
        Tue, 10 May 2022 13:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188695;
        bh=eFPjMgElhDEszECLNXLR9KghKw55KcyONnperHZm5LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOTPSSSSWzbXJZ34Fir2MuSqxLVbr2JKD9FcKGZhPk6y0Freh7TsXQ8avZ3hVq2G3
         67MHC4IRzGtZ5PhEhvRwzNIcC/6gjtiyXepgIxnMUzl7lEpHafDM2DdoNoXrbxUQaT
         Zhrk8beZvXdofhZD0qKO7P3t4cPiM7a86AIiOzN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijayavardhan Vennapusa <vvreddy@codeaurora.org>,
        Dan Vacura <w36195@motorola.com>, stable <stable@kernel.org>
Subject: [PATCH 4.19 14/88] usb: gadget: configfs: clear deactivation flag in configfs_composite_unbind()
Date:   Tue, 10 May 2022 15:06:59 +0200
Message-Id: <20220510130734.162062350@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vijayavardhan Vennapusa <vvreddy@codeaurora.org>

commit bf95c4d4630c7a2c16e7b424fdea5177d9ce0864 upstream.

If any function like UVC is deactivating gadget as part of composition
switch which results in not calling pullup enablement, it is not getting
enabled after switch to new composition due to this deactivation flag
not cleared. This results in USB enumeration not happening after switch
to new USB composition. Hence clear deactivation flag inside gadget
structure in configfs_composite_unbind() before switch to new USB
composition.

Signed-off-by: Vijayavardhan Vennapusa <vvreddy@codeaurora.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220413211038.72797-1-w36195@motorola.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1412,6 +1412,8 @@ static void configfs_composite_unbind(st
 	usb_ep_autoconfig_reset(cdev->gadget);
 	spin_lock_irqsave(&gi->spinlock, flags);
 	cdev->gadget = NULL;
+	cdev->deactivations = 0;
+	gadget->deactivated = false;
 	set_gadget_data(gadget, NULL);
 	spin_unlock_irqrestore(&gi->spinlock, flags);
 }


