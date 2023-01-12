Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1453B6674D5
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjALOO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjALONY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:13:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD3E5B483
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB43961FBB
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD5BC433EF;
        Thu, 12 Jan 2023 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532370;
        bh=JG2fjaTuM+C/WNcZeB7C7R3k7QSjeF1fQ2L85pdVXBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUEQzELz1q1Rh6CxOnQ5snLPWwncCAgf6+6omZtkl7YpSpLSdV6Gj44JAYzm5bOc5
         bGH5H5wG7pKPywR49++J/T/Lgdm7N2ddpnkqCQbrUKf3J+qSrymJhZMmKL9sPzKY4j
         ZuiciqsObKDmHwz3BZoUjAf+2Q/6lLEgg/1QSILI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/783] libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()
Date:   Thu, 12 Jan 2023 14:47:04 +0100
Message-Id: <20230112135529.207303327@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 66d7f8d494de..015ed8253f73 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3479,6 +3479,9 @@ static struct bpf_program *find_prog_by_sec_insn(const struct bpf_object *obj,
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



