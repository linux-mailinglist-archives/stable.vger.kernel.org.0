Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5003226B599
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgIOXrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbgIOOdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B38923BEF;
        Tue, 15 Sep 2020 14:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179906;
        bh=JsbqIvjQPkIS7vbY9pJ5xV8+gAdEwSWQ7PKe6NpGvQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AE8fqKZNelJp2jwi+WpW398z+jKngKD8uVYioB//TjDznIcV+FxjEc7BvbjXCkjp8
         FNhnp2gx9NsQNvXGcPiZs4oge6LLgKZ3yS1qi9QyUbJM7VuUKNE9i0Dcs2se2NCT8c
         0h/9FOmV4CJkadJ1b4JLckd/peO1z7t39zJ3Q+E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 032/177] scsi: megaraid_sas: Dont call disable_irq from process IRQ poll
Date:   Tue, 15 Sep 2020 16:11:43 +0200
Message-Id: <20200915140655.180282567@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
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
index fcf03f733e417..1a0e2e4342ad8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3690,7 +3690,7 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 	instance = irq_ctx->instance;
 
 	if (irq_ctx->irq_line_enable) {
-		disable_irq(irq_ctx->os_irq);
+		disable_irq_nosync(irq_ctx->os_irq);
 		irq_ctx->irq_line_enable = false;
 	}
 
-- 
2.25.1



