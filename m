Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E154996E0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446215AbiAXVHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54438 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444979AbiAXVBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5122D60C17;
        Mon, 24 Jan 2022 21:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314AFC340E5;
        Mon, 24 Jan 2022 21:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058109;
        bh=RCFUEYNF8zNosS4379XW1Pwb4Rx5S5veAVuWvZxUI2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9Y1WObEbu60uL+ms9Q57TeIsgGg/5orLASjVI8T0vsj+Utq58Z6cU1ViqemjWf3c
         QDXL51TY+xbGlAH9o56lF+GKMwruOw69hg3Q2JCZrY95/MsEqdY0W/dUD8+QUSalBY
         f80ceAgvkVpHEjmbcjwYarQ80r/PM9MPpURaNK6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0184/1039] libbpf: Silence uninitialized warning/error in btf_dump_dump_type_data
Date:   Mon, 24 Jan 2022 19:32:53 +0100
Message-Id: <20220124184131.467285436@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 43174f0d4597325cb91f1f1f55263eb6e6101036 ]

When compiling libbpf with gcc 4.8.5, we see:

  CC       staticobjs/btf_dump.o
btf_dump.c: In function ‘btf_dump_dump_type_data.isra.24’:
btf_dump.c:2296:5: error: ‘err’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
  if (err < 0)
     ^
cc1: all warnings being treated as errors
make: *** [staticobjs/btf_dump.o] Error 1

While gcc 4.8.5 is too old to build the upstream kernel, it's possible it
could be used to build standalone libbpf which suffers from the same problem.
Silence the error by initializing 'err' to 0.  The warning/error seems to be
a false positive since err is set early in the function.  Regardless we
shouldn't prevent libbpf from building for this.

Fixes: 920d16af9b42 ("libbpf: BTF dumper support for typed data")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/1638180040-8037-1-git-send-email-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 17db62b5002e8..5cae71600631b 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -2194,7 +2194,7 @@ static int btf_dump_dump_type_data(struct btf_dump *d,
 				   __u8 bits_offset,
 				   __u8 bit_sz)
 {
-	int size, err;
+	int size, err = 0;
 
 	size = btf_dump_type_data_check_overflow(d, t, id, data, bits_offset);
 	if (size < 0)
-- 
2.34.1



