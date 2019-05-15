Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA6121F3EB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfEOLB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbfEOLB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:01:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04DD420881;
        Wed, 15 May 2019 11:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918118;
        bh=2/AKQ+MxCps52AkGgW+EsKdfdyFBNC/Ngk5AYI4VJ+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1gBclbkuyqt+0UqPv1UKma5+FmaPN+9wwCW/tcCudpxqqGoD5Bo3NGPAKcvfyFCw
         59TyVDEK4qJMs4QHjdxtFaU8gxa1mrQAIfXWlOFDSP26nfDazDjipnhOd+fBee2Wzq
         05eUWQRaReseDx2YGex70E2ljlED0s6QHKi5bKgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 013/266] powerpc/xmon: Add RFI flush related fields to paca dump
Date:   Wed, 15 May 2019 12:52:00 +0200
Message-Id: <20190515090723.083894420@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

commit 274920a3ecd5f43af0cc380bc0a9ee73a52b9f8a upstream.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/xmon/xmon.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -2144,6 +2144,10 @@ static void dump_one_paca(int cpu)
 	DUMP(p, slb_cache_ptr, "x");
 	for (i = 0; i < SLB_CACHE_ENTRIES; i++)
 		printf(" slb_cache[%d]:        = 0x%016lx\n", i, p->slb_cache[i]);
+
+	DUMP(p, rfi_flush_fallback_area, "px");
+	DUMP(p, l1d_flush_congruence, "llx");
+	DUMP(p, l1d_flush_sets, "llx");
 #endif
 	DUMP(p, dscr_default, "llx");
 #ifdef CONFIG_PPC_BOOK3E


