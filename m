Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873A6548C4F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354848AbiFMLkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355576AbiFMLjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:39:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0D923BFC;
        Mon, 13 Jun 2022 03:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B59FDB80E59;
        Mon, 13 Jun 2022 10:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26373C34114;
        Mon, 13 Jun 2022 10:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117336;
        bh=TCgG5lsX2SgS9b2cEbyOiJ4GzHluh7fnO16w+FMHkjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUlP+x8d9+DStfdIRBJLfOIh+uQaFsaF0VJ/FSNjnf7yHeb076XARyomZ/14KBzhn
         nYrYH83/xLb0W1kugMknyHeJbPcIAroQsLXE+XWGjljnIylb/wsAG0w/6YRZMaaVT4
         Mg9vB+jU8luLxHCRmWfQY8GXs/E4wKjzQ6JHTRWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 358/411] net: xfrm: unexport __init-annotated xfrm4_protocol_init()
Date:   Mon, 13 Jun 2022 12:10:31 +0200
Message-Id: <20220613094939.430367139@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 8a4285712808..9031b7732fec 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -298,4 +298,3 @@ void __init xfrm4_protocol_init(void)
 {
 	xfrm_input_register_afinfo(&xfrm4_input_afinfo);
 }
-EXPORT_SYMBOL(xfrm4_protocol_init);
-- 
2.35.1



