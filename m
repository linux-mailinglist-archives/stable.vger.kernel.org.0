Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7263F499FB8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842082AbiAXXAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836488AbiAXWjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8450C054872;
        Mon, 24 Jan 2022 13:01:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64FB4B81243;
        Mon, 24 Jan 2022 21:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A741C340E8;
        Mon, 24 Jan 2022 21:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058064;
        bh=Nq32nGkmOvzmotwTwzSieK08WMBchdmVk7fmJ8Mhz70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltvacDjkidv0MFbqa1ELREERfr2Z7LLXByjgGtiLEegARZiLcD9ww3p71GN0dn+is
         f0UrZK859OcVEMUpWv1mOezgGvCqKtekGuZxY/1jKnaS71f0Xb4xUF/Xc/OuvGpPPP
         3VFuwW4326z+BC0254XmxDJYQ3ctGsjJDOY8JJWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0170/1039] tools/resolve_btf_ids: Close ELF file on error
Date:   Mon, 24 Jan 2022 19:32:39 +0100
Message-Id: <20220124184130.945056389@linuxfoundation.org>
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

[ Upstream commit 1144ab9bdf3430e1b5b3f22741e5283841951add ]

Fix one case where we don't do explicit clean up.

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211124002325.1737739-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 73409e27be01f..5d26f3c6f918e 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -168,7 +168,7 @@ static struct btf_id *btf_id__find(struct rb_root *root, const char *name)
 	return NULL;
 }
 
-static struct btf_id*
+static struct btf_id *
 btf_id__add(struct rb_root *root, char *name, bool unique)
 {
 	struct rb_node **p = &root->rb_node;
@@ -732,7 +732,8 @@ int main(int argc, const char **argv)
 	if (obj.efile.idlist_shndx == -1 ||
 	    obj.efile.symbols_shndx == -1) {
 		pr_debug("Cannot find .BTF_ids or symbols sections, nothing to do\n");
-		return 0;
+		err = 0;
+		goto out;
 	}
 
 	if (symbols_collect(&obj))
-- 
2.34.1



