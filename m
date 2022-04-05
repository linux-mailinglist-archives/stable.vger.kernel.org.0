Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1251D4F2E38
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbiDEJgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiDEI7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:59:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9BD255AD;
        Tue,  5 Apr 2022 01:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 686A961003;
        Tue,  5 Apr 2022 08:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F464C385A1;
        Tue,  5 Apr 2022 08:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148804;
        bh=H9YrjQMoX5Tf6SSBBMB7UlmEDAvSUYEDqi5RKX3WyUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drkf5XnCtuu/i0gsjDOculEyi+1o2DbOlrtuiYLSxRZ1BVo+R34bRnkMSLTJXG2Pz
         lQAm91b3xnda71JxELX7yekbhxCQCQ7lS1q3twzGtpmA0ApL6PqTCwhEa0Mvr3ku7h
         tDJxg6lJ+4Oxfn1HNrznByckURrggCQUlthQYNr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0487/1017] libbpf: Fix signedness bug in btf_dump_array_data()
Date:   Tue,  5 Apr 2022 09:23:20 +0200
Message-Id: <20220405070408.754584448@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4172843ed4a38f97084032f74f07b2037b5da3a6 ]

The btf__resolve_size() function returns negative error codes so
"elem_size" must be signed for the error handling to work.

Fixes: 920d16af9b42 ("libbpf: BTF dumper support for typed data")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220208071552.GB10495@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 5cae71600631..700dfd362c4a 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1839,14 +1839,15 @@ static int btf_dump_array_data(struct btf_dump *d,
 {
 	const struct btf_array *array = btf_array(t);
 	const struct btf_type *elem_type;
-	__u32 i, elem_size = 0, elem_type_id;
+	__u32 i, elem_type_id;
+	__s64 elem_size;
 	bool is_array_member;
 
 	elem_type_id = array->type;
 	elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
 	elem_size = btf__resolve_size(d->btf, elem_type_id);
 	if (elem_size <= 0) {
-		pr_warn("unexpected elem size %d for array type [%u]\n", elem_size, id);
+		pr_warn("unexpected elem size %lld for array type [%u]\n", elem_size, id);
 		return -EINVAL;
 	}
 
-- 
2.34.1



