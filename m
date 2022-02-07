Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E698A4ABD89
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384232AbiBGLox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385249AbiBGLb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89438C02B647;
        Mon,  7 Feb 2022 03:29:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5398EB8111C;
        Mon,  7 Feb 2022 11:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91106C004E1;
        Mon,  7 Feb 2022 11:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233389;
        bh=Bhdf+S29ZevkiMeS0rzmUpQEcBMlLRTwt6TQNWmKMNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyUSsswwmfKojG0ORAIc8rB/6ufEi4M0wZKlcAxWgx57EAqX8VEqfIGBf0rQt4W3b
         ME5oIIfh98/SGLryW5sib4mZHQFgdApDM+sTyIG3UcxnAePSn1ZBLfnQ7wqkTePso6
         Re1sm56fR9kAkr6PesyTKCKIz2o8oP42hAvMNoRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.15 107/110] gpio: idt3243x: Fix an ignored error return from platform_get_irq()
Date:   Mon,  7 Feb 2022 12:07:20 +0100
Message-Id: <20220207103806.015849410@linuxfoundation.org>
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

commit 7c1cf55577782725ea2bc24687767c8fe8e57486 upstream.

The return from the call to platform_get_irq() is int, it can be
a negative error code, however this is being assigned to an unsigned
int variable 'parent_irq', so making 'parent_irq' an int.

Eliminate the following coccicheck warning:
./drivers/gpio/gpio-idt3243x.c:167:6-16: WARNING: Unsigned expression
compared with zero: parent_irq < 0

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 30fee1d7462a ("gpio: idt3243x: Fix IRQ check in idt_gpio_probe")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-idt3243x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-idt3243x.c
+++ b/drivers/gpio/gpio-idt3243x.c
@@ -132,7 +132,7 @@ static int idt_gpio_probe(struct platfor
 	struct device *dev = &pdev->dev;
 	struct gpio_irq_chip *girq;
 	struct idt_gpio_ctrl *ctrl;
-	unsigned int parent_irq;
+	int parent_irq;
 	int ngpios;
 	int ret;
 


