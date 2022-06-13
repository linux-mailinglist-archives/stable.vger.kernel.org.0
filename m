Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC46954964B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351391AbiFMMUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357644AbiFMMT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:19:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A467A563BC;
        Mon, 13 Jun 2022 04:02:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65B0860F9A;
        Mon, 13 Jun 2022 11:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D69C34114;
        Mon, 13 Jun 2022 11:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118172;
        bh=kxf9ci/BCQtqhZJhZS8r0uz52LFijqgOzZISz+S4H7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UE5xET1yeMh+4rekEd1fs6h9B50QdNAxK/sDSKL8HBmhsvgrn2x8OqvaWQHINpGSx
         91fOM5/a1Ss6+mLY7blD6VdUoF+7soL60pcbRbRVHZPyGe3BLP9JPHK3Vl04U4vbnp
         k0isyMrOXiGRBTGfMwH8XQZBVyG4HH9bc3WXstDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 242/287] net: xfrm: unexport __init-annotated xfrm4_protocol_init()
Date:   Mon, 13 Jun 2022 12:11:06 +0200
Message-Id: <20220613094931.354158950@linuxfoundation.org>
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

[ Upstream commit 4a388f08d8784af48f352193d2b72aaf167a57a1 ]

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

I chose the latter for this case because the only in-tree call-site,
net/ipv4/xfrm4_policy.c is never compiled as modular.
(CONFIG_XFRM is boolean)

Fixes: 2f32b51b609f ("xfrm: Introduce xfrm_input_afinfo to access the the callbacks properly")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/xfrm4_protocol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/xfrm4_protocol.c b/net/ipv4/xfrm4_protocol.c
index 8dd0e6ab8606..0e1f5dc2766b 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -297,4 +297,3 @@ void __init xfrm4_protocol_init(void)
 {
 	xfrm_input_register_afinfo(&xfrm4_input_afinfo);
 }
-EXPORT_SYMBOL(xfrm4_protocol_init);
-- 
2.35.1



