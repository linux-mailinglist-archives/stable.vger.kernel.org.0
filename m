Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB68214B728
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgA1OLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:32806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbgA1OLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:11:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2950424685;
        Tue, 28 Jan 2020 14:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220709;
        bh=C+pc8y2pEMMfOnYaCwAgQSs53kmqKNheVu3WOtWPoJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1Wfb8eaYV2wA4RYySgugp3tlaz7x8A87M/udf64/JWUL5bHxzzbZn2+7eQI0WZKT
         Q+y7TSzAT4aHkM1+vPcrze/dRNLBl7tGsRcJ8P/PMftlFiEZ9RiaFPTiBRQm/9xwZg
         o02FAjlAOnjmdgBqI/zBu4xDSM2BF+iogA1Rvoos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 078/183] powerpc: vdso: Make vdso32 installation conditional in vdso_install
Date:   Tue, 28 Jan 2020 15:04:57 +0100
Message-Id: <20200128135837.727519035@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit ff6d27823f619892ab96f7461764840e0d786b15 ]

The 32-bit vDSO is not needed and not normally built for 64-bit
little-endian configurations.  However, the vdso_install target still
builds and installs it.  Add the same config condition as is normally
used for the build.

Fixes: e0d005916994 ("powerpc/vdso: Disable building the 32-bit VDSO ...")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index d7eb035a9c960..65cb22541c660 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -350,7 +350,9 @@ vdso_install:
 ifeq ($(CONFIG_PPC64),y)
 	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso64 $@
 endif
+ifdef CONFIG_VDSO32
 	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso32 $@
+endif
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
-- 
2.20.1



