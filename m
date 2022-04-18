Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D325050F4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbiDRMaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239181AbiDRM1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:27:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BB01EEFD;
        Mon, 18 Apr 2022 05:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E737FB80EDC;
        Mon, 18 Apr 2022 12:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134B9C385A8;
        Mon, 18 Apr 2022 12:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284484;
        bh=Tz8etSiYKMM7cHcBHuerXjlDFxuy+vKXDjCA1BuI+eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xG3Ioe5uyA4Wjt2g53MXx/9PLLNGDon2OU3OgW3t9ibAfgjCniWUARtDlMa6yr00x
         bMfesURg0pz6g1L3rjai31xxa9h36Ng53bTKJkYtlB4nGIKtLpWVmsejPC5QLnWRIi
         PGQgalmIhLR0Wdlmdsjnhj1fG8AQ3bRpVodi2TKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 106/219] netfilter: nf_tables: nft_parse_register can return a negative value
Date:   Mon, 18 Apr 2022 14:11:15 +0200
Message-Id: <20220418121209.864337143@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 6c6f9f31ecd47dce1d0dafca4bec8805f9bc97cd ]

Since commit 6e1acfa387b9 ("netfilter: nf_tables: validate registers
coming from userspace.") nft_parse_register can return a negative value,
but the function prototype is still returning an unsigned int.

Fixes: 6e1acfa387b9 ("netfilter: nf_tables: validate registers coming from userspace.")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1f5a0eece0d1..30d29d038d09 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9275,7 +9275,7 @@ int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest)
 }
 EXPORT_SYMBOL_GPL(nft_parse_u32_check);
 
-static unsigned int nft_parse_register(const struct nlattr *attr, u32 *preg)
+static int nft_parse_register(const struct nlattr *attr, u32 *preg)
 {
 	unsigned int reg;
 
-- 
2.35.1



