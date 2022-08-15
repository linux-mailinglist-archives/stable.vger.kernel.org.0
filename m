Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60163594021
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346745AbiHOUyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346758AbiHOUyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:54:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1663A4A5;
        Mon, 15 Aug 2022 12:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 337B160EEE;
        Mon, 15 Aug 2022 19:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242B4C433D7;
        Mon, 15 Aug 2022 19:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590641;
        bh=MQPmSWW6qeTKmvxX5Idg4ZN9rJsHVGsA5UzbeucL58s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKn8DHCgI1dbV5KK5J2/NtEQAQMDTXn3t90mZM29qedn27oUtvIHr0SFuT32YTDDe
         5yyLAYJCv7adyZtXS1JrtJCG/x8Ad4YWhVNSQ69sptdmpaOHL/hhOmbkluvUys1Veu
         PwBSle+NlyKDLiMyz6atAllrwaSTA02AvFNLD/c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0297/1095] dm: return early from dm_pr_call() if DM device is suspended
Date:   Mon, 15 Aug 2022 19:54:56 +0200
Message-Id: <20220815180442.052684666@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit e120a5f1e78fab6223544e425015f393d90d6f0d ]

Otherwise PR ops may be issued while the broader DM device is being
reconfigured, etc.

Fixes: 9c72bad1f31a ("dm: call PR reserve/unreserve on each underlying device")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f01d33bc3613..e0e28a3203f8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2955,6 +2955,11 @@ static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
 		goto out;
 	ti = dm_table_get_target(table, 0);
 
+	if (dm_suspended_md(md)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	ret = -EINVAL;
 	if (!ti->type->iterate_devices)
 		goto out;
-- 
2.35.1



