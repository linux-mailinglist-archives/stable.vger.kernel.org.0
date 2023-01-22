Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0977F676F26
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjAVPSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjAVPSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:18:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6123AB5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B98B60C48
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1C5C433D2;
        Sun, 22 Jan 2023 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400691;
        bh=qVWf0RJkRGfrQTd+FUM4b4Swu6f7nlndQ+Oa8K42xCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sH/L936GIU73lefpfCebgzKRePcR83JrDStC4DusRY1+NLV1NFsfIf65vHt7Mz7LQ
         UcRMCzzl1FDqtTFyJaq+ndjuOCnLsweYk6dm7L+gv0tZG6yoMf09fi5YEP932s6374
         UkV5GXFH11Rba+Lub53llBu/v6y8Rn+adfHQqnFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.15 073/117] tty: fix possible null-ptr-defer in spk_ttyio_release
Date:   Sun, 22 Jan 2023 16:04:23 +0100
Message-Id: <20230122150235.832235416@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 5abbeebd8296c2301023b8dc4b5a6c0d5229b4f5 upstream.

Run the following tests on the qemu platform:

syzkaller:~# modprobe speakup_audptr
 input: Speakup as /devices/virtual/input/input4
 initialized device: /dev/synth, node (MAJOR 10, MINOR 125)
 speakup 3.1.6: initialized
 synth name on entry is: (null)
 synth probe

spk_ttyio_initialise_ldisc failed because tty_kopen_exclusive returned
failed (errno -16), then remove the module, we will get a null-ptr-defer
problem, as follow:

syzkaller:~# modprobe -r speakup_audptr
 releasing synth audptr
 BUG: kernel NULL pointer dereference, address: 0000000000000080
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 0 P4D 0
 Oops: 0002 [#1] PREEMPT SMP PTI
 CPU: 2 PID: 204 Comm: modprobe Not tainted 6.1.0-rc6-dirty #1
 RIP: 0010:mutex_lock+0x14/0x30
 Call Trace:
 <TASK>
  spk_ttyio_release+0x19/0x70 [speakup]
  synth_release.part.6+0xac/0xc0 [speakup]
  synth_remove+0x56/0x60 [speakup]
  __x64_sys_delete_module+0x156/0x250
  ? fpregs_assert_state_consistent+0x1d/0x50
  do_syscall_64+0x37/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>
 Modules linked in: speakup_audptr(-) speakup
 Dumping ftrace buffer:

in_synth->dev was not initialized during modprobe, so we add check
for in_synth->dev to fix this bug.

Fixes: 4f2a81f3a882 ("speakup: Reference synth from tty and tty from synth")
Cc: stable <stable@kernel.org>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221202060633.217364-1-cuigaosheng1@huawei.com
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/spk_ttyio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/accessibility/speakup/spk_ttyio.c
+++ b/drivers/accessibility/speakup/spk_ttyio.c
@@ -354,6 +354,9 @@ void spk_ttyio_release(struct spk_synth
 {
 	struct tty_struct *tty = in_synth->dev;
 
+	if (tty == NULL)
+		return;
+
 	tty_lock(tty);
 
 	if (tty->ops->close)


