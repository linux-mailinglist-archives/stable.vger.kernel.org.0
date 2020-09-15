Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420B326B41B
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgIOXPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FE7823CD5;
        Tue, 15 Sep 2020 14:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180182;
        bh=5ByAxX/YdOT8akkXcFk18IFfFU87sPRbguoVCM9/DuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKvhwr6xjQmD1dGFokIeWDMp7/L4Ief0i7WpUZOBo7NalVNlQS34WkzJeCYuNyfqJ
         QDKQIlL/oYkxN/KrCp2BiANuiP9aWELODWxAhFuIY7CwsZqC3rx1bcw7BSDqOqbUT+
         B7pPatYw2X8X++N3AMik1CwuRsXAHzc56AleHGKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.8 140/177] scsi: lpfc: Fix setting IRQ affinity with an empty CPU mask
Date:   Tue, 15 Sep 2020 16:13:31 +0200
Message-Id: <20200915140700.368250785@linuxfoundation.org>
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

From: James Smart <james.smart@broadcom.com>

commit 7ac836ebcb1509845fe7d66314f469f8e709da93 upstream.

Some systems are reporting the following log message during driver unload
or system shutdown:

  ics_rtas_set_affinity: No online cpus in the mask

A prior commit introduced the writing of an empty affinity mask in calls to
irq_set_affinity_hint() when disabling interrupts or when there are no
remaining online CPUs to service an eq interrupt. At least some ppc64
systems are checking whether affinity masks are empty or not.

Do not call irq_set_affinity_hint() with an empty CPU mask.

Fixes: dcaa21367938 ("scsi: lpfc: Change default IRQ model on AMD architectures")
Link: https://lore.kernel.org/r/20200828175332.130300-2-james.smart@broadcom.com
Cc: <stable@vger.kernel.org> # v5.5+
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_init.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11257,7 +11257,6 @@ lpfc_irq_clear_aff(struct lpfc_hba_eq_hd
 {
 	cpumask_clear(&eqhdl->aff_mask);
 	irq_clear_status_flags(eqhdl->irq, IRQ_NO_BALANCING);
-	irq_set_affinity_hint(eqhdl->irq, &eqhdl->aff_mask);
 }
 
 /**


