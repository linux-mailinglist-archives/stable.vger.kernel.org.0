Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C8F499B1B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574547AbiAXVtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456128AbiAXVhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B64BC0BD131;
        Mon, 24 Jan 2022 12:24:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3757B8122D;
        Mon, 24 Jan 2022 20:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB273C340E7;
        Mon, 24 Jan 2022 20:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055844;
        bh=Sg3S3kOi4mnZWSbiDwAh4Yx1tel3YqVXV3twfkoYhCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnwWz4Iv68gJ/G4cLcfJKZaIWhaqLl7tO8JcTNzxuE4oUPG5D0KCJd2pVNFV138oC
         61x+MLP7BjiBdN4ajZobrO/p2CoNWlCnoIOhLmo0f2xSsauVMFG4u+cwX88q3ZbyJ2
         b/aoxUeKx2xMJNltTIB7whr/pWQ0W2I66dVFp0WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/846] um: virtio_uml: Fix time-travel external time propagation
Date:   Mon, 24 Jan 2022 19:36:40 +0100
Message-Id: <20220124184110.684609033@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index d51e445df7976..7755cb4ff9fc6 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1090,6 +1090,8 @@ static void virtio_uml_release_dev(struct device *d)
 			container_of(d, struct virtio_device, dev);
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
 
+	time_travel_propagate_time();
+
 	/* might not have been opened due to not negotiating the feature */
 	if (vu_dev->req_fd >= 0) {
 		um_free_irq(vu_dev->irq, vu_dev);
@@ -1136,6 +1138,8 @@ static int virtio_uml_probe(struct platform_device *pdev)
 	vu_dev->pdev = pdev;
 	vu_dev->req_fd = -1;
 
+	time_travel_propagate_time();
+
 	do {
 		rc = os_connect_socket(pdata->socket_path);
 	} while (rc == -EINTR);
-- 
2.34.1



