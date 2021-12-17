Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A639B47902B
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 16:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhLQPo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 10:44:28 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:44904
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231386AbhLQPo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 10:44:28 -0500
Received: from mussarela.. (unknown [179.93.189.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 25AF540037;
        Fri, 17 Dec 2021 15:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639755866;
        bh=JXQGwMMmUW1nBCI4kpGuICxFe0oVRCxJl7LFrpgK+VU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=uWqBCX2tvlb2lvqEm+eOp8NgBPJacuUGBjusaWrc78j5+VDYQ+6Cgg0NDS3Wb5EAL
         dMNTR2qN/0+Qf9bNjf1R82KG5pyL8pqu3L1z1SzkGY1e+im0Wx1X7tRdXJhSATb3Bh
         u6GoeYCA1UQDr8vYT+b+My3g0tlUn4OEBV/YkGfPdcl7ISCVzlNtgSAMjTd9f7DyzK
         nZ7SXZ5ZZgUvXwuzGPcRlVkh6R1DYB0ZiwrD40YoWlhsulS5tbNSMvq/NGentd+JT6
         p84u25SMmn7VizckeUDDx53G3AUzsVce/IvX0Ks0la39J4i3oORo+sODn2/9kYOCSB
         anxHmDRdFhnAg==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     openipmi-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, minyard@acm.org,
        ioanna-maria.alifieraki@canonical.com, minyard@mvista.com,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ipmi: bail out if init_srcu_struct fails
Date:   Fri, 17 Dec 2021 12:44:09 -0300
Message-Id: <20211217154410.1228673-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case, init_srcu_struct fails (because of memory allocation failure), we
might proceed with the driver initialization despite srcu_struct not being
entirely initialized.

Fixes: 913a89f009d9 ("ipmi: Don't initialize anything in the core until something uses it")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Corey Minyard <cminyard@mvista.com>
Cc: stable@vger.kernel.org
---
 drivers/char/ipmi/ipmi_msghandler.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index c837d5416e0e..84975b21fff2 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -5392,7 +5392,9 @@ static int ipmi_init_msghandler(void)
 	if (initialized)
 		goto out;
 
-	init_srcu_struct(&ipmi_interfaces_srcu);
+	rv = init_srcu_struct(&ipmi_interfaces_srcu);
+	if (rv)
+		goto out;
 
 	timer_setup(&ipmi_timer, ipmi_timeout, 0);
 	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
-- 
2.32.0

