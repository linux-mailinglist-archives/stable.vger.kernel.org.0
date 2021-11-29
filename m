Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ABB462585
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhK2Wkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbhK2WkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:40:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B24C048F68;
        Mon, 29 Nov 2021 10:40:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CE03CE13DB;
        Mon, 29 Nov 2021 18:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19024C53FC7;
        Mon, 29 Nov 2021 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211247;
        bh=Zxwa+By29hvP/1GcAnDs6DmOImIkfpu5UxnCRC8Hsx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTRKt9QC8GhKA10Ff9zTHjT/IGcrd3pjMofWCAQtlF+FxDig9oYGqouKKOm32T+JK
         7zAtELxfQH1qZu5jb8eR0fetveu3P/DxTTlco6MVGO145AiIjjpxLC0CKqZqZcEv8e
         mV9Fr3GXHLefMNR2FxyMFI2E0bM8bu9Y30qHjUE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/179] net: ipa: kill ipa_cmd_pipeline_clear()
Date:   Mon, 29 Nov 2021 19:18:37 +0100
Message-Id: <20211129181723.000904134@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit e4e9bfb7c93d7e78aa4ad7e1c411a8df15386062 ]

Calling ipa_cmd_pipeline_clear() after stopping the channel
underlying the AP<-modem RX endpoint can lead to a deadlock.

This occurs in the ->runtime_suspend device power operation for the
IPA driver.  While this callback is in progress, any other requests
for power will block until the callback returns.

Stopping the AP<-modem RX channel does not prevent the modem from
sending another packet to this endpoint.  If a packet arrives for an
RX channel when the channel is stopped, an SUSPEND IPA interrupt
condition will be pending.  Handling an IPA interrupt requires
power, so ipa_isr_thread() calls pm_runtime_get_sync() first thing.

The problem occurs because a "pipeline clear" command will not
complete while such a SUSPEND interrupt condition exists.  So the
SUSPEND IPA interrupt handler won't proceed until it gets power;
that won't happen until the ->runtime_suspend callback (and its
"pipeline clear" command) completes; and that can't happen while
the SUSPEND interrupt condition exists.

It turns out that in this case there is no need to use the "pipeline
clear" command.  There are scenarios in which clearing the pipeline
is required while suspending, but those are not (yet) supported
upstream.  So a simple fix, avoiding the potential deadlock, is to
stop calling ipa_cmd_pipeline_clear() in ipa_endpoint_suspend().
This removes the only user of ipa_cmd_pipeline_clear(), so get rid
of that function.  It can be restored again whenever it's needed.

This is basically a manual revert along with an explanation for
commit 6cb63ea6a39ea ("net: ipa: introduce ipa_cmd_tag_process()").

Fixes: 6cb63ea6a39ea ("net: ipa: introduce ipa_cmd_tag_process()")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_cmd.c      | 16 ----------------
 drivers/net/ipa/ipa_cmd.h      |  6 ------
 drivers/net/ipa/ipa_endpoint.c |  2 --
 3 files changed, 24 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index cff51731195aa..d57472ea077f2 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -661,22 +661,6 @@ void ipa_cmd_pipeline_clear_wait(struct ipa *ipa)
 	wait_for_completion(&ipa->completion);
 }
 
-void ipa_cmd_pipeline_clear(struct ipa *ipa)
-{
-	u32 count = ipa_cmd_pipeline_clear_count();
-	struct gsi_trans *trans;
-
-	trans = ipa_cmd_trans_alloc(ipa, count);
-	if (trans) {
-		ipa_cmd_pipeline_clear_add(trans);
-		gsi_trans_commit_wait(trans);
-		ipa_cmd_pipeline_clear_wait(ipa);
-	} else {
-		dev_err(&ipa->pdev->dev,
-			"error allocating %u entry tag transaction\n", count);
-	}
-}
-
 static struct ipa_cmd_info *
 ipa_cmd_info_alloc(struct ipa_endpoint *endpoint, u32 tre_count)
 {
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 69cd085d427db..05ed7e42e1842 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -163,12 +163,6 @@ u32 ipa_cmd_pipeline_clear_count(void);
  */
 void ipa_cmd_pipeline_clear_wait(struct ipa *ipa);
 
-/**
- * ipa_cmd_pipeline_clear() - Clear the hardware pipeline
- * @ipa:	- IPA pointer
- */
-void ipa_cmd_pipeline_clear(struct ipa *ipa);
-
 /**
  * ipa_cmd_trans_alloc() - Allocate a transaction for the command TX endpoint
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index ef790fd0ab56a..03a1709934208 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1636,8 +1636,6 @@ void ipa_endpoint_suspend(struct ipa *ipa)
 	if (ipa->modem_netdev)
 		ipa_modem_suspend(ipa->modem_netdev);
 
-	ipa_cmd_pipeline_clear(ipa);
-
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_LAN_RX]);
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX]);
 }
-- 
2.33.0



