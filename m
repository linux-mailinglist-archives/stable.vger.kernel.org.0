Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C604849922E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350216AbiAXUR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41806 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379421AbiAXUPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:15:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D0E86091B;
        Mon, 24 Jan 2022 20:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074F7C340E5;
        Mon, 24 Jan 2022 20:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055300;
        bh=8HdrVk2KIH8ByhHcq3OL63Nlh/N9PJP7ZMm16YNDHgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnHqHz1JSI+VjytjkKsOOb6hutH94zWBMmrUVwL6MgJvRqs//tjoxJWUS80CY50mw
         HQVikrV3d2Q7rfM26y3vjwHd3z01zNfd5AWI6gal3UyMTT6qmto6zfQdh8sKQTxGel
         FPUIknw8nr18ssFiW0owxSqxPuu2nVMGAQ5ZCMlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/846] bpftool: Fix memory leak in prog_dump()
Date:   Mon, 24 Jan 2022 19:33:42 +0100
Message-Id: <20220124184104.614069581@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit ebbd7f64a3fbe9e0f235e39fc244ee9735e2a52a ]

Following the extraction of prog_dump() from do_dump(), the struct btf
allocated in prog_dump() is no longer freed on error; the struct
bpf_prog_linfo is not freed at all. Make sure we release them before
exiting the function.

Fixes: ec2025095cf6 ("bpftool: Match several programs with same tag")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211110114632.24537-2-quentin@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index fe59404e87046..f8755beb3d9eb 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -629,8 +629,8 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 	char func_sig[1024];
 	unsigned char *buf;
 	__u32 member_len;
+	int fd, err = -1;
 	ssize_t n;
-	int fd;
 
 	if (mode == DUMP_JITED) {
 		if (info->jited_prog_len == 0 || !info->jited_prog_insns) {
@@ -669,7 +669,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		if (fd < 0) {
 			p_err("can't open file %s: %s", filepath,
 			      strerror(errno));
-			return -1;
+			goto exit_free;
 		}
 
 		n = write(fd, buf, member_len);
@@ -677,7 +677,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		if (n != (ssize_t)member_len) {
 			p_err("error writing output file: %s",
 			      n < 0 ? strerror(errno) : "short write");
-			return -1;
+			goto exit_free;
 		}
 
 		if (json_output)
@@ -691,7 +691,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 						     info->netns_ino,
 						     &disasm_opt);
 			if (!name)
-				return -1;
+				goto exit_free;
 		}
 
 		if (info->nr_jited_func_lens && info->jited_func_lens) {
@@ -786,9 +786,12 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		kernel_syms_destroy(&dd);
 	}
 
-	btf__free(btf);
+	err = 0;
 
-	return 0;
+exit_free:
+	btf__free(btf);
+	bpf_prog_linfo__free(prog_linfo);
+	return err;
 }
 
 static int do_dump(int argc, char **argv)
-- 
2.34.1



