Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24163540BF8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349982AbiFGSdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352535AbiFGSbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9597417B87A;
        Tue,  7 Jun 2022 10:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D161DB82373;
        Tue,  7 Jun 2022 17:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80A8C3411F;
        Tue,  7 Jun 2022 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624584;
        bh=EbHpsNQsZRgTMF45CSYfLlirVAaStJQ+cyuj+aVwgLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBJj9869wU0qgysbyPlB5vl0cdMfEkxwW9s9jTM+O3/QFmxerXjVZ4Bj2FMuNaor9
         70lOtLfSPQ2thI9576tlXzO5AVZgb3biWzBunB6ouzMjNE8S2JaUof/5B86V12bk9v
         oyghVQECqIHoKTJ7XkWjZUVe1to4VM8yTeVvL3ha7yxPYFCmQOolh/6nKyyjlKS1PP
         o3yLXPhoJB1J9b8NXDOdWBuB1/lZW7LBOchjvwqsCY5tCKAi5PhjFDsnnAImOmtuDp
         KZ3iZFzVrDjZk30zJQjLyRhByD/HBCe0q43S+1ebsvJSkOrpoHqu6nxFowLe82VvnD
         5miV7/RKPKnyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 07/51] tty: synclink_gt: Fix null-pointer-dereference in slgt_clean()
Date:   Tue,  7 Jun 2022 13:55:06 -0400
Message-Id: <20220607175552.479948-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 25c558e65ece..9bc2a9265277 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1746,6 +1746,8 @@ static int hdlcdev_init(struct slgt_info *info)
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

