Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6508604875
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbiJSN4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbiJSNyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BA518542D;
        Wed, 19 Oct 2022 06:37:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0FBFB8232A;
        Wed, 19 Oct 2022 08:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C976C433D6;
        Wed, 19 Oct 2022 08:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169349;
        bh=boiTHlnuO/TKiwsbBxT4uNEIkYKD57pTRY5XdiRnf60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoukKzLs+mW3AKNP1Guu6XARVf26XA5saEjmy/P98BpSBs0Aca4T1oLHkiVPLRbSI
         bn2YhYxZZl4Tbr02tEFDimjTC+FZcEElzOsKrCR71ftza1rZUzO+MQO+1zsPDLoGu8
         WpIlrA4fFwao2CNexndqpEQtOj5vRN9nHkbqoevg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lam Thai <lamthai@arista.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 244/862] bpftool: Fix a wrong type cast in btf_dumper_int
Date:   Wed, 19 Oct 2022 10:25:31 +0200
Message-Id: <20221019083300.795945784@linuxfoundation.org>
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

From: Lam Thai <lamthai@arista.com>

[ Upstream commit 7184aef9c0f7a81db8fd18d183ee42481d89bf35 ]

When `data` points to a boolean value, casting it to `int *` is problematic
and could lead to a wrong value being passed to `jsonw_bool`. Change the
cast to `bool *` instead.

Fixes: b12d6ec09730 ("bpf: btf: add btf print functionality")
Signed-off-by: Lam Thai <lamthai@arista.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220824225859.9038-1-lamthai@arista.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf_dumper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 125798b0bc5d..19924b6ce796 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -452,7 +452,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 					     *(char *)data);
 		break;
 	case BTF_INT_BOOL:
-		jsonw_bool(jw, *(int *)data);
+		jsonw_bool(jw, *(bool *)data);
 		break;
 	default:
 		/* shouldn't happen */
-- 
2.35.1



