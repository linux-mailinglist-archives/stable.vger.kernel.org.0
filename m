Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D9437C55C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhELPjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232387AbhELPdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:33:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A96E36199F;
        Wed, 12 May 2021 15:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832632;
        bh=68S/HioLc1NFGa+6IfN2YMldwz98MGOa2TnHObTnbHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaTiAAhbmckKoLnbR1FVeJ0Yf+c0LBshbvptqZQDbwpjAJSdDI+oALA1uq4qH2sb1
         9EDZgnuZcjfXv8u5vOF97g9Oe+gv2A1X73fAB6sF+nl56dIJyAIgrUpNC48jgQfA1T
         Llbhb3vh+mlt04R0zlUSx3nZ/Z7bMq97N5AAyoQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/530] bpftool: Fix maybe-uninitialized warnings
Date:   Wed, 12 May 2021 16:47:48 +0200
Message-Id: <20210512144831.552843471@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 4bbb3583687051ef99966ddaeb1730441b777d40 ]

Somehow when bpftool is compiled in -Og mode, compiler produces new warnings
about possibly uninitialized variables. Fix all the reported problems.

Fixes: 2119f2189df1 ("bpftool: add C output format option to btf dump subcommand")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210313210920.1959628-3-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf.c  | 3 +++
 tools/bpf/bpftool/main.c | 3 +--
 tools/bpf/bpftool/map.c  | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 2afb7d5b1aca..592803af9734 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -519,6 +519,7 @@ static int do_dump(int argc, char **argv)
 			NEXT_ARG();
 			if (argc < 1) {
 				p_err("expecting value for 'format' option\n");
+				err = -EINVAL;
 				goto done;
 			}
 			if (strcmp(*argv, "c") == 0) {
@@ -528,11 +529,13 @@ static int do_dump(int argc, char **argv)
 			} else {
 				p_err("unrecognized format specifier: '%s', possible values: raw, c",
 				      *argv);
+				err = -EINVAL;
 				goto done;
 			}
 			NEXT_ARG();
 		} else {
 			p_err("unrecognized option: '%s'", *argv);
+			err = -EINVAL;
 			goto done;
 		}
 	}
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 682daaa49e6a..33068d6ed5d6 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -274,7 +274,7 @@ static int do_batch(int argc, char **argv)
 	int n_argc;
 	FILE *fp;
 	char *cp;
-	int err;
+	int err = 0;
 	int i;
 
 	if (argc < 2) {
@@ -368,7 +368,6 @@ static int do_batch(int argc, char **argv)
 	} else {
 		if (!json_output)
 			printf("processed %d commands\n", lines);
-		err = 0;
 	}
 err_close:
 	if (fp != stdin)
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index a7efbd84fbcc..ce6faf1b90e8 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -99,7 +99,7 @@ static int do_dump_btf(const struct btf_dumper *d,
 		       void *value)
 {
 	__u32 value_id;
-	int ret;
+	int ret = 0;
 
 	/* start of key-value pair */
 	jsonw_start_object(d->jw);
-- 
2.30.2



