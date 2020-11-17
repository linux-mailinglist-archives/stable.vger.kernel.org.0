Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F292B626B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbgKQN20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730893AbgKQN2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:28:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29CF72168B;
        Tue, 17 Nov 2020 13:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619705;
        bh=4xqtMbNtomAV5AV4pXEjKfbYcKyIPsbf3GnbHYbKyOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QW0+omr4MkNLsyR2utaqJLjkm+MkCp9LjKUqwuutQpe7c334dSQHW2S97NsvQD5XS
         IxJltvNUmTgc4GOh2dErGJkpmwJU2NqCTa1GsT/qPp1nbl1uRuojzYbNXvpTLC0tKx
         BGAO/eFKPdqbZNrVibsn0VEmUCwbOzE5SwpuuXTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaud de Turckheim <quarium@gmail.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 128/151] gpio: pcie-idio-24: Fix irq mask when masking
Date:   Tue, 17 Nov 2020 14:05:58 +0100
Message-Id: <20201117122127.652559069@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud de Turckheim <quarium@gmail.com>

commit d8f270efeac850c569c305dc0baa42ac3d607988 upstream.

Fix the bitwise operation to remove only the corresponding bit from the
mask.

Fixes: 585562046628 ("gpio: Add GPIO support for the ACCES PCIe-IDIO-24 family")
Cc: stable@vger.kernel.org
Signed-off-by: Arnaud de Turckheim <quarium@gmail.com>
Reviewed-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-pcie-idio-24.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-pcie-idio-24.c
+++ b/drivers/gpio/gpio-pcie-idio-24.c
@@ -365,7 +365,7 @@ static void idio_24_irq_mask(struct irq_
 
 	raw_spin_lock_irqsave(&idio24gpio->lock, flags);
 
-	idio24gpio->irq_mask &= BIT(bit_offset);
+	idio24gpio->irq_mask &= ~BIT(bit_offset);
 	new_irq_mask = idio24gpio->irq_mask >> bank_offset;
 
 	if (!new_irq_mask) {


