Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859B84DB250
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356380AbiCPOPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356372AbiCPOPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:15:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E027222B37;
        Wed, 16 Mar 2022 07:14:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48BBBB81B7B;
        Wed, 16 Mar 2022 14:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF94C340E9;
        Wed, 16 Mar 2022 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440070;
        bh=cDcBt1ZoRUQNRE8FVwU/QkkF+i3WkXILdRw8bB40734=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByGskSaaSLrSEInH1f9dnMBBmFng1xJu/EweWnwjdcHTmHRVWaFa8T9ko2Wuh4ElH
         Ac3AC+JFNlvlkihR70LKO7yFaaB8SCNyq/SVLd7bg9pQkaQkP2+Fe1vunL4WON7F5L
         8HVJNW6k0tAXW+I3XAUgE2CjyCIcRUoryGGWgU3BXqXg1xUId9c3iMkAx3qobFY9X/
         r3wGE1mxp7Ovav6AuKPbEJz40qzAiw05NGfauJZa2hjZhFrP8bOlroCPB2SXOJdeh1
         wFY9CfGHKf74eccBJTFpNyGKaWaytDQPQyQ6sdiGLH7JxGrm2m5qvXHSDWNXVFCpYu
         nXsYg0rSx9lmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, amit@kernel.org,
        gregkh@linuxfoundation.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.16 06/13] virtio_console: break out of buf poll on remove
Date:   Wed, 16 Mar 2022 10:13:47 -0400
Message-Id: <20220316141354.247750-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141354.247750-1-sashal@kernel.org>
References: <20220316141354.247750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit 0e7174b9d5877130fec41fb4a16e0c2ee4958d44 ]

A common pattern for device reset is currently:
vdev->config->reset(vdev);
.. cleanup ..

reset prevents new interrupts from arriving and waits for interrupt
handlers to finish.

However if - as is common - the handler queues a work request which is
flushed during the cleanup stage, we have code adding buffers / trying
to get buffers while device is reset. Not good.

This was reproduced by running
	modprobe virtio_console
	modprobe -r virtio_console
in a loop.

Fix this up by calling virtio_break_device + flush before reset.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1786239
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 660c5c388c29..f864b17be7e3 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1957,6 +1957,13 @@ static void virtcons_remove(struct virtio_device *vdev)
 	list_del(&portdev->list);
 	spin_unlock_irq(&pdrvdata_lock);
 
+	/* Device is going away, exit any polling for buffers */
+	virtio_break_device(vdev);
+	if (use_multiport(portdev))
+		flush_work(&portdev->control_work);
+	else
+		flush_work(&portdev->config_work);
+
 	/* Disable interrupts for vqs */
 	vdev->config->reset(vdev);
 	/* Finish up work that's lined up */
-- 
2.34.1

