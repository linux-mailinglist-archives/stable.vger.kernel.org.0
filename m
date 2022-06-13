Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F64548999
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbiFMMPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354890AbiFMMNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0FD53C40;
        Mon, 13 Jun 2022 04:01:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCA3F613E9;
        Mon, 13 Jun 2022 11:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFFFC3411E;
        Mon, 13 Jun 2022 11:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118077;
        bh=/gEi9uoEGtw9vFKpk5iTBlPbocY+K5T7zTqsewRdOx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHSwCJI1ehiwbViH2s20jWthrXw9vmLSgpAjEgkm8yz0jGhBS4ExXikFzfmlMA5dp
         p5ChUlihtWCbdLmFLUMzg6jWTOV6iSfQtg+y8c8Y3JXnXDipqVoysu6g898BMGd7sj
         qHo53FwfhpZZ9jhR33bzPAqRO1T2vBovyIDGnOV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gong Yuanjun <ruc_gongyuanjun@163.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 227/287] mips: cpc: Fix refcount leak in mips_cpc_default_phys_base
Date:   Mon, 13 Jun 2022 12:10:51 +0200
Message-Id: <20220613094930.898195079@linuxfoundation.org>
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
index fcf9af492d60..cf46502c605e 100644
--- a/arch/mips/kernel/mips-cpc.c
+++ b/arch/mips/kernel/mips-cpc.c
@@ -31,6 +31,7 @@ phys_addr_t __weak mips_cpc_default_phys_base(void)
 	cpc_node = of_find_compatible_node(of_root, NULL, "mti,mips-cpc");
 	if (cpc_node) {
 		err = of_address_to_resource(cpc_node, 0, &res);
+		of_node_put(cpc_node);
 		if (!err)
 			return res.start;
 	}
-- 
2.35.1



