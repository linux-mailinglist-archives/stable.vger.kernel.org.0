Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56EC3157848
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgBJMjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728958AbgBJMjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:52 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123B62467A;
        Mon, 10 Feb 2020 12:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338390;
        bh=c18dsmejcPXvDGKtlQTp7E0bFEvu+bOeNIWByPWdY5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbaW2vB2lwiMbt4Ce2tQz88zt9fFKHj8ohesrcqYdC1XeftaZDbZ0HpH4/Wsq98hd
         LWc+tCSks0OU4ecguK0UYEukHdgKelhfqGy8ln30RbmgndEVVWUn9erjqHmMvGExc2
         VZSYh8KVRO8A3UeyHhREHhntxftgcA4c9H38gX5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH 5.5 080/367] MIPS: SGI-IP30: Check for valid pointer before using it
Date:   Mon, 10 Feb 2020 04:29:53 -0800
Message-Id: <20200210122431.680229459@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

commit c0e79fd89749b0cda1c72049e2772dd2eeada86f upstream.

Fix issue detected by Smatch:

    ./arch/mips/sgi-ip30/ip30-irq.c:236 heart_domain_free()
     warn: variable dereferenced before check 'irqd' (see line 235)

Fixes: 7505576d1c1a ("MIPS: add support for SGI Octane (IP30)")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/sgi-ip30/ip30-irq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/mips/sgi-ip30/ip30-irq.c
+++ b/arch/mips/sgi-ip30/ip30-irq.c
@@ -232,9 +232,10 @@ static void heart_domain_free(struct irq
 		return;
 
 	irqd = irq_domain_get_irq_data(domain, virq);
-	clear_bit(irqd->hwirq, heart_irq_map);
-	if (irqd && irqd->chip_data)
+	if (irqd) {
+		clear_bit(irqd->hwirq, heart_irq_map);
 		kfree(irqd->chip_data);
+	}
 }
 
 static const struct irq_domain_ops heart_domain_ops = {


