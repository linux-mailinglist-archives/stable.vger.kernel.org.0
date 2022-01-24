Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEC649A337
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365029AbiAXXuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:50:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47644 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455421AbiAXVfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F37B81188;
        Mon, 24 Jan 2022 21:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBDDC340E4;
        Mon, 24 Jan 2022 21:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060121;
        bh=x1i3tJn8RukdvFNMi9ic1oCJIRWOznFLbUVdgmlY8RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfyJ5ae5VbX5nmYkJzEt4apwe65A/v/Gk7UeQBkLW1LubKBWGkikWO+YN+TaLvRkd
         NJ5pnzmbtP7arID/7QX12VtdD309yJrA0cY24pBin+3lk1WhEeEE5gCrDUNbsC9Kpn
         h4rvWuQqjfRNBSloqg5ZwLh8UkXS8o9bFeo1e2NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.16 0847/1039] x86/mce: Check regs before accessing it
Date:   Mon, 24 Jan 2022 19:43:56 +0100
Message-Id: <20220124184153.757647457@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 1acd85feba81084fcef00b73fc1601e42b77c5d8 upstream.

Commit in Fixes accesses pt_regs before checking whether it is NULL or
not. Make sure the NULL pointer check happens first.

Fixes: 0a5b288e85bb ("x86/mce: Prevent severity computation from being instrumented")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20211217102029.GA29708@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/severity.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -222,6 +222,9 @@ static bool is_copy_from_user(struct pt_
 	struct insn insn;
 	int ret;
 
+	if (!regs)
+		return false;
+
 	if (copy_from_kernel_nofault(insn_buf, (void *)regs->ip, MAX_INSN_SIZE))
 		return false;
 
@@ -283,7 +286,7 @@ static noinstr int error_context(struct
 	switch (fixup_type) {
 	case EX_TYPE_UACCESS:
 	case EX_TYPE_COPY:
-		if (!regs || !copy_user)
+		if (!copy_user)
 			return IN_KERNEL;
 		m->kflags |= MCE_IN_KERNEL_COPYIN;
 		fallthrough;


