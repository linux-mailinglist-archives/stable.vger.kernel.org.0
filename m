Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA1F4CFAA5
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiCGKW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240860AbiCGKTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:19:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2582C7307D;
        Mon,  7 Mar 2022 01:58:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFA5160F34;
        Mon,  7 Mar 2022 09:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6A9C340E9;
        Mon,  7 Mar 2022 09:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647082;
        bh=hrAY67R9IIspm1ak8n4aPSsN/xkw0dD50DbrjpAhmb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGt1xkTXuMpEz2QfU5d8OO3nNJM7xxwJsLWOYdk9ya18xsghGrcjETCzPHk0iS0Fx
         ejOf5Nhqj8pUiheqYKOeUL6Cs6SBcibTvF9bY9P53h2xTvcjCh+c76NJRb/cgQyqb5
         raXnDvir1VDg6xPpPzjq664SYbakDQoH5Geg2rqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.16 185/186] s390/ftrace: fix ftrace_caller/ftrace_regs_caller generation
Date:   Mon,  7 Mar 2022 10:20:23 +0100
Message-Id: <20220307091659.254220474@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit 9fa881f7e3c74ce6626d166bca9397e5d925937f upstream.

ftrace_caller was used for both ftrace_caller and ftrace_regs_caller,
which means that the target address of the hotpatch trampoline was
never updated.

With commit 894979689d3a ("s390/ftrace: provide separate
ftrace_caller/ftrace_regs_caller implementations") a separate
ftrace_regs_caller entry point was implemeted, however it was
forgotten to implement the necessary changes for ftrace_modify_call
and ftrace_make_call, where the branch target has to be modified
accordingly.

Therefore add the missing code now.

Fixes: 894979689d3a ("s390/ftrace: provide separate ftrace_caller/ftrace_regs_caller implementations")
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/ftrace.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -159,9 +159,38 @@ int ftrace_init_nop(struct module *mod,
 	return 0;
 }
 
+static struct ftrace_hotpatch_trampoline *ftrace_get_trampoline(struct dyn_ftrace *rec)
+{
+	struct ftrace_hotpatch_trampoline *trampoline;
+	struct ftrace_insn insn;
+	s64 disp;
+	u16 opc;
+
+	if (copy_from_kernel_nofault(&insn, (void *)rec->ip, sizeof(insn)))
+		return ERR_PTR(-EFAULT);
+	disp = (s64)insn.disp * 2;
+	trampoline = (void *)(rec->ip + disp);
+	if (get_kernel_nofault(opc, &trampoline->brasl_opc))
+		return ERR_PTR(-EFAULT);
+	if (opc != 0xc015)
+		return ERR_PTR(-EINVAL);
+	return trampoline;
+}
+
 int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 		       unsigned long addr)
 {
+	struct ftrace_hotpatch_trampoline *trampoline;
+	u64 old;
+
+	trampoline = ftrace_get_trampoline(rec);
+	if (IS_ERR(trampoline))
+		return PTR_ERR(trampoline);
+	if (get_kernel_nofault(old, &trampoline->interceptor))
+		return -EFAULT;
+	if (old != old_addr)
+		return -EINVAL;
+	s390_kernel_write(&trampoline->interceptor, &addr, sizeof(addr));
 	return 0;
 }
 
@@ -188,6 +217,12 @@ static void brcl_enable(void *brcl)
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
+	struct ftrace_hotpatch_trampoline *trampoline;
+
+	trampoline = ftrace_get_trampoline(rec);
+	if (IS_ERR(trampoline))
+		return PTR_ERR(trampoline);
+	s390_kernel_write(&trampoline->interceptor, &addr, sizeof(addr));
 	brcl_enable((void *)rec->ip);
 	return 0;
 }


