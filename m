Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C554F3760
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352871AbiDELM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348996AbiDEJsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109CEBF48;
        Tue,  5 Apr 2022 02:38:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A350061368;
        Tue,  5 Apr 2022 09:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68C0C385A2;
        Tue,  5 Apr 2022 09:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151532;
        bh=MmVuj5Jn6/ljtQM0iFKEIkI664NTWqPKVGArAgH7kyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3iWOsqIqb6dfVDJzdl22HyJadXe4wnla98C/2Q5t93HOghS1OAUTrPxWoATqiUie
         qgoPrwmifecG+YMjEhblFc4Zs3AlBcVnicVqEstpvFSMm4VsAN4DrcSauOPCQ8nz5t
         NR4a3o+++RPC+E/MEygOHzs8ZntztsAgF31uri5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 448/913] libbpf: Fix compilation warning due to mismatched printf format
Date:   Tue,  5 Apr 2022 09:25:10 +0200
Message-Id: <20220405070353.276881997@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit dc37dc617fabfb1c3a16d49f5d8cc20e9e3608ca ]

On ppc64le architecture __s64 is long int and requires %ld. Cast to
ssize_t and use %zd to avoid architecture-specific specifiers.

Fixes: 4172843ed4a3 ("libbpf: Fix signedness bug in btf_dump_array_data()")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220209063909.1268319-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index c1182dd94677..463447a071d6 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1837,7 +1837,8 @@ static int btf_dump_array_data(struct btf_dump *d,
 	elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
 	elem_size = btf__resolve_size(d->btf, elem_type_id);
 	if (elem_size <= 0) {
-		pr_warn("unexpected elem size %lld for array type [%u]\n", elem_size, id);
+		pr_warn("unexpected elem size %zd for array type [%u]\n",
+			(ssize_t)elem_size, id);
 		return -EINVAL;
 	}
 
-- 
2.34.1



