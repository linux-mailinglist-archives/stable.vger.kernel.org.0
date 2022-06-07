Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826685409A3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243911AbiFGSLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349797AbiFGSI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7276B7D7;
        Tue,  7 Jun 2022 10:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 933DC6174D;
        Tue,  7 Jun 2022 17:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBCFC341C6;
        Tue,  7 Jun 2022 17:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624093;
        bh=G1gax5Xss8HQPWq41h/Wu8k+afvXNnM5IWX6Ml/e6dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YA1/0gujFj0LhQET7WhYQ1phujpjsD+sg7wGRK1QmoIqEgyzFjPh9VCVUV7Aw5t4d
         WBMKxbGODNWHfEtdICKomfMw3q8Pw/07xf2o+ydQQJd5ujc5eoOromLjQ0G+2HAgp1
         zl2zCthVF40uYWaKD6eMMkEf5qlUaCvrPtXUEY+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/667] powerpc/xics: fix refcount leak in icp_opal_init()
Date:   Tue,  7 Jun 2022 18:57:20 +0200
Message-Id: <20220607164940.059418881@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 5dd9e27ea4a39f7edd4bf81e9e70208e7ac0b7c9 ]

The of_find_compatible_node() function returns a node pointer with
refcount incremented, use of_node_put() on it when done.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220402013419.2410298-1-lv.ruyi@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xics/icp-opal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/xics/icp-opal.c b/arch/powerpc/sysdev/xics/icp-opal.c
index 675d708863d5..db0452e7c351 100644
--- a/arch/powerpc/sysdev/xics/icp-opal.c
+++ b/arch/powerpc/sysdev/xics/icp-opal.c
@@ -196,6 +196,7 @@ int icp_opal_init(void)
 
 	printk("XICS: Using OPAL ICP fallbacks\n");
 
+	of_node_put(np);
 	return 0;
 }
 
-- 
2.35.1



