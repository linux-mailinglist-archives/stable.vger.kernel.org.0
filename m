Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1AE6AE91D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjCGRVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCGRUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:20:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE929FBE5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53AFEB819A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9DDC433EF;
        Tue,  7 Mar 2023 17:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209359;
        bh=7N6oifyHFC1nqqyYt3My57NdM3Hfok8rcw3GmbacoI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhnBhS1ccjgh4DVXu117S0ymjAnla1YuKDMQaipM8DmCoqCiQhEL2YCTqH/aZTjbo
         JWZBD0igRXiy3zcmwrW+A70Gj1/w1bxXd4ZPyfoV3BNapSspDGcNrxU/uVFbVcCjt3
         AoBxr/9HfNpdGvgRGm3SRBvKbMCkajdrtKonhgE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0161/1001] libbpf: Fix btf__align_of() by taking into account field offsets
Date:   Tue,  7 Mar 2023 17:48:53 +0100
Message-Id: <20230307170029.008701547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 71e165b09ed59..8cbcef959456d 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -688,8 +688,21 @@ int btf__align_of(const struct btf *btf, __u32 id)
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



