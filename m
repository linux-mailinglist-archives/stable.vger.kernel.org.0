Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EC71BCA54
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbgD1Shx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729230AbgD1Shw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:37:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C7020575;
        Tue, 28 Apr 2020 18:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099072;
        bh=n9OSzAOIsvEWYv3sAheV6vBFUKxRjlQxE4m3TbbWGOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NT8TMPyRuYsBq4Af3Cje2EoluaMxPdstsdl3LnZB/GTkb9EgEaJCxu0pBhhGO3NvX
         grQsUhYkARZml7G+NjCAeFlE/jKVv17lxAtgzYx/yTilxSSHV5/Hxd8pBA37H443aU
         NPtYSAhh2q5u23a26d2QJPHR5sQsyYZduaZB3Mz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Kelly <martin@martingkelly.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 093/131] tools/vm: fix cross-compile build
Date:   Tue, 28 Apr 2020 20:25:05 +0200
Message-Id: <20200428182236.628721994@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit cf01699ee220c38099eb3e43ce3d10690c8b7060 upstream.

Commit 7ed1c1901fe5 ("tools: fix cross-compile var clobbering") moved
the setup of the CC variable to tools/scripts/Makefile.include to make
the behavior consistent across all the tools Makefiles.

As the vm tools missed the include we end up with the wrong CC in a
cross-compiling evironment.

Fixes: 7ed1c1901fe5 (tools: fix cross-compile var clobbering)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Kelly <martin@martingkelly.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200416104748.25243-1-l.stach@pengutronix.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/vm/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/vm/Makefile
+++ b/tools/vm/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm tools
 #
+include ../scripts/Makefile.include
+
 TARGETS=page-types slabinfo page_owner_sort
 
 LIB_DIR = ../lib/api


