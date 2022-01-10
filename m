Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8FC489259
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240457AbiAJHmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239977AbiAJHio (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:38:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B350C0258D2;
        Sun,  9 Jan 2022 23:33:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D05B60BA2;
        Mon, 10 Jan 2022 07:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23443C36AE9;
        Mon, 10 Jan 2022 07:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800000;
        bh=+jzjg/PzAo7Yfk7QGyIdftfXX9dnjhS3pvZKkENn7Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssewCUj1vLt8xr58l7KE3sGie/50pIZFCSwvbYf8sZuHETvRb6EDRj7qjeAQ0Fa3d
         systYTqfGF5Npu0dv9n5R3XHi1QeZ4RpQafdYMkjJD9iTs7d2E0EdOe+kx0eH/S+Io
         4KyZ46EFb1lifXG9J1aPaFK4RDRP4fDU+IRgz4EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Lee <steven_lee@aspeedtech.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.15 45/72] gpio: gpio-aspeed-sgpio: Fix wrong hwirq base in irq handler
Date:   Mon, 10 Jan 2022 08:23:22 +0100
Message-Id: <20220110071823.079201751@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Lee <steven_lee@aspeedtech.com>

commit e5a7431f5a2d6dcff7d516ee9d178a3254b17b87 upstream.

Each aspeed sgpio bank has 64 gpio pins(32 input pins and 32 output pins).
The hwirq base for each sgpio bank should be multiples of 64 rather than
multiples of 32.

Signed-off-by: Steven Lee <steven_lee@aspeedtech.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-aspeed-sgpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-aspeed-sgpio.c
+++ b/drivers/gpio/gpio-aspeed-sgpio.c
@@ -395,7 +395,7 @@ static void aspeed_sgpio_irq_handler(str
 		reg = ioread32(bank_reg(data, bank, reg_irq_status));
 
 		for_each_set_bit(p, &reg, 32)
-			generic_handle_domain_irq(gc->irq.domain, i * 32 + p * 2);
+			generic_handle_domain_irq(gc->irq.domain, (i * 32 + p) * 2);
 	}
 
 	chained_irq_exit(ic, desc);


