Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE3F329031
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242728AbhCAUDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242472AbhCATxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5148C6512F;
        Mon,  1 Mar 2021 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621215;
        bh=1XDxfEGgGx5MVrHkU363Vi6rCoGbiFF4L/r0kGh1NmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdUfSE/Zio8ct1sTZ4Nb3ZXrX02o6d+sLOqXPtq092v5LglbZzqg+ZvdxWXcnSr1+
         TgfqZ+SW8FIbk9yUsqNrZiNb62NoPL33XTL/W4e9zSdjbSjGQHntir/lhK4oH6qS7k
         s8H3M7FSLv0JQWEyIyj45GP6Uinz9FMhu92JHRY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 395/775] powerpc: Fix build error in paravirt.h
Date:   Mon,  1 Mar 2021 17:09:23 +0100
Message-Id: <20210301161221.114669648@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 9899a56f1eca964cd0de21008a9fa1523a571231 ]

./arch/powerpc/include/asm/paravirt.h:83:44: error: implicit declaration
of function 'smp_processor_id'; did you mean 'raw_smp_processor_id'?

smp_processor_id is defined in linux/smp.h but it is not included.

The build error happens only when the patch is applied to 5.3 kernel but
it only works by chance in mainline.

Fixes: ca3f969dcb11 ("powerpc/paravirt: Use is_kvm_guest() in vcpu_is_preempted()")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210120132838.15589-1-msuchanek@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/paravirt.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/include/asm/paravirt.h b/arch/powerpc/include/asm/paravirt.h
index edc08f04aef77..5d1726bb28e79 100644
--- a/arch/powerpc/include/asm/paravirt.h
+++ b/arch/powerpc/include/asm/paravirt.h
@@ -10,6 +10,7 @@
 #endif
 
 #ifdef CONFIG_PPC_SPLPAR
+#include <linux/smp.h>
 #include <asm/kvm_guest.h>
 #include <asm/cputhreads.h>
 
-- 
2.27.0



