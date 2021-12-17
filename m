Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EAC47902D
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 16:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhLQPog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 10:44:36 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:44934
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235158AbhLQPof (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 10:44:35 -0500
Received: from mussarela.. (unknown [179.93.189.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id CBCBA41846;
        Fri, 17 Dec 2021 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639755874;
        bh=K4KepFetoeRSfUTPalIOPzR+mpPdGckMTE+MuEeJBEg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=QeXiqAqUaxwoXwEDY3haRWNFv6f06HivPJz5bC3eCpqdUTV7XXgBMyR+ctTHZfych
         QkD/pP2A6sAk5oReAGvNE8wd5jAE4AdaKZmh0nbKUnA2bhBCW4H+Q68QbTwBRi4Cxr
         1nBo1tMtHdtDHucC3HaMC4ZFCP5YN8qZXHCPCtdricG84JHXbzeQBhVU/l4THiXqLA
         8hVF2qSNUYyVEDoM0rA9XCgcoV2Bq4ezBNU0TXJzNdFmnCu/u8+NjaNtGCBEcex9M+
         bccKLPbjEHRx/xc2us3k+cuadym0eQSboeoCuqWYyFe1UKSNgwv+q0/yt/oM56p0Zm
         DklJl5wfytF/g==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     openipmi-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, minyard@acm.org,
        ioanna-maria.alifieraki@canonical.com, minyard@mvista.com,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ipmi: fix initialization when workqueue allocation fails
Date:   Fri, 17 Dec 2021 12:44:10 -0300
Message-Id: <20211217154410.1228673-2-cascardo@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211217154410.1228673-1-cascardo@canonical.com>
References: <20211217154410.1228673-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the workqueue allocation fails, the driver is marked as not initialized,
and timer and panic_notifier will be left registered.

Instead of removing those when workqueue allocation fails, do the workqueue
initialization before doing it, and cleanup srcu_struct if it fails.

Fixes: 1d49eb91e86e ("ipmi: Move remove_work to dedicated workqueue")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Corey Minyard <cminyard@mvista.com>
Cc: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Cc: stable@vger.kernel.org
---
 drivers/char/ipmi/ipmi_msghandler.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 84975b21fff2..266c7bc58dda 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -5396,20 +5396,23 @@ static int ipmi_init_msghandler(void)
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
-- 
2.32.0

