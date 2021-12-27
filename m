Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22E247FEE3
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbhL0Pdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238007AbhL0PdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:33:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7B7C06175A;
        Mon, 27 Dec 2021 07:33:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 07AE2CE10AF;
        Mon, 27 Dec 2021 15:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C565CC36AE7;
        Mon, 27 Dec 2021 15:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619193;
        bh=W9VEaQqSXCUfe+dsRHUugV2t0qTTWQKNP6xk+sWz12s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxKWC5wRnA+g6APFoLE1txfmHA53NFMNHjaYjDJNjAZN0kW+dn4KVEBEXq7jg8FXD
         JQO58MHsyQ2d8dAPu7eKMFupelZHuJjGKkAGaDhgNADUYkkBbFbUeqokjDAzqRrgrE
         Na9T2qV2qcTlEpIgyOKktM3w4eP3Qegiva6NRMw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Corey Minyard <cminyard@mvista.com>,
        Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Subject: [PATCH 4.19 25/38] ipmi: fix initialization when workqueue allocation fails
Date:   Mon, 27 Dec 2021 16:31:02 +0100
Message-Id: <20211227151320.223854329@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 75d70d76cb7b927cace2cb34265d68ebb3306b13 upstream.

If the workqueue allocation fails, the driver is marked as not initialized,
and timer and panic_notifier will be left registered.

Instead of removing those when workqueue allocation fails, do the workqueue
initialization before doing it, and cleanup srcu_struct if it fails.

Fixes: 1d49eb91e86e ("ipmi: Move remove_work to dedicated workqueue")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Corey Minyard <cminyard@mvista.com>
Cc: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Cc: stable@vger.kernel.org
Message-Id: <20211217154410.1228673-2-cascardo@canonical.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -5089,20 +5089,23 @@ static int ipmi_init_msghandler(void)
 	if (rv)
 		goto out;
 
-	timer_setup(&ipmi_timer, ipmi_timeout, 0);
-	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
-
-	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
-
 	remove_work_wq = create_singlethread_workqueue("ipmi-msghandler-remove-wq");
 	if (!remove_work_wq) {
 		pr_err("unable to create ipmi-msghandler-remove-wq workqueue");
 		rv = -ENOMEM;
-		goto out;
+		goto out_wq;
 	}
 
+	timer_setup(&ipmi_timer, ipmi_timeout, 0);
+	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
+
+	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+
 	initialized = true;
 
+out_wq:
+	if (rv)
+		cleanup_srcu_struct(&ipmi_interfaces_srcu);
 out:
 	mutex_unlock(&ipmi_interfaces_mutex);
 	return rv;


