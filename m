Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938F1551B29
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344199AbiFTNZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344854AbiFTNXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:23:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B95E23140;
        Mon, 20 Jun 2022 06:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17B9E60A52;
        Mon, 20 Jun 2022 13:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176FEC3411B;
        Mon, 20 Jun 2022 13:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730478;
        bh=Gcz5MMh+luo1mAG0oh47gcojUkta080KEWA+pDrqFIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCYKT181d1YEIE2jxT5dYMH8xOyZnMCWMoOjfAM180ac+5EQ8JzITdWvMEs6y+oNi
         xT7B5kl1SuuyNK1JtbrIgRIIGFK04OkR0SA8izA/o+ymeft5G0yN27KBuqhN37Di/9
         M2m7g6iZTQCGuktJT93U99aheZNspqDUosIX1WAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/106] nvme: add device name to warning in uuid_show()
Date:   Mon, 20 Jun 2022 14:51:23 +0200
Message-Id: <20220620124726.295117925@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 1fc766b5c08417248e0008bca14c3572ac0f1c26 ]

This provides more context to users.

Old message:

[   00.000000] No UUID available providing old NGUID

New message:

[   00.000000] block nvme0n1: No UUID available providing old NGUID

Fixes: d934f9848a77 ("nvme: provide UUID value to userspace")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index af355b9ee5ea..9bc9f6d225bd 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3182,8 +3182,8 @@ static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
 	 * we have no UUID set
 	 */
 	if (uuid_is_null(&ids->uuid)) {
-		printk_ratelimited(KERN_WARNING
-				   "No UUID available providing old NGUID\n");
+		dev_warn_ratelimited(dev,
+			"No UUID available providing old NGUID\n");
 		return sysfs_emit(buf, "%pU\n", ids->nguid);
 	}
 	return sysfs_emit(buf, "%pU\n", &ids->uuid);
-- 
2.35.1



