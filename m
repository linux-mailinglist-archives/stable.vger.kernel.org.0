Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA72A499672
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445536AbiAXVED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53064 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbiAXU6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:58:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53E93B80FA1;
        Mon, 24 Jan 2022 20:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80242C340E5;
        Mon, 24 Jan 2022 20:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057881;
        bh=ar9ht5AP9dAkNJ725Y7CCDGfnkeI2slBT93cSTlvyOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0icwx5UClFFqNtz9hZdmZD15jPKYJD4tz3/EwnOP7F9RbbvRjhc7H7RyA6xpR8RN
         Cksf4fqDdcgiJqRnPMfNCOoLrsRFYlaYGDTlMWouBDvVwF4r+p+4d5ipMTVTSqR9oX
         isQ6HKZmHNxtcKCSesythzbN4YRy3qW+QM3mHkOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0109/1039] libbpf: Fix non-C89 loop variable declaration in gen_loader.c
Date:   Mon, 24 Jan 2022 19:31:38 +0100
Message-Id: <20220124184128.805775372@linuxfoundation.org>
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

[ Upstream commit b8b5cb55f5d3f03cc1479a3768d68173a10359ad ]

Fix the `int i` declaration inside the for statement. This is non-C89
compliant. See [0] for user report breaking BCC build.

  [0] https://github.com/libbpf/libbpf/issues/403

Fixes: 18f4fccbf314 ("libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/bpf/20211105191055.3324874-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 9934851ccde76..5aad39e92a7a5 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -597,8 +597,9 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
 static struct ksym_desc *get_ksym_desc(struct bpf_gen *gen, struct ksym_relo_desc *relo)
 {
 	struct ksym_desc *kdesc;
+	int i;
 
-	for (int i = 0; i < gen->nr_ksyms; i++) {
+	for (i = 0; i < gen->nr_ksyms; i++) {
 		if (!strcmp(gen->ksyms[i].name, relo->name)) {
 			gen->ksyms[i].ref++;
 			return &gen->ksyms[i];
-- 
2.34.1



