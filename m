Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7EA12C73E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732437AbfL2Rz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732916AbfL2Rz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:55:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D22B2206DB;
        Sun, 29 Dec 2019 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642127;
        bh=G7t/WeT4GtFQazJhgcamZZ+TPFgjsgDlQCleZbc2HnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfKDosWvxvtmexSQfRw1OBct8WG8YaeX7qZDqIZcNsSWlLBfVTT8hLKsbsPcPdS7B
         F+UAhULCWcrppieqVslZFECjqAxCfIjqhVmUnWF8+wj1aR1ZR9zHJn8O9D2xEQf7dR
         X0q+2COgXYahlEiFVpnwkA2KE16BbTso+nSWlQjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 353/434] tools, bpf: Fix build for make -s tools/bpf O=<dir>
Date:   Sun, 29 Dec 2019 18:26:46 +0100
Message-Id: <20191229172725.418699596@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit a89b2cbf71d64b61e79bbe5cb7ff4664797eeaaf ]

Building selftests with 'make TARGETS=bpf kselftest' was fixed in commit
55d554f5d140 ("tools: bpf: Use !building_out_of_srctree to determine
srctree"). However, by updating $(srctree) in tools/bpf/Makefile for
in-tree builds only, we leave out the case where we pass an output
directory to build BPF tools, but $(srctree) is not set. This
typically happens for:

    $ make -s tools/bpf O=/tmp/foo
    Makefile:40: /tools/build/Makefile.feature: No such file or directory

Fix it by updating $(srctree) in the Makefile not only for out-of-tree
builds, but also if $(srctree) is empty.

Detected with test_bpftool_build.sh.

Fixes: 55d554f5d140 ("tools: bpf: Use !building_out_of_srctree to determine srctree")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Link: https://lore.kernel.org/bpf/20191119105626.21453-1-quentin.monnet@netronome.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index 5d1995fd369c..5535650800ab 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -16,7 +16,13 @@ CFLAGS += -D__EXPORTED_HEADERS__ -I$(srctree)/include/uapi -I$(srctree)/include
 # isn't set and when invoked from selftests build, where srctree
 # is set to ".". building_out_of_srctree is undefined for in srctree
 # builds
+ifeq ($(srctree),)
+update_srctree := 1
+endif
 ifndef building_out_of_srctree
+update_srctree := 1
+endif
+ifeq ($(update_srctree),1)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif
-- 
2.20.1



