Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B518548A6A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380442AbiFMOGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382666AbiFMOGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:06:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF61972A1;
        Mon, 13 Jun 2022 04:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7DC7B80ECD;
        Mon, 13 Jun 2022 11:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E41C34114;
        Mon, 13 Jun 2022 11:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120466;
        bh=wVkcYHc5vMhIs7MOXoo85jAoir9Esaq47MytOfsNKtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAr9UHEhlnA4/0msg5CZHT/h+rD0bSkhCBnr8+Wg+eVLH47SBF83K9JG4W6eqzw2U
         aCGMl22E4bsuwsKNGxBab7alb925zZRkqhLsoUrVF9CKiI9lITL5WjL9Ligccu2vOV
         TSmfI/scOwIP5f5R69mg5eSQL0iX4bSVBVVti/7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        zhenwei pi <pizhenwei@bytedance.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 035/298] misc/pvpanic: Convert regular spinlock into trylock on panic path
Date:   Mon, 13 Jun 2022 12:08:49 +0200
Message-Id: <20220613094925.996414608@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit e918c10265ef2bc82ce8a6fed6d8123d09ec1db3 ]

The pvpanic driver relies on panic notifiers to execute a callback
on panic event. Such function is executed in atomic context - the
panic function disables local IRQs, preemption and all other CPUs
that aren't running the panic code.

With that said, it's dangerous to use regular spinlocks in such path,
as introduced by commit b3c0f8774668 ("misc/pvpanic: probe multiple instances").
This patch fixes that by replacing regular spinlocks with the trylock
safer approach.

It also fixes an old comment (about a long gone framebuffer code) and
the notifier priority - we should execute hypervisor notifiers early,
deferring this way the panic action to the hypervisor, as expected by
the users that are setting up pvpanic.

Fixes: b3c0f8774668 ("misc/pvpanic: probe multiple instances")
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Mihai Carabas <mihai.carabas@oracle.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Link: https://lore.kernel.org/r/20220427224924.592546-6-gpiccoli@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index 4b8f1c7d726d..049a12006348 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -34,7 +34,9 @@ pvpanic_send_event(unsigned int event)
 {
 	struct pvpanic_instance *pi_cur;
 
-	spin_lock(&pvpanic_lock);
+	if (!spin_trylock(&pvpanic_lock))
+		return;
+
 	list_for_each_entry(pi_cur, &pvpanic_list, list) {
 		if (event & pi_cur->capability & pi_cur->events)
 			iowrite8(event, pi_cur->base);
@@ -55,9 +57,13 @@ pvpanic_panic_notify(struct notifier_block *nb, unsigned long code, void *unused
 	return NOTIFY_DONE;
 }
 
+/*
+ * Call our notifier very early on panic, deferring the
+ * action taken to the hypervisor.
+ */
 static struct notifier_block pvpanic_panic_nb = {
 	.notifier_call = pvpanic_panic_notify,
-	.priority = 1, /* let this called before broken drm_fb_helper() */
+	.priority = INT_MAX,
 };
 
 static void pvpanic_remove(void *param)
-- 
2.35.1



