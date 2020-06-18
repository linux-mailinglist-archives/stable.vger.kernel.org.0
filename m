Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E951FE789
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgFRCls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgFRBMR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB20221924;
        Thu, 18 Jun 2020 01:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442736;
        bh=ste0z3yUk+LG1qt3/ESUU8jN0ibjLxgrmCIBBS5yR60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spS7tZXzjyxJUIWK829iDEK4uVxtqsMOPr3Yu0xq6ZJN7RLBmjl4HPnIObvYK8nup
         CwjsBoGuqDocSl3+H3EnjbAJur/TC8hNm6Ot98SwFJH+/2bEVDEh4uoW81WM11sYd4
         m/TuQvnWks/n7NQD6BwpPsygzoHbpVwTX8sKlr5Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 191/388] um: do not evaluate compiler's library path when cleaning
Date:   Wed, 17 Jun 2020 21:04:48 -0400
Message-Id: <20200618010805.600873-191-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 7e49afc03212010d0ee27532a75cfeb0125bd868 ]

Since commit a83e4ca26af8 ("kbuild: remove cc-option switch from
-Wframe-larger-than="), 'make ARCH=um clean' emits an error message
as follows:

  $ make ARCH=um clean
  gcc: error: missing argument to '-Wframe-larger-than='

We do not care compiler flags when cleaning.

Use the '=' operator for lazy expansion because we do not use
LDFLAGS_pcap.o or LDFLAGS_vde.o when cleaning.

While I was here, I removed the redundant -r option because it
already exists in the recipe.

Fixes: a83e4ca26af8 ("kbuild: remove cc-option switch from -Wframe-larger-than=")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com> [build]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/Makefile b/arch/um/drivers/Makefile
index a290821e355c..2a249f619467 100644
--- a/arch/um/drivers/Makefile
+++ b/arch/um/drivers/Makefile
@@ -18,9 +18,9 @@ ubd-objs := ubd_kern.o ubd_user.o
 port-objs := port_kern.o port_user.o
 harddog-objs := harddog_kern.o harddog_user.o
 
-LDFLAGS_pcap.o := -r $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libpcap.a)
+LDFLAGS_pcap.o = $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libpcap.a)
 
-LDFLAGS_vde.o := -r $(shell $(CC) $(CFLAGS) -print-file-name=libvdeplug.a)
+LDFLAGS_vde.o = $(shell $(CC) $(CFLAGS) -print-file-name=libvdeplug.a)
 
 targets := pcap_kern.o pcap_user.o vde_kern.o vde_user.o
 
-- 
2.25.1

