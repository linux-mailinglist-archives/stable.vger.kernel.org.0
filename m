Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E12F26B6EA
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgIPAOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:14:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgIOOYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:24:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E047A223FD;
        Tue, 15 Sep 2020 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179539;
        bh=Wzju0MNmk4uT0Etwf6tfu41QfktJDX7MnVC5L7cPnvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9/HIzcUyQEDB5eGf7ett6xMaFAgGeR2V7TJ3ssldW2mskg6QKYacjoJeph+EYK40
         HgU/tkYmKHXvRfqtbj7d+b/EkQJT5vgtVMy/1P9c1DkoJsNmjPPNbrGF6uP3oyBcd0
         uMHnA5taKfYWlfU8inZN1fS+nVUT6DnI2z4Dn+oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/132] scsi: megaraid_sas: Dont call disable_irq from process IRQ poll
Date:   Tue, 15 Sep 2020 16:12:02 +0200
Message-Id: <20200915140645.086410469@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit d2af39141eea34ef651961e885f49d96781a1016 ]

disable_irq() might sleep. Replace it with disable_irq_nosync() which is
sufficient as irq_poll_scheduled protects against concurrently running
complete_cmd_fusion() from megasas_irqpoll() and megasas_isr_fusion().

Link: https://lore.kernel.org/r/20200827165332.8432-1-thenzl@redhat.com
Fixes: a6ffd5bf681 scsi: megaraid_sas: Call disable_irq from process IRQ poll
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5bcef9769740b..5dcd7b9b72ced 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3738,7 +3738,7 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 	instance = irq_ctx->instance;
 
 	if (irq_ctx->irq_line_enable) {
-		disable_irq(irq_ctx->os_irq);
+		disable_irq_nosync(irq_ctx->os_irq);
 		irq_ctx->irq_line_enable = false;
 	}
 
-- 
2.25.1



