Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B8E6AA584
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 00:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCCXWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 18:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCCXWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 18:22:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EEB6546A;
        Fri,  3 Mar 2023 15:22:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D80A61924;
        Fri,  3 Mar 2023 21:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A22C433A4;
        Fri,  3 Mar 2023 21:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880006;
        bh=wDxj7FhvjGXHLOc1G1+M2svS9AIQWKygABX4YgPxts0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqhDUreyo+OaeB7v4iSJKEP4ehVYg6R4GU+EdgyFThcLopcn5qOkvTAysqfwk4/TT
         /J6KvOhsaNw+tlA0cz9DwiD6X1oHMdu2ScWxPUkw0naougxv/UK4Lx9f9DMM0ndAK0
         2nHomGQz7ChF+xR2NjpKCX7kdwc30uBZduuaTqbixuEuhLhY3gbDurC1ZQ3g49RoKn
         Ny4Y4KOd7DwY8t50I77SUIWMewQXdb91X6/7xfplRcP9j6MTsg88MwkMKOXxNvpbhU
         rY2hcU5dbqsS7MLieoFu0bR7s6EUnCBK5P+Pl65/UO+cYdNo/QffNKjqkRokYuiEze
         NzyGVBcsi0CuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 33/50] usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math
Date:   Fri,  3 Mar 2023 16:45:14 -0500
Message-Id: <20230303214531.1450154-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 0fbd2cda92cdb00f72080665554a586f88bca821 ]

Walking the dram->cs array was seen as accesses beyond the first array
item by the compiler. Instead, use the array index directly. This allows
for run-time bounds checking under CONFIG_UBSAN_BOUNDS as well. Seen
with GCC 13 with -fstrict-flex-arrays:

In function 'xhci_mvebu_mbus_config',
    inlined from 'xhci_mvebu_mbus_init_quirk' at ../drivers/usb/host/xhci-mvebu.c:66:2:
../drivers/usb/host/xhci-mvebu.c:37:28: warning: array subscript 0 is outside array bounds of 'const struct mbus_dram_window[0]' [-Warray-bounds=]
   37 |                 writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
      |                          ~~^~~~~~

Cc: Mathias Nyman <mathias.nyman@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230204183651.never.663-kees@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mvebu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
index 8ca1a235d1645..eabccf25796b2 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -33,7 +33,7 @@ static void xhci_mvebu_mbus_config(void __iomem *base,
 
 	/* Program each DRAM CS in a seperate window */
 	for (win = 0; win < dram->num_cs; win++) {
-		const struct mbus_dram_window *cs = dram->cs + win;
+		const struct mbus_dram_window *cs = &dram->cs[win];
 
 		writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
 		       (dram->mbus_dram_target_id << 4) | 1,
-- 
2.39.2

