Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64EB56FD11
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbiGKJue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbiGKJtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:49:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611D623BD6;
        Mon, 11 Jul 2022 02:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C73AB612FE;
        Mon, 11 Jul 2022 09:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1233C34115;
        Mon, 11 Jul 2022 09:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531452;
        bh=BhTQ1+OzpOMgF/TPBqjizHXL4xPWjSslKZNPIH5xw8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djda2JJbyu9+W0PFokRJbzAMmFQaBJjoFI6PLErUK4vaMvgbwX6MQVD+M1c+t+8ib
         pvsVou0n3sh5mXguoWk5v4E18wO6CtQQDNKmY9tn3DwanY5M3WP1uKUjcHMjT9m7qX
         DS0DbX66Np3/wNJhFvOiv4jopMQnwwRf8aCWWw6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/230] bus: mhi: core: Use correctly sized arguments for bit field
Date:   Mon, 11 Jul 2022 11:06:06 +0200
Message-Id: <20220711090607.187942873@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 5a717e93239fc373a314e03e45c43b62ebea1b26 ]

The find.h APIs are designed to be used only on unsigned long arguments.
This can technically result in a over-read, but it is harmless in this
case. Regardless, fix it to avoid the warning seen under -Warray-bounds,
which we'd like to enable globally:

In file included from ./include/linux/bitmap.h:9,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/cpumask.h:5,
                 from ./arch/x86/include/asm/msr.h:11,
                 from ./arch/x86/include/asm/processor.h:22,
                 from ./arch/x86/include/asm/cpufeature.h:5,
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:60,
                 from ./arch/x86/include/asm/preempt.h:7,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/spinlock.h:55,
                 from ./include/linux/wait.h:9,
                 from ./include/linux/wait_bit.h:8,
                 from ./include/linux/fs.h:6,
                 from ./include/linux/debugfs.h:15,
                 from drivers/bus/mhi/core/init.c:7:
drivers/bus/mhi/core/init.c: In function 'to_mhi_pm_state_str':
./include/linux/find.h:187:37: warning: array subscript 'long unsigned int[0]' is partly outside array bounds of 'enum mhi_pm_state[1]' [-Warray-bounds]
  187 |                 unsigned long val = *addr & GENMASK(size - 1, 0);
      |                                     ^~~~~
drivers/bus/mhi/core/init.c:80:51: note: while referencing 'state'
   80 | const char *to_mhi_pm_state_str(enum mhi_pm_state state)
      |                                 ~~~~~~~~~~~~~~~~~~^~~~~

Link: https://lore.kernel.org/r/20211215232446.2069794-1-keescook@chromium.org
[mani: changed the variable name "bits" to "pm_state"]
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20211216081227.237749-10-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 4183945fc2c4..c0187367ae75 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -79,7 +79,8 @@ static const char * const mhi_pm_state_str[] = {
 
 const char *to_mhi_pm_state_str(enum mhi_pm_state state)
 {
-	int index = find_last_bit((unsigned long *)&state, 32);
+	unsigned long pm_state = state;
+	int index = find_last_bit(&pm_state, 32);
 
 	if (index >= ARRAY_SIZE(mhi_pm_state_str))
 		return "Invalid State";
-- 
2.35.1



