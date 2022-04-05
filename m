Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228E24F28CD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbiDEIXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiDEIQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1F4B0A;
        Tue,  5 Apr 2022 01:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0678EB81B18;
        Tue,  5 Apr 2022 08:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBF7C385A4;
        Tue,  5 Apr 2022 08:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145805;
        bh=0tnG8i1GQZyMXsloxwbwqj8+PZOJC5u1shC/sV5xwUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P28+5NtjyB9voUKMtNgmPLEYCmN4heGynhANqT+F1T38ETlUHiFy94OdyjqGPJKJc
         rd1T7Gn02UfYto2ajKX27HzGulTKGjNToEZVA4AuBIpWf50/7wosecBCVxcvq7I9il
         mqSxeKSfpf/X5XUnDJrl5bT2pL0MeQg/q6eGaMlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0535/1126] libbpf: Fix compilation warning due to mismatched printf format
Date:   Tue,  5 Apr 2022 09:21:22 +0200
Message-Id: <20220405070423.334924018@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 55aed9e398c3..07ebe70d3a30 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1869,7 +1869,8 @@ static int btf_dump_array_data(struct btf_dump *d,
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



