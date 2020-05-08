Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870D11CAF97
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgEHMnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbgEHMnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D0FF24978;
        Fri,  8 May 2020 12:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941790;
        bh=smFAuBHLTRz37AEYrNWRHAMOMWPXthVuRKWBykcAnm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ourY5tL7A0+JrWgPiNWCr9l0uQxWJcMCc/P5XmR2rRApWdROc8Zg5u1yOPh83+4vA
         uzJoMjQNdGqLScHwQ7NmOmm0rVbfKtjRCy86qkXinF+dHyMKVCiidlr3BiYxitNWBN
         8vQu+iaiV8cNq9TbdACLvspR5PhIErlIoohcs5Yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 146/312] perf tools: Fix perf regs mask generation
Date:   Fri,  8 May 2020 14:32:17 +0200
Message-Id: <20200508123134.729512088@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit f47822078dece7189cad0a5f472f148e5e916736 upstream.

On some architectures (powerpc in particular), the number of registers
exceeds what can be represented in an integer bitmask. Ensure we
generate the proper bitmask on such platforms.

Fixes: 71ad0f5e4 ("perf tools: Support for DWARF CFI unwinding on post processing")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/perf_regs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/perf/util/perf_regs.c
+++ b/tools/perf/util/perf_regs.c
@@ -12,18 +12,18 @@ int perf_reg_value(u64 *valp, struct reg
 	int i, idx = 0;
 	u64 mask = regs->mask;
 
-	if (regs->cache_mask & (1 << id))
+	if (regs->cache_mask & (1ULL << id))
 		goto out;
 
-	if (!(mask & (1 << id)))
+	if (!(mask & (1ULL << id)))
 		return -EINVAL;
 
 	for (i = 0; i < id; i++) {
-		if (mask & (1 << i))
+		if (mask & (1ULL << i))
 			idx++;
 	}
 
-	regs->cache_mask |= (1 << id);
+	regs->cache_mask |= (1ULL << id);
 	regs->cache_regs[id] = regs->regs[idx];
 
 out:


