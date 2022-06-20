Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4593A551C33
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343841AbiFTNQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245521AbiFTNPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:15:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40F1205DB;
        Mon, 20 Jun 2022 06:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6C33B811E4;
        Mon, 20 Jun 2022 13:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CACC341C4;
        Mon, 20 Jun 2022 13:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730443;
        bh=ewSc+jsaxjM97OMqH/o18M9kZ/tKjUODyLRSXvYtIVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJ7FsYxz6LZm/sU3CvNU/SfXQI2tvqZl7glifLoHKnuvMW7hl97D4kttubXo5shLG
         C7yMQiiS9QLgLBvQRUK7AgUtRGGYKxzCpjTb+MAGSiLlYoizHTVPsWjnUBhEzLkOxd
         2foXjHMtRT0a8EJ/m5obISN2F+NPPQ9Wle01Gqx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/106] Drivers: hv: vmbus: Release cpu lock in error case
Date:   Mon, 20 Jun 2022 14:51:13 +0200
Message-Id: <20220620124725.998075971@linuxfoundation.org>
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

From: Saurabh Sengar <ssengar@linux.microsoft.com>

[ Upstream commit 656c5ba50b7172a0ea25dc1b37606bd51d01fe8d ]

In case of invalid sub channel, release cpu lock before returning.

Fixes: a949e86c0d780 ("Drivers: hv: vmbus: Resolve race between init_vp_index() and CPU hotplug")
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1654794996-13244-1-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index ce76fc382799..07003019263a 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -637,6 +637,7 @@ static void vmbus_process_offer(struct vmbus_channel *newchannel)
 		 */
 		if (newchannel->offermsg.offer.sub_channel_index == 0) {
 			mutex_unlock(&vmbus_connection.channel_mutex);
+			cpus_read_unlock();
 			/*
 			 * Don't call free_channel(), because newchannel->kobj
 			 * is not initialized yet.
-- 
2.35.1



