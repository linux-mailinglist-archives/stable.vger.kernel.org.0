Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22542521A2C
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbiEJNyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245437AbiEJNwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:52:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E6629B032;
        Tue, 10 May 2022 06:38:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32990615F2;
        Tue, 10 May 2022 13:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2986BC385A6;
        Tue, 10 May 2022 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189880;
        bh=rmlvZpm17lfrqvAW3UoK8aNjej5R95tUNQtmlikoKOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0tGFpsft4zz7tEf3WjhT/nG/ix6rraN/ymA3fnyO0NRXSRfDo/HRMOMRcQ33/r6v
         ym0kBLelZTzCt9Dl90YKjv8sjTqxS0wW04OJYFKw7W1KHT6KQR6Q+JqJtdTqB0gSTK
         nhfu3auBd8AJMddnp6ikN5i8Xpcc7juQ6p90bLc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.17 059/140] ASoC: meson: axg-card: Fix nonatomic links
Date:   Tue, 10 May 2022 15:07:29 +0200
Message-Id: <20220510130743.307108990@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 0c9b152c72e53016e96593bdbb8cffe2176694b9 upstream.

This commit e138233e56e9829e65b6293887063a1a3ccb2d68 causes the
following system crash when using audio on G12A/G12B & SM1 systems:

 BUG: sleeping function called from invalid context at kernel/locking/mutex.c:282
  in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/0
 preempt_count: 10001, expected: 0
 RCU nest depth: 0, expected: 0
 Preemption disabled at:
 schedule_preempt_disabled+0x20/0x2c

 mutex_lock+0x24/0x60
 _snd_pcm_stream_lock_irqsave+0x20/0x3c
 snd_pcm_period_elapsed+0x24/0xa4
 axg_fifo_pcm_irq_block+0x64/0xdc
 __handle_irq_event_percpu+0x104/0x264
 handle_irq_event+0x48/0xb4
 ...
 start_kernel+0x3f0/0x484
 __primary_switched+0xc0/0xc8

Revert this commit until the crash is fixed.

Fixes: e138233e56e9829e65b6 ("ASoC: meson: axg-card: make links nonatomic")
Reported-by: Dmitry Shmidt <dimitrysh@google.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20220421155725.2589089-2-narmstrong@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/meson/axg-card.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index cbbaa55d92a6..2b77010c2c5c 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -320,7 +320,6 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
 
 	dai_link->cpus = cpu;
 	dai_link->num_cpus = 1;
-	dai_link->nonatomic = true;
 
 	ret = meson_card_parse_dai(card, np, &dai_link->cpus->of_node,
 				   &dai_link->cpus->dai_name);
-- 
2.36.1



