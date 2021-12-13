Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE7947247A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhLMJgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbhLMJfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:35:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0772C079797;
        Mon, 13 Dec 2021 01:35:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACAEAB80E27;
        Mon, 13 Dec 2021 09:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3619C341C8;
        Mon, 13 Dec 2021 09:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388130;
        bh=2IMzgIMowzucIvsdwyjXypp8UrunLEWBLFFfW48AABA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAK/qfc4qOI71bwmbxBE93/SzaTLCezNynwFIA6aeA76T6TrmDEMUoWVmtH1GI094
         93Fise3bgJMcgogGHtgcs6jerwiGgrIKs2btfLx0/Gf6ij2qBdymKj4S3sgr2orOwi
         hmKh5ZtBETorAIsxw5gEQWlWIWW/o4qWgQ7jqpIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.9 39/42] irqchip/armada-370-xp: Fix return value of armada_370_xp_msi_alloc()
Date:   Mon, 13 Dec 2021 10:30:21 +0100
Message-Id: <20211213092927.825611100@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
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
@@ -171,7 +171,7 @@ static int armada_370_xp_msi_alloc(struc
 				    NULL, NULL);
 	}
 
-	return hwirq;
+	return 0;
 }
 
 static void armada_370_xp_msi_free(struct irq_domain *domain,


