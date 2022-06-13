Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851A2548F8F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349213AbiFMMQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358844AbiFMMOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:14:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2949B54BCC;
        Mon, 13 Jun 2022 04:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B58BAB80E92;
        Mon, 13 Jun 2022 11:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27894C34114;
        Mon, 13 Jun 2022 11:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118120;
        bh=D+zeTU6SXXi0V2t/Dy+iOTkgmgB5f1gBGleEo3rDDCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUsS2f/fkFhIcdm3E3E0fWjePXLgifQmsPe/SXCmvA4w8H4fnktawmxHSySS2CnI3
         JfsQRgE5ms+rXtL/oOJZohgk7+3Sa+KCN3FyRGn5OIwmtZp4htYH5Ez6Gik1cHro04
         DT4XRxVz7VY0rh72KRgxJ4sxCzuGIU0CcyvdMpfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 243/287] net: ipv6: unexport __init-annotated seg6_hmac_init()
Date:   Mon, 13 Jun 2022 12:11:07 +0200
Message-Id: <20220613094931.384937546@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 5801f064e35181c71857a80ff18af4dbec3c5f5c ]

EXPORT_SYMBOL and __init is a bad combination because the .init.text
section is freed up after the initialization. Hence, modules cannot
use symbols annotated __init. The access to a freed symbol may end up
with kernel panic.

modpost used to detect it, but it has been broken for a decade.

Recently, I fixed modpost so it started to warn it again, then this
showed up in linux-next builds.

There are two ways to fix it:

  - Remove __init
  - Remove EXPORT_SYMBOL

I chose the latter for this case because the caller (net/ipv6/seg6.c)
and the callee (net/ipv6/seg6_hmac.c) belong to the same module.
It seems an internal function call in ipv6.ko.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_hmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 8546f94f30d4..a886a8f4c0cb 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -406,7 +406,6 @@ int __init seg6_hmac_init(void)
 {
 	return seg6_hmac_init_algo();
 }
-EXPORT_SYMBOL(seg6_hmac_init);
 
 int __net_init seg6_hmac_net_init(struct net *net)
 {
-- 
2.35.1



