Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149B960FDA5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiJ0Q5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiJ0Q53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:57:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536C510EE59
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6D82623ED
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A70C433D6;
        Thu, 27 Oct 2022 16:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889848;
        bh=ei+uedMaTOIPuxjpu6diHqgY1TRnnG9bfnjO2qXCiQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwj2M5GoV7DdlGcJuuw9JgyvBz3A8WwNRWbVj++yVMW6oOzcxR1OFKw3Yu1n7/rnd
         380iUhW4Jaw3hCKCtCopR0r7VZLzX99B/Gw77a+0yThNxZMoIB5nArRNLcjWWiVfVi
         zNsiERP/jIsnDwMP4VXnwDnd4Yy9VyydB/25NYlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.0 22/94] media: mceusb: set timeout to at least timeout provided
Date:   Thu, 27 Oct 2022 18:54:24 +0200
Message-Id: <20221027165057.947189795@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 20b794ddce475ed012deb365000527c17b3e93e6 upstream.

By rounding down, the actual timeout can be lower than requested. As a
result, long spaces just below the requested timeout can be incorrectly
reported as timeout and truncated.

Fixes: 877f1a7cee3f ("media: rc: mceusb: allow the timeout to be configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/mceusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1077,7 +1077,7 @@ static int mceusb_set_timeout(struct rc_
 	struct mceusb_dev *ir = dev->priv;
 	unsigned int units;
 
-	units = DIV_ROUND_CLOSEST(timeout, MCE_TIME_UNIT);
+	units = DIV_ROUND_UP(timeout, MCE_TIME_UNIT);
 
 	cmdbuf[2] = units >> 8;
 	cmdbuf[3] = units;


