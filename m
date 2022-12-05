Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F33643431
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiLETnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbiLETmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:42:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7627F24BEC
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E37D9CE10A6
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D76C433C1;
        Mon,  5 Dec 2022 19:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269207;
        bh=8wfRChrTQwzgxhI7pfWZUMcVW6opy72oA2rrv+A24OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcB0yeTWhzWzfMjxxgU7kKHvtbBDv/M7oimVqUKX7xZnaYedPPXpSKM+u5FyInGjV
         onXrwcXHqBseYD6hw016U+sODIxdppu7OPChLZHOC1SW2rqe0ite3/L9+cpBtUNlNL
         qkwCkmDXnQyazWqfoDh4Bm1l7RQl6AWPzBti/pL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Liao <liaoyu15@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/153] net: thunderx: Fix the ACPI memory leak
Date:   Mon,  5 Dec 2022 20:09:26 +0100
Message-Id: <20221205190809.929253793@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Liao <liaoyu15@huawei.com>

[ Upstream commit 661e5ebbafd26d9d2e3c749f5cf591e55c7364f5 ]

The ACPI buffer memory (string.pointer) should be freed as the buffer is
not used after returning from bgx_acpi_match_id(), free it to prevent
memory leak.

Fixes: 46b903a01c05 ("net, thunder, bgx: Add support to get MAC address from ACPI.")
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Link: https://lore.kernel.org/r/20221123082237.1220521-1-liaoyu15@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index 76ff42ec3ae5..a34c33e8a8ad 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1438,8 +1438,10 @@ static acpi_status bgx_acpi_match_id(acpi_handle handle, u32 lvl,
 		return AE_OK;
 	}
 
-	if (strncmp(string.pointer, bgx_sel, 4))
+	if (strncmp(string.pointer, bgx_sel, 4)) {
+		kfree(string.pointer);
 		return AE_OK;
+	}
 
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
 			    bgx_acpi_register_phy, NULL, bgx, NULL);
-- 
2.35.1



