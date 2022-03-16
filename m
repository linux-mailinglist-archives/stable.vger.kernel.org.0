Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779494DB307
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356581AbiCPOZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356784AbiCPOWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:22:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FB95F4C4;
        Wed, 16 Mar 2022 07:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 928D5B81B40;
        Wed, 16 Mar 2022 14:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536C7C340E9;
        Wed, 16 Mar 2022 14:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440356;
        bh=JuKv5L/0AOr+bAEI9MVsl38mgm5zbqJuHhNnytpvgeE=;
        h=From:To:Cc:Subject:Date:From;
        b=Yx2Zq9++e1+aE9AVdWRxgPGZOd8vQCEQEkoEc+GSZL6pBOJhh6kbXfY9luCCz3Ppi
         VG6ugaOTgh9yq21iMHb7U5hz6iuuRlWlGLdmDbO4Vqk8IbedCq1Tp8T6yg+J7t2LdV
         YfB5ADjXAUFUbjTSQd3Etz3DCbZ3scGJUI5A3EYQPPQnj129w7eBI9XsUoF9MxPcbB
         gRJK54WPhJ2a7RUrd0AA0If0Y9SrFtnOew8TrtYYkYrZMlmOyTxqCjIoLnadD+qkO+
         FhslkgW6qiB3M88rJUhOX0UQxirtDj6P+Qiyv+1JR0h8gmTgjbmU6zqGMMMHVZyIft
         EXZ2HjQ70Kg2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, amit@kernel.org,
        gregkh@linuxfoundation.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 1/2] virtio_console: break out of buf poll on remove
Date:   Wed, 16 Mar 2022 10:19:07 -0400
Message-Id: <20220316141908.248848-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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
index 2632b0fdb1b5..a6b6dc204c1f 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2004,6 +2004,13 @@ static void virtcons_remove(struct virtio_device *vdev)
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

