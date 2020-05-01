Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7372B1C13D4
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbgEANdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbgEANdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:33:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E50E216FD;
        Fri,  1 May 2020 13:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339996;
        bh=n9OSzAOIsvEWYv3sAheV6vBFUKxRjlQxE4m3TbbWGOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTP6Y1kIjgH5X7hAE2mdoJi8i0tuWFbvL4SxL7oGCFBYwk+xkj2L+1POeL/neH+N8
         j3n7MFngktfpy85lR64yKQQa97rLm84J0pVvVpxf4PNWcDAAgWnNgAkuTE+n06K5wy
         0dUMRSxLM0Q4WeCPx5RAxZLbuWtcBC/1D5IHRdGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Kelly <martin@martingkelly.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 052/117] tools/vm: fix cross-compile build
Date:   Fri,  1 May 2020 15:21:28 +0200
Message-Id: <20200501131550.957971934@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
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


