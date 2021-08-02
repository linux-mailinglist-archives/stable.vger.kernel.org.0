Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130A73DD811
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhHBNti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234638AbhHBNsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:48:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65E9E60FA0;
        Mon,  2 Aug 2021 13:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912123;
        bh=qz3Qm9UzbMKkj0gqArsNkS5oZ2oF1xpS93lp+bgF/d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIy5tyheNfGyMxx75MgSxYjz7plKFlBoWoTehFZLuKnvMFvK4iOzhOJlTuv3f/1mq
         MQucYP19jBkGlmdPT0oZzHYOqnbbxN/Ic3JmGr8YqhuVT6dgh53/ocEKMYrokYYf+j
         R0rK0uaV5cqMZwN0DmATZTvi0TCwG+W76UuiKMgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/38] x86/asm: Ensure asm/proto.h can be included stand-alone
Date:   Mon,  2 Aug 2021 15:44:48 +0200
Message-Id: <20210802134335.651221435@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit f7b21a0e41171d22296b897dac6e4c41d2a3643c ]

Fix:

  ../arch/x86/include/asm/proto.h:14:30: warning: ‘struct task_struct’ declared \
    inside parameter list will not be visible outside of this definition or declaration
  long do_arch_prctl_64(struct task_struct *task, int option, unsigned long arg2);
                               ^~~~~~~~~~~

  .../arch/x86/include/asm/proto.h:40:34: warning: ‘struct task_struct’ declared \
    inside parameter list will not be visible outside of this definition or declaration
   long do_arch_prctl_common(struct task_struct *task, int option,
                                    ^~~~~~~~~~~

if linux/sched.h hasn't be included previously. This fixes a build error
when this header is used outside of the kernel tree.

 [ bp: Massage commit message. ]

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/b76b4be3-cf66-f6b2-9a6c-3e7ef54f9845@web.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/proto.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 6e81788a30c1..0eaca7a130c9 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -4,6 +4,8 @@
 
 #include <asm/ldt.h>
 
+struct task_struct;
+
 /* misc architecture specific prototypes */
 
 void syscall_init(void);
-- 
2.30.2



