Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40416AF32D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCGTBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCGTBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:01:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4869773AFA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:47:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05E13B819D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A87C433EF;
        Tue,  7 Mar 2023 18:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214864;
        bh=SO4TmPjTGtVmyOChUjSxE5JOC3EGu+TuYBlqo+fZzUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5cfN/iB+MyS5IQ4DZzRKL0S+D8mGuA7IVhXROfldyOcZJ4OUm54I1JELhDXEjgfo
         /20I6CQ8Wsg+Zy+Le8hpOy5BP0nH3T+Qv9NBu+07GRdWQUg7XxlBPAPGnxn96cB16a
         jP75Hml6YOPB6zyax267t949Vx+QFsbHzgpqNTR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/567] libbpf: Fix btf__align_of() by taking into account field offsets
Date:   Tue,  7 Mar 2023 17:56:50 +0100
Message-Id: <20230307165909.108375933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 25a4481b4136af7794e1df2d6c90ed2f354d60ce ]

btf__align_of() is supposed to be return alignment requirement of
a requested BTF type. For STRUCT/UNION it doesn't always return correct
value, because it calculates alignment only based on field types. But
for packed structs this is not enough, we need to also check field
offsets and struct size. If field offset isn't aligned according to
field type's natural alignment, then struct must be packed. Similarly,
if struct size is not a multiple of struct's natural alignment, then
struct must be packed as well.

This patch fixes this issue precisely by additionally checking these
conditions.

Fixes: 3d208f4ca111 ("libbpf: Expose btf__align_of() API")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221212211505.558851-5-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3ed759f53e7c2..fd23095129782 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -647,8 +647,21 @@ int btf__align_of(const struct btf *btf, __u32 id)
 			if (align <= 0)
 				return libbpf_err(align);
 			max_align = max(max_align, align);
+
+			/* if field offset isn't aligned according to field
+			 * type's alignment, then struct must be packed
+			 */
+			if (btf_member_bitfield_size(t, i) == 0 &&
+			    (m->offset % (8 * align)) != 0)
+				return 1;
 		}
 
+		/* if struct/union size isn't a multiple of its alignment,
+		 * then struct must be packed
+		 */
+		if ((t->size % max_align) != 0)
+			return 1;
+
 		return max_align;
 	}
 	default:
-- 
2.39.2



