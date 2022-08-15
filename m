Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D565A593637
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiHOS6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245042AbiHOS4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:56:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5AA2C67B;
        Mon, 15 Aug 2022 11:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7104B61043;
        Mon, 15 Aug 2022 18:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486C8C433D6;
        Mon, 15 Aug 2022 18:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588274;
        bh=Am9f5DX2cRApJL2HJEP4OQCjdiP3VXL6uJRI/RttOyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYdx9mzHNIAUoDsEWQsOSzUKkY+eoUtqiiAoI5rbg+Z0ycUeWhOAr2cy2KeMmh4cT
         I25bLQkzQ4BZjSkgbDQvgz4Xbw730FZoEhwYLa/R16ScGb1muJ/bhxtPFOsOp/IsW1
         rQciFrgNVX/o2KEZAAfIWRSI2dpKyovyy6VJgC/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/779] libbpf: fix an snprintf() overflow check
Date:   Mon, 15 Aug 2022 19:59:54 +0200
Message-Id: <20220815180352.200320192@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit b77ffb30cfc5f58e957571d8541c6a7e3da19221 ]

The snprintf() function returns the number of bytes it *would* have
copied if there were enough space.  So it can return > the
sizeof(gen->attach_target).

Fixes: 67234743736a ("libbpf: Generate loader program out of BPF ELF file.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/r/YtZ+oAySqIhFl6/J@kili
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 33c19590ee43..4435c09fe132 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -480,7 +480,7 @@ void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *attach_name,
 	gen->attach_kind = kind;
 	ret = snprintf(gen->attach_target, sizeof(gen->attach_target), "%s%s",
 		       prefix, attach_name);
-	if (ret == sizeof(gen->attach_target))
+	if (ret >= sizeof(gen->attach_target))
 		gen->error = -ENOSPC;
 }
 
-- 
2.35.1



