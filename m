Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A984994E5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388813AbiAXUtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387575AbiAXUg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF507C038AF7;
        Mon, 24 Jan 2022 11:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CE0960915;
        Mon, 24 Jan 2022 19:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2979BC340E5;
        Mon, 24 Jan 2022 19:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053813;
        bh=t5SxjgbiiJ4hjr1e5ee5PsWnPbWkh/Lbl9KvMrK5U1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTzMyfgmqtOMnwzWLRcSAZT0a5VmT3rEWGbckInjYxsRnfjn92onMG8FfSpr2cgIE
         lARAilSNGTbAeI/ZPeibQI7sZSqlWkMV1aotK+rMu9T79kEd8P754xkKJJjtDp53by
         5ynT9cTkSWcEpZDkYpzPJ++vjSd4A5PPebrtKZl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/563] um: virtio_uml: Fix time-travel external time propagation
Date:   Mon, 24 Jan 2022 19:39:11 +0100
Message-Id: <20220124184030.855937858@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 85e73968a040c642fd38f6cba5b73b61f5d0f052 ]

When creating an external event, the current time needs to
be propagated to other participants of a simulation. This
is done in the places here where we kick a virtq etc.

However, it must be done for _all_ external events, and
that includes making the initial socket connection and
later closing it. Call time_travel_propagate_time() to do
this before making or closing the socket connection.

Apparently, at least for the initial connection creation,
due to the remote side in my use cases using microseconds
(rather than nanoseconds), this wasn't a problem yet; only
started failing between 5.14-rc1 and 5.15-rc1 (didn't test
others much), or possibly depending on the configuration,
where more delays happen before the virtio devices are
initialized.

Fixes: 88ce64249233 ("um: Implement time-travel=ext")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index d11b3d41c3785..d5d768188b3ba 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1076,6 +1076,8 @@ static void virtio_uml_release_dev(struct device *d)
 			container_of(d, struct virtio_device, dev);
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
 
+	time_travel_propagate_time();
+
 	/* might not have been opened due to not negotiating the feature */
 	if (vu_dev->req_fd >= 0) {
 		um_free_irq(VIRTIO_IRQ, vu_dev);
@@ -1109,6 +1111,8 @@ static int virtio_uml_probe(struct platform_device *pdev)
 	vu_dev->pdev = pdev;
 	vu_dev->req_fd = -1;
 
+	time_travel_propagate_time();
+
 	do {
 		rc = os_connect_socket(pdata->socket_path);
 	} while (rc == -EINTR);
-- 
2.34.1



