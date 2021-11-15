Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818A5450E0E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240554AbhKOSKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239858AbhKOSEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E610632EB;
        Mon, 15 Nov 2021 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997994;
        bh=qVIrBajr0SElJtMm8mVdcxvP8Gp+KJ9J2krC21s7j4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pI8rpE0n2H8kT5Ng5GL1sI9nNvWIQj0mGfJB6sAlEu+sTb2HfApg3tDJLvT9yBXLD
         Tv3sroEAgIUzz/8RvnQ9FYnCl9YJ13YNxHkx2Jxbx18Ao5f47Vv39NEQdDeVBguerN
         PlLNwkVCawz6yFVuBSqD8M5I9XvofJAd97JBcF2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 349/575] bpftool: Avoid leaking the JSON writer prepared for program metadata
Date:   Mon, 15 Nov 2021 18:01:14 +0100
Message-Id: <20211115165355.865849627@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 14237ffb90bae..592536904dde2 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -304,18 +304,12 @@ static void show_prog_metadata(int fd, __u32 num_maps)
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
@@ -325,6 +319,14 @@ static void show_prog_metadata(int fd, __u32 num_maps)
 
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



