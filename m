Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27B36E62A6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjDRMeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjDRMeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:34:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84312125BA
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20E3063258
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8C0C433EF;
        Tue, 18 Apr 2023 12:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821243;
        bh=0qdgd+Q5SL2DX44G41a3KrVBqolN/UgnE2wv12pknUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TD/6HTJysn+eG/0F/1NTQHihHh+O5QzEVRY8wJHpe0iouBrQoweq97mjfLXBX6D7c
         tb6Ibh9twPx6Lp4FzfEIUTqUQEoNtDlMflS/XS1u4e/c4wppqN1UXXRMcqd+4ry461
         3tqh/mD7eMG+e6j1fmAqeZb67LDo9Pw+hMn+Xbxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eduard Zingerman <eddyz87@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/124] bpftool: Print newline before } for struct with padding only fields
Date:   Tue, 18 Apr 2023 14:21:11 +0200
Message-Id: <20230418120311.727432139@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 44a726c3f23cf762ef4ce3c1709aefbcbe97f62c ]

btf_dump_emit_struct_def attempts to print empty structures at a
single line, e.g. `struct empty {}`. However, it has to account for a
case when there are no regular but some padding fields in the struct.
In such case `vlen` would be zero, but size would be non-zero.

E.g. here is struct bpf_timer from vmlinux.h before this patch:

 struct bpf_timer {
 	long: 64;
	long: 64;};

And after this patch:

 struct bpf_dynptr {
 	long: 64;
	long: 64;
 };

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221001104425.415768-1-eddyz87@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 558d34fbd331c..6a8d8ed34b760 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -969,7 +969,11 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 	if (is_struct)
 		btf_dump_emit_bit_padding(d, off, t->size * 8, align, false, lvl + 1);
 
-	if (vlen)
+	/*
+	 * Keep `struct empty {}` on a single line,
+	 * only print newline when there are regular or padding fields.
+	 */
+	if (vlen || t->size)
 		btf_dump_printf(d, "\n");
 	btf_dump_printf(d, "%s}", pfx(lvl));
 	if (packed)
-- 
2.39.2



