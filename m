Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC32B1AC3B4
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898382AbgDPNrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731775AbgDPNrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:47:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0E1421734;
        Thu, 16 Apr 2020 13:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044821;
        bh=sPrl9R+yoAc0NrziY7jtHcAjfyMMgN98O+1GI2m295k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+DgOhhr3Exwl6nHvj4YzSCfjKOwN6Xgivw7Qp8xkcVuAI5QIeg1J6PhiNR/m9uet
         nDKYOnwpiasdBJ2Fkz49oT1TExwOstyFzrfQxdjjftiZkR6raBqL7zFIz8cNR/OuYL
         fNNTur4YTntU54tBFdXGImYngbGL7qBR6acnVZkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 115/232] MIPS: OCTEON: irq: Fix potential NULL pointer dereference
Date:   Thu, 16 Apr 2020 15:23:29 +0200
Message-Id: <20200416131329.509258625@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 792a402c2840054533ef56279c212ef6da87d811 upstream.

There is a potential NULL pointer dereference in case kzalloc()
fails and returns NULL.

Fix this by adding a NULL check on *cd*

This bug was detected with the help of Coccinelle.

Fixes: 64b139f97c01 ("MIPS: OCTEON: irq: add CIB and other fixes")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/cavium-octeon/octeon-irq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -2199,6 +2199,9 @@ static int octeon_irq_cib_map(struct irq
 	}
 
 	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
+	if (!cd)
+		return -ENOMEM;
+
 	cd->host_data = host_data;
 	cd->bit = hw;
 


