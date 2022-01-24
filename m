Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4959E49A32F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386285AbiAXX5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845986AbiAXXOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E03CC067A75;
        Mon, 24 Jan 2022 13:20:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26744B81218;
        Mon, 24 Jan 2022 21:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F143C340E4;
        Mon, 24 Jan 2022 21:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059253;
        bh=aVB5FviLglqF60loxM2XgzrRKvbq4BiXPpr7wIcCXXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJ68WdmNcWTP/dW1BOdHVYNjUqV3s29WirLRFwqHw2XYygQgZehBWuhcDI1mQ2EGx
         xRCPXtZBW5L7x3tbpeHbpucjnjexZqeWVpN7HVZLUnJcmoCmWIv01lL9Gn3wb2OfU3
         Q1I5TToCin0D3ZXTuy/0wTVZFcTII8RIWQt9cs54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0547/1039] libbpf: Improve sanity checking during BTF fix up
Date:   Mon, 24 Jan 2022 19:38:56 +0100
Message-Id: <20220124184143.658837249@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 88918dc12dc357a06d8d722a684617b1c87a4654 ]

If BTF is corrupted DATASEC's variable type ID might be incorrect.
Prevent this easy to detect situation with extra NULL check.
Reported by oss-fuzz project.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211103173213.1376990-3-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1cc0383471f01..c7ba5e6ed9cfe 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2753,13 +2753,12 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
 
 	for (i = 0, vsi = btf_var_secinfos(t); i < vars; i++, vsi++) {
 		t_var = btf__type_by_id(btf, vsi->type);
-		var = btf_var(t_var);
-
-		if (!btf_is_var(t_var)) {
+		if (!t_var || !btf_is_var(t_var)) {
 			pr_debug("Non-VAR type seen in section %s\n", name);
 			return -EINVAL;
 		}
 
+		var = btf_var(t_var);
 		if (var->linkage == BTF_VAR_STATIC)
 			continue;
 
-- 
2.34.1



