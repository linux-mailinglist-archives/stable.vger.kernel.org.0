Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC98359B31
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhDIKHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234326AbhDIKFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:05:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 826C2611C9;
        Fri,  9 Apr 2021 10:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962526;
        bh=m3WSCXX5Kw2vdz5MGbNS6y5FBN/56oVpH302PasdTl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+eorReAHLs7TMG0hF81nhUo4uUalDvPejCPUQnQoAQW3UWCvY5l8HzU4XoEyG0CO
         aUGYjaIPITOzpl8kJT3uXM+fFeMz09YDPIJTsbtq3o6d4KJyzIOEC1hpk4pI5wT3wN
         QmZdEkNPoTlvUZQVDqx6lCSBIODxW2Zc6QdZShFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 39/45] tools/resolve_btfids: Set srctree variable unconditionally
Date:   Fri,  9 Apr 2021 11:54:05 +0200
Message-Id: <20210409095306.678151925@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 7962cb9b640af98ccb577f46c8b894319e6c5c20 ]

We want this clean to be called from tree's root Makefile,
which defines same srctree variable and that will screw
the make setup.

We actually do not use srctree being passed from outside,
so we can solve this by setting current srctree value
directly.

Also changing the way how srctree is initialized as suggested
by Andrri.

Also root Makefile does not define the implicit RM variable,
so adding RM initialization.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210205124020.683286-4-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/Makefile | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index be09ec4f03ff..bb9fa8de7e62 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -2,11 +2,7 @@
 include ../../scripts/Makefile.include
 include ../../scripts/Makefile.arch
 
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(CURDIR)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-endif
+srctree := $(abspath $(CURDIR)/../../../)
 
 ifeq ($(V),1)
   Q =
@@ -22,6 +18,7 @@ AR       = $(HOSTAR)
 CC       = $(HOSTCC)
 LD       = $(HOSTLD)
 ARCH     = $(HOSTARCH)
+RM      ?= rm
 
 OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
 
-- 
2.30.2



