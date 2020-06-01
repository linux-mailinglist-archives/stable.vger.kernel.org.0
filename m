Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1551EADB0
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgFASr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:47:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730693AbgFASIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:08:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E47EB2077D;
        Mon,  1 Jun 2020 18:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034892;
        bh=gMXF4fl4Dkfvmlk//jveDXjQXmPi/EG1P1zpQCrRKb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=masTlWTpVAAIP7fNw0JIOry7/Dq2Uf5hEXDgWtr/nbyC8ZjAhnKpkCQSQeqe0K+Sm
         chaKKbAnHjTqASfWHZ7tXqeEsA/w+v23FyH88pRdv80CAUcaB3bFYzVBwLYhyHvfjk
         zqKf8sRkFiJHISzvGLwG8JplG7xvGfQkL8ZWiTQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Yibin <jiulong@linux.alibaba.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/142] csky: Fixup remove duplicate irq_disable
Date:   Mon,  1 Jun 2020 19:53:35 +0200
Message-Id: <20200601174043.854249061@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Yibin <jiulong@linux.alibaba.com>

[ Upstream commit 6633a5aa8eb6bda70eb3a9837efd28a67ccc6e0a ]

Interrupt has been disabled in __schedule() with local_irq_disable()
and enabled in finish_task_switch->finish_lock_switch() with
local_irq_enabled(), So needn't to disable irq here.

Signed-off-by: Liu Yibin <jiulong@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/kernel/entry.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/csky/kernel/entry.S b/arch/csky/kernel/entry.S
index a7a5b67df898..65c55f22532a 100644
--- a/arch/csky/kernel/entry.S
+++ b/arch/csky/kernel/entry.S
@@ -318,8 +318,6 @@ ENTRY(__switch_to)
 
 	mfcr	a2, psr			/* Save PSR value */
 	stw	a2, (a3, THREAD_SR)	/* Save PSR in task struct */
-	bclri	a2, 6			/* Disable interrupts */
-	mtcr	a2, psr
 
 	SAVE_SWITCH_STACK
 
-- 
2.25.1



