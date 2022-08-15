Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A03D593F03
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiHOVMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244573AbiHOVK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:10:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A575C558C9;
        Mon, 15 Aug 2022 12:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 957AACE12C4;
        Mon, 15 Aug 2022 19:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3A9C433C1;
        Mon, 15 Aug 2022 19:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591139;
        bh=JYVX+japmWo6QkvwKxE7PofA1DxPVMaWjvU8+Bwxme0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJSuEFBTdB5P5usijTlDveuaO+xuFxqfYKp7MpPwT3u9ZUxi2OmKApn5WOwgF66Fr
         RtvE47vLF+Ojr5i/lqq6TrJjQB2sWyPJJT0rG9HXdBEiIL3lbR2Rh4tLllkDeijGKP
         c7Qr/YRs/O5khJ1vtYri6NmnN9gW6lhAs3d/7Qqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0484/1095] libbpf: fix an snprintf() overflow check
Date:   Mon, 15 Aug 2022 19:58:03 +0200
Message-Id: <20220815180449.583538580@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 927745b08014..23f5c46708f8 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -533,7 +533,7 @@ void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *attach_name,
 	gen->attach_kind = kind;
 	ret = snprintf(gen->attach_target, sizeof(gen->attach_target), "%s%s",
 		       prefix, attach_name);
-	if (ret == sizeof(gen->attach_target))
+	if (ret >= sizeof(gen->attach_target))
 		gen->error = -ENOSPC;
 }
 
-- 
2.35.1



