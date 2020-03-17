Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85835187FC0
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgCQLET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728262AbgCQLER (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F03FB20658;
        Tue, 17 Mar 2020 11:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443057;
        bh=y+OaqMIx5L66GMyJ/vStR04kTYrrZ6vXz6F2UkjolYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eB6zL8EOsCg1XIdbbYIsXxuCu2v3Mne/eO0LLJX81Tv3/5v3py7R3HrIa1S60/e6a
         wOy/E+XGUhNJSX7c3QEUxXxYIyk3m1q1ZmGTB/dEQ5Yk6pWnPBP8XZEdzSaLn0SbfT
         iG8I0lsdy2aKzSPYafqyyLilj0d6yEM5G0Dj1KZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Donnelly <john.p.donnelly@oracle.com>,
        Takashi Iwai <tiwai@suse.de>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Vo <patrick.vo@hpe.com>
Subject: [PATCH 5.4 082/123] ipmi_si: Avoid spurious errors for optional IRQs
Date:   Tue, 17 Mar 2020 11:55:09 +0100
Message-Id: <20200317103316.271137860@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 443d372d6a96cd94ad119e5c14bb4d63a536a7f6 upstream.

Although the IRQ assignment in ipmi_si driver is optional,
platform_get_irq() spews error messages unnecessarily:
  ipmi_si dmi-ipmi-si.0: IRQ index 0 not found

Fix this by switching to platform_get_irq_optional().

Cc: stable@vger.kernel.org # 5.4.x
Cc: John Donnelly <john.p.donnelly@oracle.com>
Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()")
Reported-and-tested-by: Patrick Vo <patrick.vo@hpe.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-Id: <20200205093146.1352-1-tiwai@suse.de>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ipmi/ipmi_si_platform.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/ipmi/ipmi_si_platform.c
+++ b/drivers/char/ipmi/ipmi_si_platform.c
@@ -194,7 +194,7 @@ static int platform_ipmi_probe(struct pl
 	else
 		io.slave_addr = slave_addr;
 
-	io.irq = platform_get_irq(pdev, 0);
+	io.irq = platform_get_irq_optional(pdev, 0);
 	if (io.irq > 0)
 		io.irq_setup = ipmi_std_irq_setup;
 	else
@@ -378,7 +378,7 @@ static int acpi_ipmi_probe(struct platfo
 		io.irq = tmp;
 		io.irq_setup = acpi_gpe_irq_setup;
 	} else {
-		int irq = platform_get_irq(pdev, 0);
+		int irq = platform_get_irq_optional(pdev, 0);
 
 		if (irq > 0) {
 			io.irq = irq;


