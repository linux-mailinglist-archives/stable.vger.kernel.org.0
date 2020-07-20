Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63E7226681
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgGTQDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732435AbgGTQDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:03:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A03620684;
        Mon, 20 Jul 2020 16:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261026;
        bh=DsXJ9loA09c5M4jr0i1+ZN3kgn72HzGZDhvmiwfEleA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rshey7EhL/33V0qYn9XJbSGUBkaPwJKtHFFLQwKy6MvnzvZqs7zPqz8AXZEEKgO3N
         lmOfCvoUF5MAD8da1Yk5LnD139Xks5uyFUqwQkb3u//iPkBwrNZio69Dm5i6isjE6e
         fpbbXnjNUEs/UCxpR0HjseixtDljP7z+xoRwHnws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 182/215] scsi: megaraid_sas: Remove undefined ENABLE_IRQ_POLL macro
Date:   Mon, 20 Jul 2020 17:37:44 +0200
Message-Id: <20200720152828.829013937@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

commit 07d3f04550023395bbf34b99ec7e00fc50d9859f upstream.

As the ENABLE_IRQ_POLL macro is undefined, the check for ENABLE_IRQ_POLL
macro in ISR will always be false. This leads to irq polling being
non-functional.

Remove ENABLE_IRQ_POLL check from ISR.

Link: https://lore.kernel.org/r/20200715120153.20512-1-chandrakanth.patil@broadcom.com
Fixes: a6ffd5bf6819 ("scsi: megaraid_sas: Call disable_irq from process IRQ")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3787,10 +3787,8 @@ static irqreturn_t megasas_isr_fusion(in
 	if (instance->mask_interrupts)
 		return IRQ_NONE;
 
-#if defined(ENABLE_IRQ_POLL)
 	if (irq_context->irq_poll_scheduled)
 		return IRQ_HANDLED;
-#endif
 
 	if (!instance->msix_vectors) {
 		mfiStatus = instance->instancet->clear_intr(instance);


