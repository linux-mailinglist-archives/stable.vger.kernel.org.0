Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1DD60A613
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbiJXMbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbiJXM3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7449318F;
        Mon, 24 Oct 2022 05:03:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A56FB81219;
        Mon, 24 Oct 2022 12:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0437C433D7;
        Mon, 24 Oct 2022 12:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612862;
        bh=sqEKswuUxTriNBWzsTySPH303zgQ9wiLoNPZnKShKxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QH+KIpMER4dTvd6y7DnAiakYLcSUPIDPfGTh2NlZf6AJnaTigTKrIbuR+xp8TwSok
         hWZc6MCuIz5kH79W2ys5z0nTqfw0aCiq8K2lZ7an9xx/2V+YtA9vL48MNHyFlIr/Mz
         7aMLwu9cfpBdweTgYWhKCnQtrmvLjkfyki3rRUsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Gow <davidgow@google.com>,
        Julius Werner <jwerner@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Evan Green <evgreen@chromium.org>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/229] firmware: google: Test spinlock on panic path to avoid lockups
Date:   Mon, 24 Oct 2022 13:31:05 +0200
Message-Id: <20221024113003.735381166@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit 3e081438b8e639cc76ef1a5ce0c1bd8a154082c7 ]

Currently the gsmi driver registers a panic notifier as well as
reboot and die notifiers. The callbacks registered are called in
atomic and very limited context - for instance, panic disables
preemption and local IRQs, also all secondary CPUs (not executing
the panic path) are shutdown.

With that said, taking a spinlock in this scenario is a dangerous
invitation for lockup scenarios. So, fix that by checking if the
spinlock is free to acquire in the panic notifier callback - if not,
bail-out and avoid a potential hang.

Fixes: 74c5b31c6618 ("driver: Google EFI SMI")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Julius Werner <jwerner@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Link: https://lore.kernel.org/r/20220909200755.189679-1-gpiccoli@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/gsmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 62337be07afc..2e3ef0eb6e82 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -661,6 +661,15 @@ static struct notifier_block gsmi_die_notifier = {
 static int gsmi_panic_callback(struct notifier_block *nb,
 			       unsigned long reason, void *arg)
 {
+
+	/*
+	 * Panic callbacks are executed with all other CPUs stopped,
+	 * so we must not attempt to spin waiting for gsmi_dev.lock
+	 * to be released.
+	 */
+	if (spin_is_locked(&gsmi_dev.lock))
+		return NOTIFY_DONE;
+
 	gsmi_shutdown_reason(GSMI_SHUTDOWN_PANIC);
 	return NOTIFY_DONE;
 }
-- 
2.35.1



