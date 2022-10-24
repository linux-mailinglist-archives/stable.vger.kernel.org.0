Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0047360B267
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbiJXQq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiJXQpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:45:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BC218B48E;
        Mon, 24 Oct 2022 08:31:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38D1AB818E5;
        Mon, 24 Oct 2022 12:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AC9C433C1;
        Mon, 24 Oct 2022 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615153;
        bh=KLXaFQT2JlFqTccYwn76fcGTCiyc8m5psLPMQV9qgJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSFLJ3sONUy4pydNE5MZzHF+oIvIn9bjLEVjgtroaVWRtVimnSB7LZXiDkYXBNWya
         CbxAcKmFGnftGwImL3Cwz4BxbnZuI97SRWKZVGJe7Xo26bfZNeW5HMI0X6dIajeFU8
         5LoJYbeTYm9MoLFuRViiSZvcdt8aQSljmjSk0SqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/530] ARM: 9244/1: dump: Fix wrong pg_level in walk_pmd()
Date:   Mon, 24 Oct 2022 13:28:07 +0200
Message-Id: <20221024113051.549719948@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Kefeng <wangkefeng.wang@huawei.com>

[ Upstream commit 2ccd19b3ffac07cc7e75a2bd1ed779728bb67197 ]

After ARM supports p4d page tables, the pg_level for note_page()
in walk_pmd() should be 4, not 3, fix it.

Fixes: 84e6ffb2c49c ("arm: add support for folded p4d page tables")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index fb688003d156..712da6a81b23 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -346,7 +346,7 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
 		addr = start + i * PMD_SIZE;
 		domain = get_domain_name(pmd);
 		if (pmd_none(*pmd) || pmd_large(*pmd) || !pmd_present(*pmd))
-			note_page(st, addr, 3, pmd_val(*pmd), domain);
+			note_page(st, addr, 4, pmd_val(*pmd), domain);
 		else
 			walk_pte(st, pmd, addr, domain);
 
-- 
2.35.1



