Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEBA65BBEB
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbjACIRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237089AbjACIQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3BCD74
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 004BA611DD
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB18C433EF;
        Tue,  3 Jan 2023 08:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733806;
        bh=25qC0ZgW4q78Lon5SJsKaotj2wODqN9QDzEUbd20nVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1jV+toHfnmeSC5Gftkva4VYQ7aRwwzIIb2+bg9EWXhEi1DqUF5C4T2/WRxsopqks
         hEHy2FHMLRbkwWC+Y23X61cJYvtPFwjR+pRBlFltlGwf8Q7TvOHoVSeHCSk1GRNB/x
         rbgs73A5zSHwRCiBs7zgeUXipikOgp4W3K1PGsbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bruno Goncalves <bgoncalv@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 50/63] arch: ensure parisc/powerpc handle PF_IO_WORKER in copy_thread()
Date:   Tue,  3 Jan 2023 09:14:20 +0100
Message-Id: <20230103081311.593037298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 0100e6bbdbb79404e56939313662b42737026574 ]

In the arch addition of PF_IO_WORKER, I missed parisc and powerpc for
some reason. Fix that up, ensuring they handle PF_IO_WORKER like they do
PF_KTHREAD in copy_thread().

Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Fixes: 4727dc20e042 ("arch: setup PF_IO_WORKER threads like PF_KTHREAD")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/process.c  |    2 +-
 arch/powerpc/kernel/process.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -200,7 +200,7 @@ copy_thread(unsigned long clone_flags, u
 	extern void * const ret_from_kernel_thread;
 	extern void * const child_return;
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* kernel thread */
 		memset(cregs, 0, sizeof(struct pt_regs));
 		if (!usp) /* idle thread */
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1684,7 +1684,7 @@ int copy_thread(unsigned long clone_flag
 	/* Copy registers */
 	sp -= sizeof(struct pt_regs);
 	childregs = (struct pt_regs *) sp;
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* kernel thread */
 		memset(childregs, 0, sizeof(struct pt_regs));
 		childregs->gpr[1] = sp + sizeof(struct pt_regs);


