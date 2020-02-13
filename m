Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3C815C404
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387544AbgBMP0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:26:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbgBMP0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:24 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0FB3218AC;
        Thu, 13 Feb 2020 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607583;
        bh=hRlaiae+LHcqpEiZBOy957XW27EElO9+sS3jj35jKbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/9oqtweMlDM9T6SIrWzVuJKhDg9YcHr2E3rHHXUBwXPnhhvCjQdB+5GoK82UaLFK
         Rtctn74menLmTeTRK9byX/5Uosi2lOi20kGlYVhEtg80w9LaHzlimmLoYV7rYV8XA4
         7naW1kEhrC7QAGxOEHAE9OT6dlVKetbVhXmnH2qQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Meyer <dmeyer@gigaio.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.19 10/52] PCI/switchtec: Fix vep_vector_number ioread width
Date:   Thu, 13 Feb 2020 07:20:51 -0800
Message-Id: <20200213151815.169868961@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

commit 9375646b4cf03aee81bc6c305aa18cc80b682796 upstream.

vep_vector_number is actually a 16 bit register which should be read with
ioread16() instead of ioread32().

Fixes: 080b47def5e5 ("MicroSemi Switchtec management interface driver")
Link: https://lore.kernel.org/r/20200106190337.2428-3-logang@deltatee.com
Reported-by: Doug Meyer <dmeyer@gigaio.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/switch/switchtec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1186,7 +1186,7 @@ static int switchtec_init_isr(struct swi
 	if (nvecs < 0)
 		return nvecs;
 
-	event_irq = ioread32(&stdev->mmio_part_cfg->vep_vector_number);
+	event_irq = ioread16(&stdev->mmio_part_cfg->vep_vector_number);
 	if (event_irq < 0 || event_irq >= nvecs)
 		return -EFAULT;
 


