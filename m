Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0F9628063
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbiKNNFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbiKNNFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A7D2A434
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE6C5B80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6EDC433D6;
        Mon, 14 Nov 2022 13:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431130;
        bh=6wZbWtX0447m3dqN179O85Iu8PadKz4h4y/HDJ8kDI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8Za4k1lpwxTW/9R3rYWuaPKghXT6gySmV7HOx2qxwNWjjkdJSOHcga4u1IQQGQFe
         F5GC8maXld46JgMZcNmll/D5KESRDxmdMucJcdu5jXLVEXiNtJ8PmUiobSPfQUZxK7
         NIjuAU3rvw6DOYwp16OhB0KiaGNV2ey8SS+42BLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Antoine Tenart <atenart@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 104/190] net: phy: mscc: macsec: clear encryption keys when freeing a flow
Date:   Mon, 14 Nov 2022 13:45:28 +0100
Message-Id: <20221114124503.240160472@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 1b16b3fdf675cca15a537572bac50cc5354368fc ]

Commit aaab73f8fba4 ("macsec: clear encryption keys from the stack after
setting up offload") made sure to clean encryption keys from the stack
after setting up offloading, but the MSCC PHY driver made a copy, kept
it in the flow data and did not clear it when freeing a flow. Fix this.

Fixes: 28c5107aa904 ("net: phy: mscc: macsec support")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index b7b2521c73fb..c00eef457b85 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -632,6 +632,7 @@ static void vsc8584_macsec_free_flow(struct vsc8531_private *priv,
 
 	list_del(&flow->list);
 	clear_bit(flow->index, bitmap);
+	memzero_explicit(flow->key, sizeof(flow->key));
 	kfree(flow);
 }
 
-- 
2.35.1



