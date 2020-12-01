Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8209D2C9CF4
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388873AbgLAJGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388866AbgLAJGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DEFB20809;
        Tue,  1 Dec 2020 09:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813572;
        bh=PGMjPs3kovMg+0Qndby3acphdD/4Zb9vuLi9PMjCAew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/p84YYlnxi0T/QHmv196MgDfegUs6KZTSNlX+VekAMICFs3c8XVy4qEXa8eJ3rZa
         xizO/D4xQuIxmOPERHdBKVVb6ObGF75r5aAB7tsEZ3hnnCvZT7HHzEtHQ8SADJiCxt
         XcrXijda+9kvGsLVJSMt+pL8OF10FwgApV2F/2n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Baozi <chenbaozi@phytium.com.cn>,
        Marc Zyngier <maz@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.4 85/98] irqchip/exiu: Fix the index of fwspec for IRQ type
Date:   Tue,  1 Dec 2020 09:54:02 +0100
Message-Id: <20201201084659.214027436@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Baozi <chenbaozi@phytium.com.cn>

commit d001e41e1b15716e9b759df5ef00510699f85282 upstream.

Since fwspec->param_count of ACPI node is two, the index of IRQ type
in fwspec->param[] should be 1 rather than 2.

Fixes: 3d090a36c8c8 ("irqchip/exiu: Implement ACPI support")
Signed-off-by: Chen Baozi <chenbaozi@phytium.com.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20201117032015.11805-1-cbz@baozis.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-sni-exiu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-sni-exiu.c
+++ b/drivers/irqchip/irq-sni-exiu.c
@@ -136,7 +136,7 @@ static int exiu_domain_translate(struct
 		if (fwspec->param_count != 2)
 			return -EINVAL;
 		*hwirq = fwspec->param[0];
-		*type = fwspec->param[2] & IRQ_TYPE_SENSE_MASK;
+		*type = fwspec->param[1] & IRQ_TYPE_SENSE_MASK;
 	}
 	return 0;
 }


