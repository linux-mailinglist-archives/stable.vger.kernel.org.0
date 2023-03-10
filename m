Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50546B45FE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbjCJOj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbjCJOjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:39:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11DE468A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:38:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97CC0B822C4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D594CC4339E;
        Fri, 10 Mar 2023 14:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459136;
        bh=vU9G4G+Llss0uSFhzJX5rkdwUweQyaXWZsSvTMpTHb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tqhwyk7ZVFQ1tMNWum+Ni/Aj8fQll1Fx0Mh6XgJBt/HdkQXP/Nc14lvO1p/lFg7iQ
         FTranNoLvks+zODsI0zS6bdyUv4IUIZvT6LSn5m7ljsl6mnZyNGRjuHSo12k/aN/7X
         HuTkr+5rp8DkVJTIdXIxwdocEpy+o8E89Im8VvYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Dmitry V. Levin" <ldv@strace.io>,
        Elvira Khabirova <lineprinter0@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 261/357] mips: fix syscall_get_nr
Date:   Fri, 10 Mar 2023 14:39:10 +0100
Message-Id: <20230310133746.245638444@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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


