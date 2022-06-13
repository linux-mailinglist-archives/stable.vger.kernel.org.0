Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05B4548F64
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379017AbiFMNqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378294AbiFMNm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:42:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125742AE0A;
        Mon, 13 Jun 2022 04:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4534B80E59;
        Mon, 13 Jun 2022 11:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19169C34114;
        Mon, 13 Jun 2022 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119889;
        bh=mNMKCj7YmZGHq44rzzYxEBmfMtk9Q5va+TOc/sbYdvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+uQY6RzGpK/majq9vt0XWLb3pUCIWHDyDC1HcvZwOIH/ApCYqHhfn9yaala2vo8t
         iehW7Q1dLJjcGmJYfeufQBAKRf04gcDwnjUFYIeaQBqfvbLE7/bWXXn8hK2SAK+RWw
         nMgaNEaNt2mZVQDx3pvkyA0Dar38XdvB4JSynK1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gong Yuanjun <ruc_gongyuanjun@163.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 155/339] mips: cpc: Fix refcount leak in mips_cpc_default_phys_base
Date:   Mon, 13 Jun 2022 12:09:40 +0200
Message-Id: <20220613094931.387291407@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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
index 17aff13cd7ce..3e386f7e1545 100644
--- a/arch/mips/kernel/mips-cpc.c
+++ b/arch/mips/kernel/mips-cpc.c
@@ -28,6 +28,7 @@ phys_addr_t __weak mips_cpc_default_phys_base(void)
 	cpc_node = of_find_compatible_node(of_root, NULL, "mti,mips-cpc");
 	if (cpc_node) {
 		err = of_address_to_resource(cpc_node, 0, &res);
+		of_node_put(cpc_node);
 		if (!err)
 			return res.start;
 	}
-- 
2.35.1



