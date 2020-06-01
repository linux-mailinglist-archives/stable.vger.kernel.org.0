Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7701EAB16
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbgFASOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730688AbgFASOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:14:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5925B2068D;
        Mon,  1 Jun 2020 18:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035253;
        bh=h18zp+cWiinCTN71tzoeaw/HPvo6f+dnoFyWsFESrDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qz+frb/b8TfnPeEEa8rYeQXhnJEw1gujDMgCDy2OqEOC5VjiUKpLXqE0QmJuU+f25
         m0FuWHGgB3D+v3fd/9xobBg/Icb88qfpxj+t+0DExqDBkBXcoGRHXxwl+gkRMoAYgd
         YBYZGwcdX1yuH5+HkFH4hIza5BQt27kQqKW/Jnnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Yibin <jiulong@linux.alibaba.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 076/177] csky: Fixup remove duplicate irq_disable
Date:   Mon,  1 Jun 2020 19:53:34 +0200
Message-Id: <20200601174055.232758124@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
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
index 007706328000..9718388448a4 100644
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



