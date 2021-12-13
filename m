Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7074726CF
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238868AbhLMJyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:43130 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238167AbhLMJwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:52:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68CA3CE0AE2;
        Mon, 13 Dec 2021 09:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133E1C00446;
        Mon, 13 Dec 2021 09:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389159;
        bh=gYagyYNesN1+azpI4k5Dvmoq4mI/SFcMSxDVU8e70us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6TPExUy5rXIUyWCwapuQD46kY3pHdoOh7I4nxp1UUIoxx1WQtdJ645wZTFW0rM3d
         +DvRsYVGkRNBH9ATtfplhu5wduTChevd3cYQ+wc9q58/EUMhVPRoBmmfJ10kcOEfyz
         ZX/FtsRvaBtFmqTwpHE0B+xoNDEKxXK0YIwjmm40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 123/132] irqchip/armada-370-xp: Fix return value of armada_370_xp_msi_alloc()
Date:   Mon, 13 Dec 2021 10:31:04 +0100
Message-Id: <20211213092943.319972884@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit ce20eff57361e72878a772ef08b5239d3ae102b6 upstream.

IRQ domain alloc function should return zero on success. Non-zero value
indicates failure.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: fcc392d501bd ("irqchip/armada-370-xp: Use the generic MSI infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211125130057.26705-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-armada-370-xp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -250,7 +250,7 @@ static int armada_370_xp_msi_alloc(struc
 				    NULL, NULL);
 	}
 
-	return hwirq;
+	return 0;
 }
 
 static void armada_370_xp_msi_free(struct irq_domain *domain,


