Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A490694A39
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjBMPFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjBMPF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:05:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E138A1D932
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CB5EB81256
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC24C433AC;
        Mon, 13 Feb 2023 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300718;
        bh=W6c0zlTCwaL0Bm1yT9ofMMh4BTpC3Ohw2V+ilySlOvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOqK3JctdxDY7mdGcVkNYKan3L6zTb/r70L3ylXj82uJVHSdZ24pXorINGimg1tx7
         lY2TCJAs+aDu/nt7OJvHQajowU/loJIpsyoEOc4iJwUkeEn5zGQgpo+OGXYyJO3jhR
         pEpmonZCB7KEEC3NtsEM+Ps2JHxPTs+h0yzIdkvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willem de Bruijn <willemb@google.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/139] rds: rds_rm_zerocopy_callback() use list_first_entry()
Date:   Mon, 13 Feb 2023 15:51:06 +0100
Message-Id: <20230213144752.296427595@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit f753a68980cf4b59a80fe677619da2b1804f526d ]

rds_rm_zerocopy_callback() uses list_entry() on the head of a list
causing a type confusion.
Use list_first_entry() to actually access the first element of the
rs_zcookie_queue list.

Fixes: 9426bbc6de99 ("rds: use list structure to track information for zerocopy completion notification")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230202-rds-zerocopy-v3-1-83b0df974f9a@diag.uniroma1.it
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 799034e0f513d..b363ef13c75ef 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -104,9 +104,9 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	spin_lock_irqsave(&q->lock, flags);
 	head = &q->zcookie_head;
 	if (!list_empty(head)) {
-		info = list_entry(head, struct rds_msg_zcopy_info,
-				  rs_zcookie_next);
-		if (info && rds_zcookie_add(info, cookie)) {
+		info = list_first_entry(head, struct rds_msg_zcopy_info,
+					rs_zcookie_next);
+		if (rds_zcookie_add(info, cookie)) {
 			spin_unlock_irqrestore(&q->lock, flags);
 			kfree(rds_info_from_znotifier(znotif));
 			/* caller invokes rds_wake_sk_sleep() */
-- 
2.39.0



