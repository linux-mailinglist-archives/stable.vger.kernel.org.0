Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C177548C2B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245625AbiFMKaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244885AbiFMK1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845A4248E1;
        Mon, 13 Jun 2022 03:19:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E65E60AE6;
        Mon, 13 Jun 2022 10:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A544C3411E;
        Mon, 13 Jun 2022 10:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115591;
        bh=ed7VVvdw4t2MKJRqh0XTJkAClqEeyiyAAAC9Zn40VzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLyBycWkTNKexXYgLCVxizy+1H1gCryYYAnrQ4BCAy9AAT5YFkfNK6lLBmQ+Maw8I
         wza0GZLnipCK2obmZwrmwtCrifMg0PFvYkqb7uFb3zYxggUXLiUyII2XVIch27f9r4
         2KfagM3LLonUCPKPDg2Gp0O4AJKh1JemZ9AytdSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Zheyu Ma <zheyuma97@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 140/167] tty: synclink_gt: Fix null-pointer-dereference in slgt_clean()
Date:   Mon, 13 Jun 2022 12:10:14 +0200
Message-Id: <20220613094913.700228741@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 689ca31c542687709ba21ec2195c1fbce34fd029 ]

When the driver fails at alloc_hdlcdev(), and then we remove the driver
module, we will get the following splat:

[   25.065966] general protection fault, probably for non-canonical address 0xdffffc0000000182: 0000 [#1] PREEMPT SMP KASAN PTI
[   25.066914] KASAN: null-ptr-deref in range [0x0000000000000c10-0x0000000000000c17]
[   25.069262] RIP: 0010:detach_hdlc_protocol+0x2a/0x3e0
[   25.077709] Call Trace:
[   25.077924]  <TASK>
[   25.078108]  unregister_hdlc_device+0x16/0x30
[   25.078481]  slgt_cleanup+0x157/0x9f0 [synclink_gt]

Fix this by checking whether the 'info->netdev' is a null pointer first.

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/20220410114814.3920474-1-zheyuma97@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/synclink_gt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 7446ce29f677..b5d053763263 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1823,6 +1823,8 @@ static int hdlcdev_init(struct slgt_info *info)
  */
 static void hdlcdev_exit(struct slgt_info *info)
 {
+	if (!info->netdev)
+		return;
 	unregister_hdlc_device(info->netdev);
 	free_netdev(info->netdev);
 	info->netdev = NULL;
-- 
2.35.1



