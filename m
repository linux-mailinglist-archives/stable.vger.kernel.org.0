Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB94535F92
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbiE0LlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351538AbiE0Lki (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CED613C1E8;
        Fri, 27 May 2022 04:39:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC22561CD8;
        Fri, 27 May 2022 11:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4FFC385A9;
        Fri, 27 May 2022 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651566;
        bh=Gzi/MJPh1ygCTGNY7eBfQS7k+1JoXsxG6V4cb1psY9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1Y7p2bxpRupsLbnCxRR2h8wf5qKDMMiVJsF5D65iJe5G5h7Sf1us/+zOXWKDMFGl
         ykMb5c84Vub5I2zPk0wXZtTcvOGqFdnd2cgXJxvwkSlPTL/XQnOxt9lp0NrIrjPP5U
         /1EwxNtrY9GCCsvb90ulu+PZamR3TJ0rwtZxFDZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 017/145] random: harmonize "crng init done" messages
Date:   Fri, 27 May 2022 10:48:38 +0200
Message-Id: <20220527084853.060923208@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 161212c7fd1d9069b232785c75492e50941e2ea8 upstream.

We print out "crng init done" for !TRUST_CPU, so we should also print
out the same for TRUST_CPU.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -831,7 +831,7 @@ static void __init crng_initialize_prima
 		invalidate_batched_entropy();
 		numa_crng_init();
 		crng_init = 2;
-		pr_notice("crng done (trusting CPU's manufacturer)\n");
+		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }


