Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE6F12EC41
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgABWQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbgABWQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F8AA21582;
        Thu,  2 Jan 2020 22:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003404;
        bh=xe3Z79I60jJdx7YuK/c1laM9GG6/6JpZJqjcyjGH+IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3PH4OTfxiIF/WCuBt/pmEsLHsgSL3nO5P9Lyvzy5NMEZFHWUVvX/m+hyF+hss036
         1adPTU/LIKfLagmjbL4NH5Cv25BmmtX0MQZiNL2/qQjLkoD7iUXrv2Mmcb14Ma3PJ5
         UNSC6K+FTFpRlWQ9fxdYUEnFzv5xMD0xIjkGnkzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/191] s390/unwind: filter out unreliable bogus %r14
Date:   Thu,  2 Jan 2020 23:06:43 +0100
Message-Id: <20200102215842.770802524@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit bf018ee644897d7982e1b8dd8b15e97db6e1a4da ]

Currently unwinder unconditionally returns %r14 from the first frame
pointed by %r15 from pt_regs. A task could be interrupted when a function
already allocated this frame (if it needs it) for its callees or to
store local variables. In that case this frame would contain random
values from stack or values stored there by a callee. As we are only
interested in %r14 to get potential return address, skip bogus return
addresses which doesn't belong to kernel text.

This helps to avoid duplicating filtering logic in unwider users, most
of which use unwind_get_return_address() and would choke on bogus 0
address returned by it otherwise.

Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/unwind_bc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/s390/kernel/unwind_bc.c b/arch/s390/kernel/unwind_bc.c
index a8204f952315..6e609b13c0ce 100644
--- a/arch/s390/kernel/unwind_bc.c
+++ b/arch/s390/kernel/unwind_bc.c
@@ -60,6 +60,11 @@ bool unwind_next_frame(struct unwind_state *state)
 		ip = READ_ONCE_NOCHECK(sf->gprs[8]);
 		reliable = false;
 		regs = NULL;
+		if (!__kernel_text_address(ip)) {
+			/* skip bogus %r14 */
+			state->regs = NULL;
+			return unwind_next_frame(state);
+		}
 	} else {
 		sf = (struct stack_frame *) state->sp;
 		sp = READ_ONCE_NOCHECK(sf->back_chain);
-- 
2.20.1



