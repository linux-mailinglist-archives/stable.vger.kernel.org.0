Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF255949B5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346178AbiHOXNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346501AbiHOXM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:12:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB564F6A5;
        Mon, 15 Aug 2022 13:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 242AE61226;
        Mon, 15 Aug 2022 20:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AD4C4347C;
        Mon, 15 Aug 2022 20:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593630;
        bh=Z7UlqukebFuVLq80n+Ua2EWCCAvah8jL9gd5gLz6sek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4xCYohuMnG0pS5y1jLrpoV6/KKK7a7oISRUVtPeVKp2116zlhaNCRABQOvtXW2aV
         hgI0z8qG5uHymYrAomHToQZXwkp6fJXsKUXCB9DGMH71YbW1i5pOcMrEu75bRNsRAP
         JL25Je1S3UhKAOYnTiNIWyri6XhKbaSAMXB5A0ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0299/1157] dm: return early from dm_pr_call() if DM device is suspended
Date:   Mon, 15 Aug 2022 19:54:15 +0200
Message-Id: <20220815180451.609414372@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 2b75f1ef7386..7c5d4734f109 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3066,6 +3066,11 @@ static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
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



