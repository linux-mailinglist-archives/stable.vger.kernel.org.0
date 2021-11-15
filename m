Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3739A4513D4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347293AbhKOT4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344059AbhKOTXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4711463454;
        Mon, 15 Nov 2021 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002266;
        bh=blodhIHFC8tOY9X//jl/GQPqkYAtWROkyMRhJtL8LNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMXd698zDzC/3JQYfQOXt79+0ziVoVcK3o+sNthqguQqcALd16bfaIqvafjpigN6g
         prbI9M6l7hAfhsLHTTZALaZgMUUSP8h6rTUaTQ13Wyp/5NhSfWZ1FNje6WnX2xTSwX
         sC4ZoIzu0ZeQyyzGSp++pHPiel0ZG0lTHrgOSyJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 502/917] bpftool: Avoid leaking the JSON writer prepared for program metadata
Date:   Mon, 15 Nov 2021 17:59:57 +0100
Message-Id: <20211115165445.790114514@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 9c3e343b7d872..fe59404e87046 100644
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



