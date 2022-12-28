Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23315657B5D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiL1PUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiL1PUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:20:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34B02B0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E08A6154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB7EC433EF;
        Wed, 28 Dec 2022 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240841;
        bh=umQvhBBzdgHAHwKfETrU2v5wTEeoGD+YwX7xEgNvcz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKKpCv9ptNDaGI69tedFYFIO9PxcnZIDmy87jc2WJ6JTxemepCwJTHiiZ/lFH/iWW
         Llmq9WOSe8/HhZ5maar6rFfPGHkIgF30cyUflCOC7PjzuNlBOMSWULFEeRRouz0H3D
         MCQ2Ej/6jWFO7dky6lQ1RCMX0jD+uec1juxGXW20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0209/1073] libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()
Date:   Wed, 28 Dec 2022 15:29:57 +0100
Message-Id: <20221228144333.696602741@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

[ Upstream commit d0d382f95a9270dcf803539d6781d6bd67e3f5b2 ]

When there are no program sections, obj->programs is left unallocated,
and find_prog_by_sec_insn()'s search lands on &obj->programs[0] == NULL,
and will cause null-pointer dereference in the following access to
prog->sec_idx.

Guard the search with obj->nr_programs similar to what's being done in
__bpf_program__iter() to prevent null-pointer access from happening.

Fixes: db2b8b06423c ("libbpf: Support CO-RE relocations for multi-prog sections")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221012022353.7350-4-shung-hsi.yu@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5561b23338a7..c01f57d31f89 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4085,6 +4085,9 @@ static struct bpf_program *find_prog_by_sec_insn(const struct bpf_object *obj,
 	int l = 0, r = obj->nr_programs - 1, m;
 	struct bpf_program *prog;
 
+	if (!obj->nr_programs)
+		return NULL;
+
 	while (l < r) {
 		m = l + (r - l + 1) / 2;
 		prog = &obj->programs[m];
-- 
2.35.1



