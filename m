Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE54A657BD7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiL1P0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbiL1PZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:25:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065E5B61
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:25:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63ADE6156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AD1C433D2;
        Wed, 28 Dec 2022 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241143;
        bh=fVSjJaNKR0aJWETif8l37jwbfBwN3cYR/5VXZm1Pi1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVMEfUXy07JXT14ayIxHfTNb+0irxV9JWBu6OPYUpraQ5+2MCFNdS5G7V8DXpB+ic
         U/TYRdg9SkygqrNtWnOzyb6EnpHfpXJ5FDx1qJRm1O28lNM4kM/nNBabS2c3oYwuVo
         OJ7/IhKNn5sY6LHDjffksUzMShrAPaTHWhMzJ6hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0212/1146] libbpf: Deal with section with no data gracefully
Date:   Wed, 28 Dec 2022 15:29:11 +0100
Message-Id: <20221228144335.905462353@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 35a855509e6ee3442477c8ebc6827b5b5d32a7b5 ]

ELF section data pointer returned by libelf may be NULL (if section has
SHT_NOBITS), so null check section data pointer before attempting to
copy license and kversion section.

Fixes: cb1e5e961991 ("bpf tools: Collect version and license from ELF sections")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221012022353.7350-3-shung-hsi.yu@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b7fac0df2612..a0d3cc39ea73 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1408,6 +1408,10 @@ static int bpf_object__check_endianness(struct bpf_object *obj)
 static int
 bpf_object__init_license(struct bpf_object *obj, void *data, size_t size)
 {
+	if (!data) {
+		pr_warn("invalid license section in %s\n", obj->path);
+		return -LIBBPF_ERRNO__FORMAT;
+	}
 	/* libbpf_strlcpy() only copies first N - 1 bytes, so size + 1 won't
 	 * go over allowed ELF data section buffer
 	 */
@@ -1421,7 +1425,7 @@ bpf_object__init_kversion(struct bpf_object *obj, void *data, size_t size)
 {
 	__u32 kver;
 
-	if (size != sizeof(kver)) {
+	if (!data || size != sizeof(kver)) {
 		pr_warn("invalid kver section in %s\n", obj->path);
 		return -LIBBPF_ERRNO__FORMAT;
 	}
-- 
2.35.1



