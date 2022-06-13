Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A586954953A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352073AbiFMMlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351545AbiFMMiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:38:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FEE5C373;
        Mon, 13 Jun 2022 04:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1A61608D6;
        Mon, 13 Jun 2022 11:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006F2C3411C;
        Mon, 13 Jun 2022 11:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118488;
        bh=hU62tz+upeQQ0ixMl73jGcb/66oi/GX988epYqit+zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ct0/7Q8KiikhTJmlHLmh9XJ6ld2MyNoUsUrB8pXaKUiVoCTNR7tdNdSzyqo+GA90k
         1CQV4NNiUkxVvCV6UWGgk4hoRopX0L1nKqsZAWTvkUYTuVuFrCKFkk66wVSDfaStma
         8IhplwuZlvPPoSwbEyyyCK3cEz/tVZPNtYq69J+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gong Yuanjun <ruc_gongyuanjun@163.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/172] mips: cpc: Fix refcount leak in mips_cpc_default_phys_base
Date:   Mon, 13 Jun 2022 12:10:36 +0200
Message-Id: <20220613094908.660511109@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Gong Yuanjun <ruc_gongyuanjun@163.com>

[ Upstream commit 4107fa700f314592850e2c64608f6ede4c077476 ]

Add the missing of_node_put() to release the refcount incremented
by of_find_compatible_node().

Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/mips-cpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/mips-cpc.c b/arch/mips/kernel/mips-cpc.c
index 8d2535123f11..d005be84c482 100644
--- a/arch/mips/kernel/mips-cpc.c
+++ b/arch/mips/kernel/mips-cpc.c
@@ -27,6 +27,7 @@ phys_addr_t __weak mips_cpc_default_phys_base(void)
 	cpc_node = of_find_compatible_node(of_root, NULL, "mti,mips-cpc");
 	if (cpc_node) {
 		err = of_address_to_resource(cpc_node, 0, &res);
+		of_node_put(cpc_node);
 		if (!err)
 			return res.start;
 	}
-- 
2.35.1



