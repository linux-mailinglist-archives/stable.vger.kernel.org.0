Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A83451133
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243150AbhKOTCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:02:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243494AbhKOS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:59:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF39E63493;
        Mon, 15 Nov 2021 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999982;
        bh=4PZSFz8hbpGnDbT9Q5SjS62OlaDeGo1AcSoVZjJ8ry0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3hr7VG9FiWY31gLTNT92QD0I3orH37St9ty/pjP9XsIjwFUrI5OlSxj4kHcMBDkV
         0klPn1Vt5koTdPA7lctHTDVvqJJVcqRdJhrbqtSAdQoBN+b0lBa/kMwiDDfU7s2yHL
         oF1MiytzKP4/iZnZXCfDVGFw2bVeLLg5XWwgG0A0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 493/849] bpftool: Avoid leaking the JSON writer prepared for program metadata
Date:   Mon, 15 Nov 2021 17:59:36 +0100
Message-Id: <20211115165436.960070331@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit e89ef634f81c9d90e1824ab183721f3b361472e6 ]

Bpftool creates a new JSON object for writing program metadata in plain
text mode, regardless of metadata being present or not. Then this writer
is freed if any metadata has been found and printed, but it leaks
otherwise. We cannot destroy the object unconditionally, because the
destructor prints an undesirable line break. Instead, make sure the
writer is created only after we have found program metadata to print.

Found with valgrind.

Fixes: aff52e685eb3 ("bpftool: Support dumping metadata")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211022094743.11052-1-quentin@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 9d709b4276655..a33238a100a0c 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -308,18 +308,12 @@ static void show_prog_metadata(int fd, __u32 num_maps)
 		if (printed_header)
 			jsonw_end_object(json_wtr);
 	} else {
-		json_writer_t *btf_wtr = jsonw_new(stdout);
+		json_writer_t *btf_wtr;
 		struct btf_dumper d = {
 			.btf = btf,
-			.jw = btf_wtr,
 			.is_plain_text = true,
 		};
 
-		if (!btf_wtr) {
-			p_err("jsonw alloc failed");
-			goto out_free;
-		}
-
 		for (i = 0; i < vlen; i++, vsi++) {
 			t_var = btf__type_by_id(btf, vsi->type);
 			name = btf__name_by_offset(btf, t_var->name_off);
@@ -329,6 +323,14 @@ static void show_prog_metadata(int fd, __u32 num_maps)
 
 			if (!printed_header) {
 				printf("\tmetadata:");
+
+				btf_wtr = jsonw_new(stdout);
+				if (!btf_wtr) {
+					p_err("jsonw alloc failed");
+					goto out_free;
+				}
+				d.jw = btf_wtr,
+
 				printed_header = true;
 			}
 
-- 
2.33.0



