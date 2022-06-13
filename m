Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C380154966C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377491AbiFMNdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378229AbiFMNbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:31:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211C36F4B8;
        Mon, 13 Jun 2022 04:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358AA60F18;
        Mon, 13 Jun 2022 11:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E0AC34114;
        Mon, 13 Jun 2022 11:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119548;
        bh=dus5GhVCCGRZl6vw1Z0GLTyGcpHSSBRD+KW0xEHSI3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjuT51fH6HXH4Q40Z2N9R/LXAQYG9knzGg/bws4krT/02bH5+7j+zUlHuXkr1+Dr0
         Hpcl1GrtKXV2E6WyEogmepj3JGFBPcuOPqczXlNRsNrfDmsP+XWZAreZYB6i7no8uK
         yfCw3QwtraODqPIoN2DrsEgtQCr5by6O34qe0MeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 053/339] coresight: cpu-debug: Replace mutex with mutex_trylock on panic notifier
Date:   Mon, 13 Jun 2022 12:07:58 +0200
Message-Id: <20220613094928.131944220@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

[ Upstream commit 1adff542d67a2ed1120955cb219bfff8a9c53f59 ]

The panic notifier infrastructure executes registered callbacks when
a panic event happens - such callbacks are executed in atomic context,
with interrupts and preemption disabled in the running CPU and all other
CPUs disabled. That said, mutexes in such context are not a good idea.

This patch replaces a regular mutex with a mutex_trylock safer approach;
given the nature of the mutex used in the driver, it should be pretty
uncommon being unable to acquire such mutex in the panic path, hence
no functional change should be observed (and if it is, that would be
likely a deadlock with the regular mutex).

Fixes: 2227b7c74634 ("coresight: add support for CPU debug module")
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20220427224924.592546-10-gpiccoli@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cpu-debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-cpu-debug.c b/drivers/hwtracing/coresight/coresight-cpu-debug.c
index 8845ec4b4402..1874df7c6a73 100644
--- a/drivers/hwtracing/coresight/coresight-cpu-debug.c
+++ b/drivers/hwtracing/coresight/coresight-cpu-debug.c
@@ -380,9 +380,10 @@ static int debug_notifier_call(struct notifier_block *self,
 	int cpu;
 	struct debug_drvdata *drvdata;
 
-	mutex_lock(&debug_lock);
+	/* Bail out if we can't acquire the mutex or the functionality is off */
+	if (!mutex_trylock(&debug_lock))
+		return NOTIFY_DONE;
 
-	/* Bail out if the functionality is disabled */
 	if (!debug_enable)
 		goto skip_dump;
 
@@ -401,7 +402,7 @@ static int debug_notifier_call(struct notifier_block *self,
 
 skip_dump:
 	mutex_unlock(&debug_lock);
-	return 0;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block debug_notifier = {
-- 
2.35.1



