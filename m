Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86A369CE1F
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjBTN4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjBTN4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:56:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F6B1E9DE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:55:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CCD160E9E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934C4C433D2;
        Mon, 20 Feb 2023 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901358;
        bh=H6WClBhaOmnPGQ+namoQkb5VssSkQFJ8BD7wGkIhsBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L18IgpP5ymAFjrYLR4ZJD0KMXBdLf+eXKIL9CqSJ5CSIHemH2nct8Ljcp5GIa6vVC
         j5bfB1pUmM23edyFakQpPjhpV3I4sUEf5Nx85wjASOJsnRiGxtxJqFrnV5Fh4cXd2X
         ccXWFubK53Vp0PPx6yfLeMz9cn3eTLLcrsqZq3+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH 5.10 17/57] [PATCH v2 1/1] s390/signal: fix endless loop in do_signal
Date:   Mon, 20 Feb 2023 14:36:25 +0100
Message-Id: <20230220133549.972747392@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

No upstream commit exists: the problem addressed here is that 'commit
75309018a24d ("s390: add support for TIF_NOTIFY_SIGNAL")' was backported
to 5.10. This commit is broken, but nobody noticed upstream, since
shortly after s390 converted to generic entry with 'commit 56e62a737028
("s390: convert to generic entry")', which implicitly fixed the problem
outlined below.

Thread flag is set to TIF_NOTIFY_SIGNAL for io_uring work.  The io work
user or syscall calls do_signal when either one of the TIF_SIGPENDING or
TIF_NOTIFY_SIGNAL flag is set.  However, do_signal does consider only
TIF_SIGPENDING signal and ignores TIF_NOTIFY_SIGNAL condition.  This
means get_signal is never invoked  for TIF_NOTIFY_SIGNAL and hence the
flag is not cleared, which results in an endless do_signal loop.

Reference: 'commit 788d0824269b ("io_uring: import 5.15-stable io_uring")'
Fixes: 75309018a24d ("s390: add support for TIF_NOTIFY_SIGNAL")
Cc: stable@vger.kernel.org  # 5.10.162
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -472,7 +472,7 @@ void do_signal(struct pt_regs *regs)
 	current->thread.system_call =
 		test_pt_regs_flag(regs, PIF_SYSCALL) ? regs->int_code : 0;
 
-	if (test_thread_flag(TIF_SIGPENDING) && get_signal(&ksig)) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
 		if (current->thread.system_call) {
 			regs->int_code = current->thread.system_call;


