Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD0604103
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiJSKfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiJSKeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:34:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5480BC467;
        Wed, 19 Oct 2022 03:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82117B823B4;
        Wed, 19 Oct 2022 08:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3359C433C1;
        Wed, 19 Oct 2022 08:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169619;
        bh=OPp2VmU2xuhn8QhfIRqDT+QYwwrcCJFreKlrbF9Gf0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcCqxMZENL3UvsK8P+nXb+sTlR0Y+98qorPa6o5O5ZD49Py/guZHEmpbN0a/79t7e
         lDqKL+6ezSRaJAsLHBXQT1JCn8Yg9mq2688yd7HIgenpBuI9HpQQcynzh7ZHjpwBdC
         LwLnz8OYFJSGhnewUWkGedMJhQb31eFl4M86m4C8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grant Seltzer Richman <grantseltzer@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 311/862] libbpf: restore memory layout of bpf_object_open_opts
Date:   Wed, 19 Oct 2022 10:26:38 +0200
Message-Id: <20221019083303.755808690@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit dbdea9b36fb61da3b9a1be0dd63542e2bfd3e5d7 ]

When attach_prog_fd field was removed in libbpf 1.0 and replaced with
`long: 0` placeholder, it actually shifted all the subsequent fields by
8 byte. This is due to `long: 0` promising to adjust next field's offset
to long-aligned offset. But in this case we were already long-aligned
as pin_root_path is a pointer. So `long: 0` had no effect, and thus
didn't feel the gap created by removed attach_prog_fd.

Non-zero bitfield should have been used instead. I validated using
pahole. Originally kconfig field was at offset 40. With `long: 0` it's
at offset 32, which is wrong. With this change it's back at offset 40.

While technically libbpf 1.0 is allowed to break backwards
compatibility and applications should have been recompiled against
libbpf 1.0 headers, but given how trivial it is to preserve memory
layout, let's fix this.

Reported-by: Grant Seltzer Richman <grantseltzer@gmail.com>
Fixes: 146bf811f5ac ("libbpf: remove most other deprecated high-level APIs")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20220923230559.666608-1-andrii@kernel.org
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 61493c4cddac..9f956e6058ed 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -118,7 +118,9 @@ struct bpf_object_open_opts {
 	 * auto-pinned to that path on load; defaults to "/sys/fs/bpf".
 	 */
 	const char *pin_root_path;
-	long :0;
+
+	__u32 :32; /* stub out now removed attach_prog_fd */
+
 	/* Additional kernel config content that augments and overrides
 	 * system Kconfig for CONFIG_xxx externs.
 	 */
-- 
2.35.1



