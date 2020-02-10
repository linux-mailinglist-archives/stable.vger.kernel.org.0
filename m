Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC01576C1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbgBJMzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:55:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729450AbgBJMlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:50 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA02120873;
        Mon, 10 Feb 2020 12:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338509;
        bh=dwcmcIpGV9GdIWie3gTAFRZcpkR3vYKkvQkwcTyPkDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLKRFVoCs+1ZYYqchOQfanYTqFIBlWiKenSC0Aictv2KnAe8E1M1J88iyiiHqeV8V
         5htre7USAWt/bD54dY4GnneG3hlr3e2TTbRXbpSFNgfI0EmDH097rHU3iT3Syerb4s
         QCDRxJF/oNuUWrBCLL/su81lCTC6vkh+KfrY6R9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.5 313/367] bpf: Fix trampoline usage in preempt
Date:   Mon, 10 Feb 2020 04:33:46 -0800
Message-Id: <20200210122452.143886749@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit 05d57f1793fb250c85028c9952c3720010baa853 upstream.

Though the second half of trampoline page is unused a task could be
preempted in the middle of the first half of trampoline and two
updates to trampoline would change the code from underneath the
preempted task. Hence wait for tasks to voluntarily schedule or go
to userspace. Add similar wait before freeing the trampoline.

Fixes: fec56f5890d9 ("bpf: Introduce BPF trampoline")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/bpf/20200121032231.3292185-1-ast@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/trampoline.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -150,6 +150,14 @@ static int bpf_trampoline_update(struct
 	if (fexit_cnt)
 		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
 
+	/* Though the second half of trampoline page is unused a task could be
+	 * preempted in the middle of the first half of trampoline and two
+	 * updates to trampoline would change the code from underneath the
+	 * preempted task. Hence wait for tasks to voluntarily schedule or go
+	 * to userspace.
+	 */
+	synchronize_rcu_tasks();
+
 	err = arch_prepare_bpf_trampoline(new_image, &tr->func.model, flags,
 					  fentry, fentry_cnt,
 					  fexit, fexit_cnt,
@@ -240,6 +248,8 @@ void bpf_trampoline_put(struct bpf_tramp
 		goto out;
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
 		goto out;
+	/* wait for tasks to get out of trampoline before freeing it */
+	synchronize_rcu_tasks();
 	bpf_jit_free_exec(tr->image);
 	hlist_del(&tr->hlist);
 	kfree(tr);


