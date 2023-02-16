Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AE56994BB
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 13:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjBPMsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 07:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjBPMsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 07:48:09 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02BC2D4A
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 04:48:01 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id o8so1879504pls.11
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 04:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NS+iyO0TcNgxGxIrrWorl9GfgTLKJGuObeiN3hKi4VY=;
        b=dgm9CHLXzji5ZRLWwHw8PPwXJmaygzb6drHeOZgE20fuIXkruvXAmGcCo1El+qpV4u
         g9xugYg/CbPtITEeCxxNRHzCV0naXIBSsMgMUB2XhPFv2+P7SaMrqMPtlaKvHkN4cpt4
         LpuJWAWQt3PhSBfTsI4RsaDTFMo2MLncXciI/ktdR4w3X5bJxqUkNIbgWapSlpAyUrg2
         zBsz5jQCP6uhg3Hil0DA57lRudg8+HkVCHM66goJipbwYflx72EfFS23b0Sz3ttA6Fc3
         yY5AIJv3O0seTE9jy/4HDV2qtf4zrci9nEScyIYGAZcR6FoqO1uua2dnHiSz/jA2YD6x
         ycvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NS+iyO0TcNgxGxIrrWorl9GfgTLKJGuObeiN3hKi4VY=;
        b=UCFPBpYiHRe40YsTqDEOm631sM3K59+ndyAshtlECMo2hd4Ttjg9USsrbS4pgkEOc2
         iOexBvf/v/WzyLgolSTH5RD7r4DNWaysKFaKkqJScsM5SJUmqNZePYax2F5snkeOjWVs
         HZvEPjY5eWqOoZ2M/Pa+eeAiijyTlpuatuxj4Nif+cIfN5kPLLFgqBzgvawip1GV9Y82
         Ml+E+UUyTpHnkiwPn3K8PtmLy7pYaOBJxVIPJ8b3tVqeKREzHfQTEimOporH7JwRZJ9O
         Xq0/vtt/LGV+3s0/MMKENdY/CFMZ96Bh/s1Iwv9U3I8sIwJNZLIF5EJ2yNroPdyqGyX+
         VfQw==
X-Gm-Message-State: AO0yUKWUwoyH9op3M1HQvoP51HWNes0nhWunx4W1qXZ5X9RNji5vH/5F
        IfkeBG64xQiUQbdNNClTW+qc1XyOO62/xtmO
X-Google-Smtp-Source: AK7set817HeVkSKhoed5aqmCDTp7DB0bPLLooRG6ekH8i7h3Ne4TZMhU4+sjzAtyq9ZrXFUFlOj4uQ==
X-Received: by 2002:a17:902:ea02:b0:19a:841f:56 with SMTP id s2-20020a170902ea0200b0019a841f0056mr6973066plg.20.1676551681144;
        Thu, 16 Feb 2023 04:48:01 -0800 (PST)
Received: from localhost.localdomain ([2001:470:f2c0:1000::53])
        by smtp.gmail.com with ESMTPSA id p2-20020a1709026b8200b001992e74d058sm1262058plk.7.2023.02.16.04.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 04:48:00 -0800 (PST)
From:   Qingfang DENG <dqfext@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, Shell Chen <xierch@gmail.com>
Subject: [PATCH 5.15,5.10,5.4,4.19] netfilter: nft_tproxy: restrict to prerouting hook
Date:   Thu, 16 Feb 2023 20:47:55 +0800
Message-Id: <20230216124755.51762-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 18bbc3213383a82b05383827f4b1b882e3f0a5a5 upstream.

TPROXY is only allowed from prerouting, but nft_tproxy doesn't check this.
This fixes a crash (null dereference) when using tproxy from e.g. output.

Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Reported-by: Shell Chen <xierch@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Qingfang DENG <dqfext@gmail.com>
---
 net/netfilter/nft_tproxy.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -312,6 +312,13 @@ static int nft_tproxy_dump(struct sk_buf
 	return 0;
 }
 
+static int nft_tproxy_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, 1 << NF_INET_PRE_ROUTING);
+}
+
 static struct nft_expr_type nft_tproxy_type;
 static const struct nft_expr_ops nft_tproxy_ops = {
 	.type		= &nft_tproxy_type,
@@ -320,6 +327,7 @@ static const struct nft_expr_ops nft_tpr
 	.init		= nft_tproxy_init,
 	.destroy	= nft_tproxy_destroy,
 	.dump		= nft_tproxy_dump,
+	.validate	= nft_tproxy_validate,
 };
 
 static struct nft_expr_type nft_tproxy_type __read_mostly = {
