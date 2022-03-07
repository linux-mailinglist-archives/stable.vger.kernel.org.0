Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEE34CF68B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbiCGJmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbiCGJlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70786D4D0;
        Mon,  7 Mar 2022 01:39:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B106B8102B;
        Mon,  7 Mar 2022 09:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C99C340E9;
        Mon,  7 Mar 2022 09:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645951;
        bh=vW4LO60/Ru4RMZgw8XnXaD6rZPUU5Xd040JeN7CbI14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQAEv/MJrgifxKAEZ/wh92/lV9KsFzw948yfAsTkPGi8c0OEw6FcRWq2rQMBTsHGB
         q8sOyV69BHwxUwm+4FPAKS+mac3b/rbnsW/KgvTe9IlXruWOuTP3neGn5AMJW8dxQL
         n9iHVJq2wHh0d0dnypO7SYSRZBMV1Jg+NQGvk4Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/262] tools/resolve_btf_ids: Close ELF file on error
Date:   Mon,  7 Mar 2022 10:16:30 +0100
Message-Id: <20220307091703.822165908@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index de6365b53c9ca..45e0d640618ac 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -166,7 +166,7 @@ static struct btf_id *btf_id__find(struct rb_root *root, const char *name)
 	return NULL;
 }
 
-static struct btf_id*
+static struct btf_id *
 btf_id__add(struct rb_root *root, char *name, bool unique)
 {
 	struct rb_node **p = &root->rb_node;
@@ -720,7 +720,8 @@ int main(int argc, const char **argv)
 		if (no_fail)
 			return 0;
 		pr_err("FAILED to find needed sections\n");
-		return -1;
+		err = 0;
+		goto out;
 	}
 
 	if (symbols_collect(&obj))
-- 
2.34.1



