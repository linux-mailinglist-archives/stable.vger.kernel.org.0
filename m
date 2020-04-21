Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9471B1B29
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 03:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgDUBOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 21:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgDUBOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 21:14:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96D272084D;
        Tue, 21 Apr 2020 01:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587431664;
        bh=YMstpxfsfFRLlO2TKtEJkhcj014naAzBdsVjkBFsNLs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aVo+ViQzf/6+C70JotzOKeGevsmkFNyqqYskbcUrMrPAXQwHOBgm6QmQxleyv/Asl
         HaxUmobPO8XCy/Xl2ZGeVfSdINUUItz5MVdY/4jk3TQmr0oJC7WBw/phb+33slvMqk
         bCDgO9POLdW4MfrEvfiwWw9w1cJDov9j4D4W5vFY=
Date:   Mon, 20 Apr 2020 18:14:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, l.stach@pengutronix.de,
        linux-mm@kvack.org, martin@martingkelly.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 15/15] tools/vm: fix cross-compile build
Message-ID: <20200421011423.Y6ao1IZ3G%akpm@linux-foundation.org>
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>
Subject: tools/vm: fix cross-compile build

7ed1c1901fe5 (tools: fix cross-compile var clobbering) moved the setup of
the CC variable to tools/scripts/Makefile.include to make the behavior
consistent across all the tools Makefiles.  As the vm tools missed the
include we end up with the wrong CC in a cross-compiling evironment.

Link: http://lkml.kernel.org/r/20200416104748.25243-1-l.stach@pengutronix.de
Fixes: 7ed1c1901fe5 (tools: fix cross-compile var clobbering)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Cc: Martin Kelly <martin@martingkelly.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/vm/Makefile~tools-vm-fix-cross-compile-build
+++ a/tools/vm/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm tools
 #
+include ../scripts/Makefile.include
+
 TARGETS=page-types slabinfo page_owner_sort
 
 LIB_DIR = ../lib/api
_
