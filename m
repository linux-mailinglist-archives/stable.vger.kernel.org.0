Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCA34A419D
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359280AbiAaLEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358325AbiAaLDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:03:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F37C06173E;
        Mon, 31 Jan 2022 03:03:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 249AA604F5;
        Mon, 31 Jan 2022 11:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED652C340E8;
        Mon, 31 Jan 2022 11:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626984;
        bh=6eerhe6GybZvHheLPKe41Qbtj3MPhuJL4PFcSgB4LXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jd52qGaPbJLm8q6z+l7rvBtO7NAG9xL9whBdgxmtviehfFlDVHG2b28jeBfICuwz
         jCxFS+Y4gu28OLgViSnah9rJuCQH3+us4Js6MJx/OD/SRoInbE9nfNZ0eFdZfMAIah
         Ew0/iwnvZ+4fSbu9ebSl/TWqQH62/Ut+6IaofjLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 007/100] bpf: Guard against accessing NULL pt_regs in bpf_get_task_stack()
Date:   Mon, 31 Jan 2022 11:55:28 +0100
Message-Id: <20220131105220.683243480@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit b992f01e66150fc5e90be4a96f5eb8e634c8249e upstream.

task_pt_regs() can return NULL on powerpc for kernel threads. This is
then used in __bpf_get_stack() to check for user mode, resulting in a
kernel oops. Guard against this by checking return value of
task_pt_regs() before trying to obtain the call chain.

Fixes: fa28dcb82a38f8 ("bpf: Introduce helper bpf_get_task_stack()")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/d5ef83c361cc255494afd15ff1b4fb02a36e1dcf.1641468127.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/stackmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -664,13 +664,14 @@ BPF_CALL_4(bpf_get_task_stack, struct ta
 	   u32, size, u64, flags)
 {
 	struct pt_regs *regs;
-	long res;
+	long res = -EINVAL;
 
 	if (!try_get_task_stack(task))
 		return -EFAULT;
 
 	regs = task_pt_regs(task);
-	res = __bpf_get_stack(regs, task, NULL, buf, size, flags);
+	if (regs)
+		res = __bpf_get_stack(regs, task, NULL, buf, size, flags);
 	put_task_stack(task);
 
 	return res;


