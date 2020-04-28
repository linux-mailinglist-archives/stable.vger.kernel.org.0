Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CCB1BCAB1
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgD1Svo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729392AbgD1Sg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:36:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59E2920575;
        Tue, 28 Apr 2020 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099018;
        bh=vfAHXFAy/Y/q0wkxF7wa7tNLX+mcFSUdnGqu55sY0aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khMehWWQElCGPo2Wrc38H4uNj2uB6P7VjgnK9LNa5vCjVZ+bJ2yU2H44JQao0H3t0
         VYj6yRC8fnNyt3nWZNE9kMmLaIMCodVW1Esyp7eB58vocSI9Xj9/vooWUnjkqwt5YT
         ISeeOpEB9R3uwwQuZ/zcArpbNtCzw3Wqp2pBCj1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/168] libbpf: Fix readelf output parsing on powerpc with recent binutils
Date:   Tue, 28 Apr 2020 20:23:40 +0200
Message-Id: <20200428182237.685189790@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit 3464afdf11f9a1e031e7858a05351ceca1792fea ]

On powerpc with recent versions of binutils, readelf outputs an extra
field when dumping the symbols of an object file. For example:

    35: 0000000000000838    96 FUNC    LOCAL  DEFAULT [<localentry>: 8]     1 btf_is_struct

The extra "[<localentry>: 8]" prevents the GLOBAL_SYM_COUNT variable to
be computed correctly and causes the check_abi target to fail.

Fix that by looking for the symbol name in the last field instead of the
8th one. This way it should also cope with future extra fields.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/bpf/20191201195728.4161537-1-aurelien@aurel32.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 33e2638ef7f0d..122321d549227 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -145,7 +145,7 @@ PC_FILE		:= $(addprefix $(OUTPUT),$(PC_FILE))
 
 GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
-			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
+			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
@@ -217,7 +217,7 @@ check_abi: $(OUTPUT)libbpf.so
 		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
 		readelf -s --wide $(BPF_IN_SHARED) |			 \
 		    cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' |	 \
-		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
+		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf -s --wide $(OUTPUT)libbpf.so |			 \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
-- 
2.20.1



