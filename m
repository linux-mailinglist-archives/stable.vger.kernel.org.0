Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F1166778B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbjALOpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239943AbjALOo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:44:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCAD54737
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:32:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F20E86203B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABA7C433F0;
        Thu, 12 Jan 2023 14:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533974;
        bh=aEeLNJ1YrcI5bLMv3AqZMONFgTd3o7bR3zux2ZojO5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpdfglxuD5GRRJqIK/WcKEwgaZBdQooPs2k5lQmTEdau3Dgf/75+LI7TXjEwRN2I0
         YbNK0pSkHCuRHXcPyC7raGMIEys2NAbDxaQoujpyMgcYGE9fxTXrsAjqMuj/IprJS7
         0sAhCDhOwtKrNfn3HtJqB+19YiVCZfJsMBElQTgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Yuchen <zhangyuchen.lcr@bytedance.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.10 653/783] ipmi: fix long wait in unload when IPMI disconnect
Date:   Thu, 12 Jan 2023 14:56:09 +0100
Message-Id: <20230112135554.607391451@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yuchen <zhangyuchen.lcr@bytedance.com>

commit f6f1234d98cce69578bfac79df147a1f6660596c upstream.

When fixing the problem mentioned in PATCH1, we also found
the following problem:

If the IPMI is disconnected and in the sending process, the
uninstallation driver will be stuck for a long time.

The main problem is that uninstalling the driver waits for curr_msg to
be sent or HOSED. After stopping tasklet, the only place to trigger the
timeout mechanism is the circular poll in shutdown_smi.

The poll function delays 10us and calls smi_event_handler(smi_info,10).
Smi_event_handler deducts 10us from kcs->ibf_timeout.

But the poll func is followed by schedule_timeout_uninterruptible(1).
The time consumed here is not counted in kcs->ibf_timeout.

So when 10us is deducted from kcs->ibf_timeout, at least 1 jiffies has
actually passed. The waiting time has increased by more than a
hundredfold.

Now instead of calling poll(). call smi_event_handler() directly and
calculate the elapsed time.

For verification, you can directly use ebpf to check the kcs->
ibf_timeout for each call to kcs_event() when IPMI is disconnected.
Decrement at normal rate before unloading. The decrement rate becomes
very slow after unloading.

  $ bpftrace -e 'kprobe:kcs_event {printf("kcs->ibftimeout : %d\n",
      *(arg0+584));}'

Signed-off-by: Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
Message-Id: <20221007092617.87597-3-zhangyuchen.lcr@bytedance.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2160,6 +2160,20 @@ skip_fallback_noirq:
 }
 module_init(init_ipmi_si);
 
+static void wait_msg_processed(struct smi_info *smi_info)
+{
+	unsigned long jiffies_now;
+	long time_diff;
+
+	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
+		jiffies_now = jiffies;
+		time_diff = (((long)jiffies_now - (long)smi_info->last_timeout_jiffies)
+		     * SI_USEC_PER_JIFFY);
+		smi_event_handler(smi_info, time_diff);
+		schedule_timeout_uninterruptible(1);
+	}
+}
+
 static void shutdown_smi(void *send_info)
 {
 	struct smi_info *smi_info = send_info;
@@ -2194,16 +2208,13 @@ static void shutdown_smi(void *send_info
 	 * in the BMC.  Note that timers and CPU interrupts are off,
 	 * so no need for locks.
 	 */
-	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
-		poll(smi_info);
-		schedule_timeout_uninterruptible(1);
-	}
+	wait_msg_processed(smi_info);
+
 	if (smi_info->handlers)
 		disable_si_irq(smi_info);
-	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
-		poll(smi_info);
-		schedule_timeout_uninterruptible(1);
-	}
+
+	wait_msg_processed(smi_info);
+
 	if (smi_info->handlers)
 		smi_info->handlers->cleanup(smi_info->si_sm);
 


