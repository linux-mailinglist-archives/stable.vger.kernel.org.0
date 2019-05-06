Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673A414C1A
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfEFOgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbfEFOgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:36:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABC19214AE;
        Mon,  6 May 2019 14:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153381;
        bh=rHNcloRpi8MdqFrW1AsHD5SGdgV/ZC5FEWmrzJklROM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pAuwVG0H3c4LHhTw/WdInxCAqJOJzb1RdmcrHN4XodGpIcaRISnxfFFMPGvg3P0B
         r4HgXRiBuvE8fNgyVYmhtIAlbkER8tPTbUsSi4vdvnwlFqkCtol4QiBB+GeM9BC/jX
         dCSjukyh3te87EDRexMnfWoNrnS8EoQHQj6+DzBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>,
        Wei Li <liwei391@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 067/122] arm64: fix wrong check of on_sdei_stack in nmi context
Date:   Mon,  6 May 2019 16:32:05 +0200
Message-Id: <20190506143100.998182603@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1c41860864c8ae0387ef7d44f0000e99cbb2e06d ]

When doing unwind_frame() in the context of pseudo nmi (need enable
CONFIG_ARM64_PSEUDO_NMI), reaching the bottom of the stack (fp == 0,
pc != 0), function on_sdei_stack() will return true while the sdei acpi
table is not inited in fact. This will cause a "NULL pointer dereference"
oops when going on.

Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm64/kernel/sdei.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
index 5ba4465e44f0..ea94cf8f9dc6 100644
--- a/arch/arm64/kernel/sdei.c
+++ b/arch/arm64/kernel/sdei.c
@@ -94,6 +94,9 @@ static bool on_sdei_normal_stack(unsigned long sp, struct stack_info *info)
 	unsigned long low = (unsigned long)raw_cpu_read(sdei_stack_normal_ptr);
 	unsigned long high = low + SDEI_STACK_SIZE;
 
+	if (!low)
+		return false;
+
 	if (sp < low || sp >= high)
 		return false;
 
@@ -111,6 +114,9 @@ static bool on_sdei_critical_stack(unsigned long sp, struct stack_info *info)
 	unsigned long low = (unsigned long)raw_cpu_read(sdei_stack_critical_ptr);
 	unsigned long high = low + SDEI_STACK_SIZE;
 
+	if (!low)
+		return false;
+
 	if (sp < low || sp >= high)
 		return false;
 
-- 
2.20.1



