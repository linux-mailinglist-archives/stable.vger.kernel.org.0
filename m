Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF21F64A241
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiLLNvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiLLNvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:51:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C12CE2D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:50:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08D7961068
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1991C433D2;
        Mon, 12 Dec 2022 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853040;
        bh=3Idp924/+RbxfCg//MoYbBmpFnPYxyD7/AIr3Dqwz0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dmDSLi2WyfBorxDrwGfQIS29Jtb/BdKBV9CRAR65b/Z1TZHYkOLvUDf6D/aQkT7u
         Kqet3LlNZqzE1KT5eWCYz0ThGPacK6uGPJir065367VtFzA3R741fEUeNF45tWv0G2
         ZKrS5l+qL7veHU6U7Db0l+iKGU2Sk4IX0FdYlHmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        Jason Andryuk <jandryuk@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/49] xen/netback: fix build warning
Date:   Mon, 12 Dec 2022 14:19:23 +0100
Message-Id: <20221212130915.921390898@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 7dfa764e0223a324366a2a1fc056d4d9d4e95491 ]

Commit ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in
the non-linear area") introduced a (valid) build warning. There have
even been reports of this problem breaking networking of Xen guests.

Fixes: ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in the non-linear area")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Tested-by: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 72379dae113a..fc389f2bba7a 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -523,7 +523,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 	const bool sharedslot = nr_frags &&
 				frag_get_pending_idx(&shinfo->frags[0]) ==
 				    copy_pending_idx(skb, copy_count(skb) - 1);
-	int i, err;
+	int i, err = 0;
 
 	for (i = 0; i < copy_count(skb); i++) {
 		int newerr;
-- 
2.35.1



