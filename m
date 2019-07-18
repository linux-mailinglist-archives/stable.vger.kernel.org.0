Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A41F6C682
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390881AbfGRDOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391769AbfGRDOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:14:23 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E35D42077C;
        Thu, 18 Jul 2019 03:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419662;
        bh=nK4AW3CIzRDcKNnOCyGAJX70zEbDY6+Z0KnJ/EY+JE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9bO3YNdVMSH+NDHfEi/xjW/GlqnbEcsx3ym0fX1/KliinFQOOkICsOUT8MYuck6X
         bl5m97qcQrH0UQWQRNS1W9I9gRCfudFdrCK7t4r6S8Xhbff40V8IRm8D3RY4037Cyo
         0Kw2lgP5PU+pdSBlD3uSt9puBmIKxa9RahYyXsXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.9 54/54] s390/qdio: dont touch the dsci in tiqdio_add_input_queues()
Date:   Thu, 18 Jul 2019 12:02:24 +0900
Message-Id: <20190718030053.829303690@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
References: <20190718030048.392549994@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

commit ac6639cd3db607d386616487902b4cc1850a7be5 upstream.

Current code sets the dsci to 0x00000080. Which doesn't make any sense,
as the indicator area is located in the _left-most_ byte.

Worse: if the dsci is the _shared_ indicator, this potentially clears
the indication of activity for a _different_ device.
tiqdio_thinint_handler() will then have no reason to call that device's
IRQ handler, and the device ends up stalling.

Fixes: d0c9d4a89fff ("[S390] qdio: set correct bit in dsci")
Cc: <stable@vger.kernel.org>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/cio/qdio_thinint.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -80,7 +80,6 @@ void tiqdio_add_input_queues(struct qdio
 	mutex_lock(&tiq_list_lock);
 	list_add_rcu(&irq_ptr->input_qs[0]->entry, &tiq_list);
 	mutex_unlock(&tiq_list_lock);
-	xchg(irq_ptr->dsci, 1 << 7);
 }
 
 void tiqdio_remove_input_queues(struct qdio_irq *irq_ptr)


