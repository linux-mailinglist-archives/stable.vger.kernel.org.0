Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EF764A062
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiLLNYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbiLLNYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:24:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A22D56
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:24:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E44BB80D4D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A21BC433EF;
        Mon, 12 Dec 2022 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851469;
        bh=P9gD8F6K7Qd9SFGHwEQIYmN8W4xchkkI6TM8rX8ZJz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv/gQ0VAiNmwobINbPo8KTnMY5W96slZx5KC4FLSWDPa8FEegzE5+2H8N2qCOQgLE
         yNg7xNTjFzXq7GdNcfT9Rl/ca6f1w21Zh3UxEda+c1YB4IVDofMTC5v84ebxXMc2i4
         2oabMwRRSttYgQ+MvReVe0oxvlgvJVx356huaig4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        Jason Andryuk <jandryuk@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 63/67] xen/netback: fix build warning
Date:   Mon, 12 Dec 2022 14:17:38 +0100
Message-Id: <20221212130920.618822187@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
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
index 982e501173f1..036459670fc3 100644
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



