Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3783347FFCA
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238682AbhL0PlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39524 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbhL0Pjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85B15610A4;
        Mon, 27 Dec 2021 15:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F68EC36AE7;
        Mon, 27 Dec 2021 15:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619586;
        bh=g+O9WgUXSHzbiuwmIO5MJHkiX5UKdFlqXoPn0X7GwFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FeATy4B32ANadktvoaWMG2DlnJJLf1Q5dPe2oKIh3JSBU7F3+YKrilnctfIFNk1M1
         71taBHqqrQFq2abTn5RTUZVUo3Ld8GcEfFQcPJ0TVPjDLjQkgJshPb4B0fez7JTXRl
         MHfJvQoAGa3KOrny/dqhXlbtxOcJT63xQvyeougA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Corey Minyard <cminyard@mvista.com>,
        Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Subject: [PATCH 5.10 43/76] ipmi: fix initialization when workqueue allocation fails
Date:   Mon, 27 Dec 2021 16:30:58 +0100
Message-Id: <20211227151326.197870853@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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
@@ -5165,20 +5165,23 @@ static int ipmi_init_msghandler(void)
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


