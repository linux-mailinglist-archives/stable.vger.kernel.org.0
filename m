Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98B4ABD88
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381523AbiBGLos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385251AbiBGLb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83201C02B649;
        Mon,  7 Feb 2022 03:29:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F22260A67;
        Mon,  7 Feb 2022 11:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD6BC004E1;
        Mon,  7 Feb 2022 11:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233392;
        bh=/caNl0v9RwhFS+XEpOgKYAUioaM4gZ0FnbqNGD2i7JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPbmIcCckoN5STM/q3ddYOROfNOZ+9d9id1UgT6OJpxgItbmHInde+q2uaIJPDdGy
         MLENk41JJy/ME0ghQU8qxrxe3B8jgExgRfO2C3H2fl3cOaAHnKU5Ue/vdJNmNYisTb
         We1u/mMJ+GD96We+qi1ku3jLEOmwvthrvXF3q4P4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.15 108/110] gpio: mpc8xxx: Fix an ignored error return from platform_get_irq()
Date:   Mon,  7 Feb 2022 12:07:21 +0100
Message-Id: <20220207103806.050063963@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

commit 9f51ce0b9e73f83bab2442b36d5e247a81bd3401 upstream.

The return from the call to platform_get_irq() is int, it can be
a negative error code, however this is being assigned to an unsigned
int variable 'irqn', so making 'irqn' an int.

Eliminate the following coccicheck warning:
./drivers/gpio/gpio-mpc8xxx.c:391:5-21: WARNING: Unsigned expression
compared with zero: mpc8xxx_gc -> irqn < 0

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 0b39536cc699 ("gpio: mpc8xxx: Fix IRQ check in mpc8xxx_probe")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mpc8xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -47,7 +47,7 @@ struct mpc8xxx_gpio_chip {
 				unsigned offset, int value);
 
 	struct irq_domain *irq;
-	unsigned int irqn;
+	int irqn;
 };
 
 /*


