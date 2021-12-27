Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C856647FF1A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbhL0PfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:35:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35614 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbhL0PfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:35:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1253C610F4;
        Mon, 27 Dec 2021 15:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0B1C36AE7;
        Mon, 27 Dec 2021 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619312;
        bh=ImSu58zj0rM7C3683z1wGhQFyF1wzwbvOqip2KjSwZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zK9E16OrPuF8bevj89HNyyvK4YTh01DoUmCXsOJ44dsSkxgDVpukDCNwD/WEzlheW
         ofrwmu6HD/YBwC2k6TlO+b7G6pfDMfCORvXrVPMwdT9sVFCVcFC/EAC6kOwvHlqyxY
         8s26HOzTbwAQ0nXvUVGqvvHAtPaGxuxr878OdNkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Corey Minyard <cminyard@mvista.com>,
        Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Subject: [PATCH 5.4 28/47] ipmi: fix initialization when workqueue allocation fails
Date:   Mon, 27 Dec 2021 16:31:04 +0100
Message-Id: <20211227151321.767687961@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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
@@ -5160,20 +5160,23 @@ static int ipmi_init_msghandler(void)
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


