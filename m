Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D693D629B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhGZPgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234460AbhGZPgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E94760240;
        Mon, 26 Jul 2021 16:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316203;
        bh=JBLXfaWFQahX/JFVLSqUUhOimqBt8YlceMRnioF80oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=py2WcXHto3pSeGh9pz5hReAf/U35Zo31YXh/n5G9plk6eFVTTZxBC7ES9xoy2nUD2
         Ax4svr9fK29FJ+n04oZDnkauv9uLqfY5eWE2RKvzogL6ROsDykOvwWXarSJGZEPDdp
         67Qy1Dq3EnnRofBtwiHHNX0oinm/Qv5cBD4yPcBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoshitaka Ikeda <ikeda@nskint.co.jp>,
        Pratyush Yadav <p.yadav@ti.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.13 222/223] spi: spi-cadence-quadspi: Fix division by zero warning - try2
Date:   Mon, 26 Jul 2021 17:40:14 +0200
Message-Id: <20210726153853.444570566@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshitaka Ikeda <ikeda@nskint.co.jp>

commit 0e85ee897858b1c7a5de53f496d016899d9639c5 upstream.

Fix below division by zero warning:
- The reason for dividing by zero is because the dummy bus width is zero,
  but if the dummy n bytes is zero, it indicates that there is no data transfer,
  so we can just return zero without doing any calculations.

[    0.795337] Division by zero in kernel.
   :
[    0.834051] [<807fd40c>] (__div0) from [<804e1acc>] (Ldiv0+0x8/0x10)
[    0.839097] [<805f0710>] (cqspi_exec_mem_op) from [<805edb4c>] (spi_mem_exec_op+0x3b0/0x3f8)

Fixes: 7512eaf54190 ("spi: cadence-quadspi: Fix dummy cycle calculation when buswidth > 1")
Signed-off-by: Yoshitaka Ikeda <ikeda@nskint.co.jp>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/92eea403-9b21-2488-9cc1-664bee760c5e@nskint.co.jp
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -309,6 +309,9 @@ static unsigned int cqspi_calc_dummy(con
 {
 	unsigned int dummy_clk;
 
+	if (!op->dummy.nbytes)
+		return 0;
+
 	dummy_clk = op->dummy.nbytes * (8 / op->dummy.buswidth);
 	if (dtr)
 		dummy_clk /= 2;


