Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155F4190E68
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCXNMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbgCXNMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:12:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 244D2208D6;
        Tue, 24 Mar 2020 13:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055520;
        bh=54Z3IOKPM0nkcNth/I4oXAr63XpSif6SnvZmDt9Fi5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myqAi8y5CcHo6kRH3gyU2p2xbJB0VC1uUMM96ECPWT3tQf+YD/3NTiJDcfwSZFoDn
         x0LluwOaZiu7/JtOPCdkOfczpJtsdrZWuRCbclnQc9az3nrlxHTRjuakUINOQRI1xR
         msn4sy5hWw/5UBL7eECMtwhTmP7lPcO6XMdb0GtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/65] powerpc: Include .BTF section
Date:   Tue, 24 Mar 2020 14:10:24 +0100
Message-Id: <20200324130757.172126709@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit cb0cc635c7a9fa8a3a0f75d4d896721819c63add ]

Selecting CONFIG_DEBUG_INFO_BTF results in the below warning from ld:
  ld: warning: orphan section `.BTF' from `.btf.vmlinux.bin.o' being placed in section `.BTF'

Include .BTF section in vmlinux explicitly to fix the same.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200220113132.857132-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vmlinux.lds.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index fd35eddf32669..d081d726ca8ea 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -322,6 +322,12 @@ SECTIONS
 		*(.branch_lt)
 	}
 
+#ifdef CONFIG_DEBUG_INFO_BTF
+	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {
+		*(.BTF)
+	}
+#endif
+
 	.opd : AT(ADDR(.opd) - LOAD_OFFSET) {
 		__start_opd = .;
 		KEEP(*(.opd))
-- 
2.20.1



