Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868256B43FE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjCJOUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjCJOUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6546EDCF62
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:18:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04B9261745
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07B7C433EF;
        Fri, 10 Mar 2023 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457925;
        bh=hnKt2k255I1xAGarFm4yHVMmncnDCVr5dczd2H3cJYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBDexButCcYxc6dR8MSyeiyfbqG1nWjyM5tUpL0U4G+/1iO/OBogU9NwGly8vqpYb
         qFIZZhz4uDbDYOKWOWRMpL3+oJmiOzSuDXpPyoggYnYXbW9NuqNYkRSmbeNbg3FxN6
         5YBmrKDBCClu++53DU0zLQUtcTUeZVoOy0hcjqPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Lynch <nathanl@linux.ibm.com>,
        Laurent Dufour <laurent.dufour@fr.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/252] powerpc/rtas: make all exports GPL
Date:   Fri, 10 Mar 2023 14:37:55 +0100
Message-Id: <20230310133721.986410532@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 9bce6243848dfd0ff7c2be6e8d82ab9b1e6c7858 ]

The first symbol exports of RTAS functions and data came with the (now
removed) scanlog driver in 2003:

https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=f92e361842d5251e50562b09664082dcbd0548bb

At the time this was applied, EXPORT_SYMBOL_GPL() was very new, and
the exports of rtas_call() etc have remained non-GPL. As new APIs have
been added to the RTAS subsystem, their symbol exports have followed
the convention set by existing code.

However, the historical evidence is that RTAS function exports have been
added over time only to satisfy the needs of in-kernel users, and these
clients must have fairly intimate knowledge of how the APIs work to use
them safely. No out of tree users are known, and future ones seem
unlikely.

Arguably the default for RTAS symbols should have become
EXPORT_SYMBOL_GPL once it was available. Let's make it so now, and
exceptions can be evaluated as needed.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Laurent Dufour <laurent.dufour@fr.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230124140448.45938-3-nathanl@linux.ibm.com
Stable-dep-of: 836b5b9fcc8e ("powerpc/rtas: ensure 4KB alignment for rtas_data_buf")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index a3f08a380c992..07d1ef762936d 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -54,10 +54,10 @@ struct rtas_t rtas = {
 EXPORT_SYMBOL(rtas);
 
 DEFINE_SPINLOCK(rtas_data_buf_lock);
-EXPORT_SYMBOL(rtas_data_buf_lock);
+EXPORT_SYMBOL_GPL(rtas_data_buf_lock);
 
 char rtas_data_buf[RTAS_DATA_BUF_SIZE] __cacheline_aligned;
-EXPORT_SYMBOL(rtas_data_buf);
+EXPORT_SYMBOL_GPL(rtas_data_buf);
 
 unsigned long rtas_rmo_buf;
 
@@ -66,7 +66,7 @@ unsigned long rtas_rmo_buf;
  * This is done like this so rtas_flash can be a module.
  */
 void (*rtas_flash_term_hook)(int);
-EXPORT_SYMBOL(rtas_flash_term_hook);
+EXPORT_SYMBOL_GPL(rtas_flash_term_hook);
 
 /* RTAS use home made raw locking instead of spin_lock_irqsave
  * because those can be called from within really nasty contexts
@@ -314,7 +314,7 @@ void rtas_progress(char *s, unsigned short hex)
  
 	spin_unlock(&progress_lock);
 }
-EXPORT_SYMBOL(rtas_progress);		/* needed by rtas_flash module */
+EXPORT_SYMBOL_GPL(rtas_progress);		/* needed by rtas_flash module */
 
 int rtas_token(const char *service)
 {
@@ -324,7 +324,7 @@ int rtas_token(const char *service)
 	tokp = of_get_property(rtas.dev, service, NULL);
 	return tokp ? be32_to_cpu(*tokp) : RTAS_UNKNOWN_SERVICE;
 }
-EXPORT_SYMBOL(rtas_token);
+EXPORT_SYMBOL_GPL(rtas_token);
 
 int rtas_service_present(const char *service)
 {
@@ -484,7 +484,7 @@ int rtas_call(int token, int nargs, int nret, int *outputs, ...)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(rtas_call);
+EXPORT_SYMBOL_GPL(rtas_call);
 
 /* For RTAS_BUSY (-2), delay for 1 millisecond.  For an extended busy status
  * code of 990n, perform the hinted delay of 10^n (last digit) milliseconds.
@@ -519,7 +519,7 @@ unsigned int rtas_busy_delay(int status)
 
 	return ms;
 }
-EXPORT_SYMBOL(rtas_busy_delay);
+EXPORT_SYMBOL_GPL(rtas_busy_delay);
 
 static int rtas_error_rc(int rtas_rc)
 {
@@ -565,7 +565,7 @@ int rtas_get_power_level(int powerdomain, int *level)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_get_power_level);
+EXPORT_SYMBOL_GPL(rtas_get_power_level);
 
 int rtas_set_power_level(int powerdomain, int level, int *setlevel)
 {
@@ -583,7 +583,7 @@ int rtas_set_power_level(int powerdomain, int level, int *setlevel)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_set_power_level);
+EXPORT_SYMBOL_GPL(rtas_set_power_level);
 
 int rtas_get_sensor(int sensor, int index, int *state)
 {
@@ -601,7 +601,7 @@ int rtas_get_sensor(int sensor, int index, int *state)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_get_sensor);
+EXPORT_SYMBOL_GPL(rtas_get_sensor);
 
 int rtas_get_sensor_fast(int sensor, int index, int *state)
 {
@@ -662,7 +662,7 @@ int rtas_set_indicator(int indicator, int index, int new_value)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_set_indicator);
+EXPORT_SYMBOL_GPL(rtas_set_indicator);
 
 /*
  * Ignoring RTAS extended delay
-- 
2.39.2



