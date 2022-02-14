Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3483A4B4C2B
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348684AbiBNKhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350286AbiBNKhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:37:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F3CA74C8;
        Mon, 14 Feb 2022 02:03:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3072260909;
        Mon, 14 Feb 2022 10:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E29C36AE7;
        Mon, 14 Feb 2022 10:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832988;
        bh=2BBZbbHHx50oBUEy83Jzex7N90VUJ1hapnj9wSM9Ri4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3FCBCQo8GOyAUE8T2z9g0B+FmxKQUCNFzf0FW9c4/vTrqvvjt1dmPq8IVBZ+SfNw
         eT5MWc9sppkHj/OBNKV9DYUjNCkOyEVCezEH9LMlbe3QPHyjoqCUlF44zcvIdtnsuc
         rpwbltlSxt5KWvGl6cu7GUA83wo86dY9qvgYEsM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Robert=20=C5=9Awi=C4=99cki?= <robert@swiecki.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.16 189/203] signal: HANDLER_EXIT should clear SIGNAL_UNKILLABLE
Date:   Mon, 14 Feb 2022 10:27:13 +0100
Message-Id: <20220214092516.670049720@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 5c72263ef2fbe99596848f03758ae2dc593adf2c upstream.

Fatal SIGSYS signals (i.e. seccomp RET_KILL_* syscall filter actions)
were not being delivered to ptraced pid namespace init processes. Make
sure the SIGNAL_UNKILLABLE doesn't get set for these cases.

Reported-by: Robert Święcki <robert@swiecki.net>
Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lore.kernel.org/lkml/878rui8u4a.fsf@email.froward.int.ebiederm.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1339,9 +1339,10 @@ force_sig_info_to_task(struct kernel_sig
 	}
 	/*
 	 * Don't clear SIGNAL_UNKILLABLE for traced tasks, users won't expect
-	 * debugging to leave init killable.
+	 * debugging to leave init killable. But HANDLER_EXIT is always fatal.
 	 */
-	if (action->sa.sa_handler == SIG_DFL && !t->ptrace)
+	if (action->sa.sa_handler == SIG_DFL &&
+	    (!t->ptrace || (handler == HANDLER_EXIT)))
 		t->signal->flags &= ~SIGNAL_UNKILLABLE;
 	ret = send_signal(sig, info, t, PIDTYPE_PID);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);


