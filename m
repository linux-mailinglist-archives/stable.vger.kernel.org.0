Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD246B44B2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjCJO10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbjCJO1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:27:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DF214209
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D7CF6195C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94063C433D2;
        Fri, 10 Mar 2023 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458327;
        bh=DOJb9D9BCzW3Ov2ZRHdmfpQJEmbgq9MfKARRJQ76lqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vX9FsvdG2kUDO7hFR8O86E5UXcOtzT1f6RlwLfVlWu82gg+WXMSXoiO6d+n2PQF7Y
         hADiuypfKsgIUyh4dGvVvRQlgcVq4LGqGFtryLqtEzERZ1hNeTxI5O+6irTk07yajU
         YD6+kY7kig4AFQw/7zqPf20urpPMy4lwQJbCOoTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mathias Nyman <mathias.nyman@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 241/252] usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math
Date:   Fri, 10 Mar 2023 14:40:11 +0100
Message-Id: <20230310133726.767696354@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 32e1585687885..fc9d6189c310f 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -31,7 +31,7 @@ static void xhci_mvebu_mbus_config(void __iomem *base,
 
 	/* Program each DRAM CS in a seperate window */
 	for (win = 0; win < dram->num_cs; win++) {
-		const struct mbus_dram_window *cs = dram->cs + win;
+		const struct mbus_dram_window *cs = &dram->cs[win];
 
 		writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
 		       (dram->mbus_dram_target_id << 4) | 1,
-- 
2.39.2



