Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4D71F35E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfEOMNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727384AbfEOLEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F32C62173C;
        Wed, 15 May 2019 11:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918292;
        bh=bqd2UTfZDqHEAn4E2azFb9BzEh78NhSGRxbkZcxUiYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8wxVAw053NKLvj3Go4ppo9aozHlEFT18CaB9ydHNvxf2OwsVTA/Vg7VGLk6Auvc4
         DMcy1/G007W8tFP60KK2jNq1l1nZahzEWdyzwUuI0N5z4UBaODZ7cAl0OXvFcJkW/w
         CCkBIguFUhJNCh8zA+5CQ17tFJh5k1Utm+pvBoCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "linuxppc-dev@ozlabs.org, mpe@ellerman.id.au, Diana Craciun" 
        <diana.craciun@nxp.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH 4.4 079/266] powerpc/fsl: Enable runtime patching if nospectre_v2 boot arg is used
Date:   Wed, 15 May 2019 12:53:06 +0200
Message-Id: <20190515090725.113850383@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

commit 3bc8ea8603ae4c1e09aca8de229ad38b8091fcb3 upstream.

If the user choses not to use the mitigations, replace
the code sequence with nops.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/setup_32.c |    1 +
 arch/powerpc/kernel/setup_64.c |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -323,6 +323,7 @@ void __init setup_arch(char **cmdline_p)
 	if ( ppc_md.progress ) ppc_md.progress("arch: exit", 0x3eab);
 
 	setup_barrier_nospec();
+	setup_spectre_v2();
 
 	paging_init();
 
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -737,6 +737,7 @@ void __init setup_arch(char **cmdline_p)
 		ppc_md.setup_arch();
 
 	setup_barrier_nospec();
+	setup_spectre_v2();
 
 	paging_init();
 


