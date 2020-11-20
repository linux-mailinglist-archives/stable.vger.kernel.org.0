Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4630C2BA883
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgKTLIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:08:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbgKTLHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 187B22222F;
        Fri, 20 Nov 2020 11:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870455;
        bh=suwieUI2amzZ+2jPqMFCOt7OdVcu+vgsGc4eRAxG6dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPw/cwO8z2sIK+Z8bfzLm1ksckCE2zGTvLjuRQG1THxFrR7JIyy4aKvruBdcvTVov
         E5/9glOTD/Y13On1KKHiIdWAa9Z2VkNDi8v8DoPsMK+2tMKf/wWJ5lEc1j6F1a8UQg
         jaUFxouLfCzKf8qqJIT0ehTyO5npwIdzr5kgLZDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.9 12/14] perf/x86/intel/uncore: Fix Add BW copypasta
Date:   Fri, 20 Nov 2020 12:03:50 +0100
Message-Id: <20201120104541.766318038@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 1a8cfa24e21c2f154791f0cdd85fc28496918722 upstream.

gcc -Wextra points out a duplicate initialization of one array
member:

arch/x86/events/intel/uncore_snb.c:478:37: warning: initialized field overwritten [-Woverride-init]
  478 |  [SNB_PCI_UNCORE_IMC_DATA_READS]  = { SNB_UNCORE_PCI_IMC_DATA_WRITES_BASE,

The only sensible explanation is that a duplicate 'READS' was used
instead of the correct 'WRITES', so change it back.

Fixes: 24633d901ea4 ("perf/x86/intel/uncore: Add BW counters for GT, IA and IO breakdown")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201026215203.3893972-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/uncore_snb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -459,7 +459,7 @@ enum perf_snb_uncore_imc_freerunning_typ
 static struct freerunning_counters snb_uncore_imc_freerunning[] = {
 	[SNB_PCI_UNCORE_IMC_DATA_READS]		= { SNB_UNCORE_PCI_IMC_DATA_READS_BASE,
 							0x0, 0x0, 1, 32 },
-	[SNB_PCI_UNCORE_IMC_DATA_READS]		= { SNB_UNCORE_PCI_IMC_DATA_WRITES_BASE,
+	[SNB_PCI_UNCORE_IMC_DATA_WRITES]	= { SNB_UNCORE_PCI_IMC_DATA_WRITES_BASE,
 							0x0, 0x0, 1, 32 },
 	[SNB_PCI_UNCORE_IMC_GT_REQUESTS]	= { SNB_UNCORE_PCI_IMC_GT_REQUESTS_BASE,
 							0x0, 0x0, 1, 32 },


