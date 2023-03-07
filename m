Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303546AF280
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbjCGSxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjCGSxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:53:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FB29BE3B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E330ACE1C84
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB2EC433D2;
        Tue,  7 Mar 2023 18:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214456;
        bh=vU9G4G+Llss0uSFhzJX5rkdwUweQyaXWZsSvTMpTHb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQAS6zb54nzYxSl7QTfErnef2soeaD/7+MB2xnIaQ2ERJOSk4oHyA3n9Oi/LglCf4
         mOLvPKg4lKhXEg76TDzTQD4JSyIFdVw1pgRjCcfyoHiT7lW51939J/wKNQK37NPFmu
         w7+8ZuPR/jQr7tfNhOZe/TRElyedL/c6lSE2DWlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Dmitry V. Levin" <ldv@strace.io>,
        Elvira Khabirova <lineprinter0@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 827/885] mips: fix syscall_get_nr
Date:   Tue,  7 Mar 2023 18:02:41 +0100
Message-Id: <20230307170037.793144056@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Elvira Khabirova <lineprinter0@gmail.com>

commit 85cc91e2ba4262a602ec65e2b76c4391a9e60d3d upstream.

The implementation of syscall_get_nr on mips used to ignore the task
argument and return the syscall number of the calling thread instead of
the target thread.

The bug was exposed to user space by commit 201766a20e30f ("ptrace: add
PTRACE_GET_SYSCALL_INFO request") and detected by strace test suite.

Link: https://github.com/strace/strace/issues/235
Fixes: c2d9f1775731 ("MIPS: Fix syscall_get_nr for the syscall exit tracing.")
Cc: <stable@vger.kernel.org> # v3.19+
Co-developed-by: Dmitry V. Levin <ldv@strace.io>
Signed-off-by: Dmitry V. Levin <ldv@strace.io>
Signed-off-by: Elvira Khabirova <lineprinter0@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/syscall.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@ -38,7 +38,7 @@ static inline bool mips_syscall_is_indir
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
-	return current_thread_info()->syscall;
+	return task_thread_info(task)->syscall;
 }
 
 static inline void mips_syscall_update_nr(struct task_struct *task,


