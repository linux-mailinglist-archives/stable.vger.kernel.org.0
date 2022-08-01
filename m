Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4FB5869F6
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiHAMJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiHAMJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:09:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEB3474D7;
        Mon,  1 Aug 2022 04:56:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 864ECB81163;
        Mon,  1 Aug 2022 11:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D871BC433D6;
        Mon,  1 Aug 2022 11:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354967;
        bh=iqE2JW/78bOCVNZntrMXW5Fn3YTkZZzUUxcreeokXRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NN8il6tEtqmCiBkNnY6M9D/JOo33cqcHGIZ/UOKAoAOC3YelDmI+4JT2tIOJgfaSg
         duurPFqPCeKBuEC06QmMYYF7AcT8HnvpdAQDnaApfS3+FT53FLkBnqkJ1vRHlIiFHs
         Cb3u49Uum7KtTfOVrkx3ZQR3+4XdpuRn859ucojk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.18 15/88] intel_idle: Fix false positive RCU splats due to incorrect hardirqs state
Date:   Mon,  1 Aug 2022 13:46:29 +0200
Message-Id: <20220801114138.753846490@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit d295ad34f236c3518634fb6403d4c0160456e470 upstream.

Commit 32d4fd5751ea ("cpuidle,intel_idle: Fix CPUIDLE_FLAG_IRQ_ENABLE")
uses raw_local_irq_enable/local_irq_disable() around call to
__intel_idle() in intel_idle_irq().

With interrupt enabled, timer tick interrupt can happen and a
subsequently call to __do_softirq() may change the lockdep hardirqs state
of a debug kernel back to 'on'. This will result in a mismatch between
the cpu hardirqs state (off) and the lockdep hardirqs state (on) causing
a number of false positive "WARNING: suspicious RCU usage" splats.

Fix that by using local_irq_disable() to disable interrupt in
intel_idle_irq().

Fixes: 32d4fd5751ea ("cpuidle,intel_idle: Fix CPUIDLE_FLAG_IRQ_ENABLE")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/idle/intel_idle.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index f5c6802aa6c3..907700d1e78e 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -162,7 +162,13 @@ static __cpuidle int intel_idle_irq(struct cpuidle_device *dev,
 
 	raw_local_irq_enable();
 	ret = __intel_idle(dev, drv, index);
-	raw_local_irq_disable();
+
+	/*
+	 * The lockdep hardirqs state may be changed to 'on' with timer
+	 * tick interrupt followed by __do_softirq(). Use local_irq_disable()
+	 * to keep the hardirqs state correct.
+	 */
+	local_irq_disable();
 
 	return ret;
 }
-- 
2.37.1



