Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5766B561BFB
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbiF3NtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbiF3Nso (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA4713F5C;
        Thu, 30 Jun 2022 06:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 564CB61FFB;
        Thu, 30 Jun 2022 13:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DA4C3411E;
        Thu, 30 Jun 2022 13:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596914;
        bh=UqT7Ezn9pWtS5CRV1aEcCh3rXLPAeHPdmaWs4yzft/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArQP9zZu3hIqkyl69OvTsVBDSxRWZ7o+tr6n5OG83dvhbOf/hhIVfzEiA03cSHaaT
         NPNkdrn803Ms0wTxhIGCbYDtT+9hnq9y3JnLhG8yDR0pS8TvYiJo/2qrcmxNyetaR5
         Wgvu8kC5LD1EFmJkoIDigal5/Wnv1I0mHwctA2Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.9 26/29] xen: unexport __init-annotated xen_xlate_map_ballooned_pages()
Date:   Thu, 30 Jun 2022 15:46:26 +0200
Message-Id: <20220630133231.972554082@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit dbac14a5a05ff8e1ce7c0da0e1f520ce39ec62ea upstream.

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

I chose the latter for this case because none of the in-tree call-sites
(arch/arm/xen/enlighten.c, arch/x86/xen/grant-table.c) is compiled as
modular.

Fixes: 243848fc018c ("xen/grant-table: Move xlated_setup_gnttab_pages to common place")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Acked-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/20220606045920.4161881-1-masahiroy@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xlate_mmu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -262,4 +262,3 @@ int __init xen_xlate_map_ballooned_pages
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(xen_xlate_map_ballooned_pages);


