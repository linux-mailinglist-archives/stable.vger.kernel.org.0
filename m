Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED9D505851
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbiDRN7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244341AbiDRN44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:56:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E2B2AC40;
        Mon, 18 Apr 2022 06:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C81C060B42;
        Mon, 18 Apr 2022 13:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CF4C385A1;
        Mon, 18 Apr 2022 13:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287144;
        bh=WsLHA1Z1b5RQopdUOITodOEKeP/LyY/bc+Qq0b7DnrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Haas5yD5tMqgEq6B1KSzxotqBBI81fcJA/6ETDSJw5EHo55Snc8MT1HIq43khrrJm
         QOWsLBucoYiRH0c35Nxi6uK1eqGE3pyBTE6Czavqae3es3SQuSKiuTmUbjXzwJ3kOJ
         +PeeE64MBaD5hDlmKywjM9VH+0iJgxtut6OSEc5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/218] ALSA: firewire-lib: fix uninitialized flag for AV/C deferred transaction
Date:   Mon, 18 Apr 2022 14:12:15 +0200
Message-Id: <20220418121201.585200350@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit bf0cd60b7e33cf221fbe1114e4acb2c828b0af0d ]

AV/C deferred transaction was supported at a commit 00a7bb81c20f ("ALSA:
firewire-lib: Add support for deferred transaction") while 'deferrable'
flag can be uninitialized for non-control/notify AV/C transactions.
UBSAN reports it:

kernel: ================================================================================
kernel: UBSAN: invalid-load in /build/linux-aa0B4d/linux-5.15.0/sound/firewire/fcp.c:363:9
kernel: load of value 158 is not a valid value for type '_Bool'
kernel: CPU: 3 PID: 182227 Comm: irq/35-firewire Tainted: P           OE     5.15.0-18-generic #18-Ubuntu
kernel: Hardware name: Gigabyte Technology Co., Ltd. AX370-Gaming 5/AX370-Gaming 5, BIOS F42b 08/01/2019
kernel: Call Trace:
kernel:  <IRQ>
kernel:  show_stack+0x52/0x58
kernel:  dump_stack_lvl+0x4a/0x5f
kernel:  dump_stack+0x10/0x12
kernel:  ubsan_epilogue+0x9/0x45
kernel:  __ubsan_handle_load_invalid_value.cold+0x44/0x49
kernel:  fcp_response.part.0.cold+0x1a/0x2b [snd_firewire_lib]
kernel:  fcp_response+0x28/0x30 [snd_firewire_lib]
kernel:  fw_core_handle_request+0x230/0x3d0 [firewire_core]
kernel:  handle_ar_packet+0x1d9/0x200 [firewire_ohci]
kernel:  ? handle_ar_packet+0x1d9/0x200 [firewire_ohci]
kernel:  ? transmit_complete_callback+0x9f/0x120 [firewire_core]
kernel:  ar_context_tasklet+0xa8/0x2e0 [firewire_ohci]
kernel:  tasklet_action_common.constprop.0+0xea/0xf0
kernel:  tasklet_action+0x22/0x30
kernel:  __do_softirq+0xd9/0x2e3
kernel:  ? irq_finalize_oneshot.part.0+0xf0/0xf0
kernel:  do_softirq+0x75/0xa0
kernel:  </IRQ>
kernel:  <TASK>
kernel:  __local_bh_enable_ip+0x50/0x60
kernel:  irq_forced_thread_fn+0x7e/0x90
kernel:  irq_thread+0xba/0x190
kernel:  ? irq_thread_fn+0x60/0x60
kernel:  kthread+0x11e/0x140
kernel:  ? irq_thread_check_affinity+0xf0/0xf0
kernel:  ? set_kthread_struct+0x50/0x50
kernel:  ret_from_fork+0x22/0x30
kernel:  </TASK>
kernel: ================================================================================

This commit fixes the bug. The bug has no disadvantage for the non-
control/notify AV/C transactions since the flag has an effect for AV/C
response with INTERIM (0x0f) status which is not used for the transactions
in AV/C general specification.

Fixes: 00a7bb81c20f ("ALSA: firewire-lib: Add support for deferred transaction")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20220304125647.78430-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/fcp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/firewire/fcp.c b/sound/firewire/fcp.c
index cce19768f43d..8209856293d3 100644
--- a/sound/firewire/fcp.c
+++ b/sound/firewire/fcp.c
@@ -234,9 +234,7 @@ int fcp_avc_transaction(struct fw_unit *unit,
 	t.response_match_bytes = response_match_bytes;
 	t.state = STATE_PENDING;
 	init_waitqueue_head(&t.wait);
-
-	if (*(const u8 *)command == 0x00 || *(const u8 *)command == 0x03)
-		t.deferrable = true;
+	t.deferrable = (*(const u8 *)command == 0x00 || *(const u8 *)command == 0x03);
 
 	spin_lock_irq(&transactions_lock);
 	list_add_tail(&t.list, &transactions);
-- 
2.34.1



