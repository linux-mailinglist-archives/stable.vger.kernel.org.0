Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F6676FD8
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjAVPZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjAVPZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:25:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EF422A07
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:25:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5FF6CCE0EDF
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A6FC433D2;
        Sun, 22 Jan 2023 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401148;
        bh=qVWf0RJkRGfrQTd+FUM4b4Swu6f7nlndQ+Oa8K42xCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQqBb6o39qyPpbcvnsbI+77Z3yvya6SJuU9ZE660naGQP3eT5XR10gan6e0k/qw3R
         TRSXighaa0E9H4Yv57glZqEcO5I0Rl0jz4kf4OHSEZrkBiP49e7X6Wi+PWjuzrNAex
         fc8ZVew3vxdTi7JmZigPgGZhI/sThYaJy88wNvFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.1 098/193] tty: fix possible null-ptr-defer in spk_ttyio_release
Date:   Sun, 22 Jan 2023 16:03:47 +0100
Message-Id: <20230122150250.803355768@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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


