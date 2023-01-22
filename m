Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93821676E84
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjAVPL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjAVPL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:11:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E15220066
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:11:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA0B3B80B11
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457B5C433EF;
        Sun, 22 Jan 2023 15:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400282;
        bh=FPLbrvIr0sJlCYZ/5az/WTaLEeHg/wZDDnYcNICvEGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mc9kZMeUw0vNRRYNCa8smmYQETziOxDvNWRpIg2krh4hUHAXNArqCUxwUmsfSINA4
         c/UfaxMXDaqipvZBV/krEROb7ziuSs5xN5lUbPBeh+2rP9hliGNROwjt61Q4qK1pCr
         Wf51CZtG+e9GSRIu/HULgQoiMGdPrwqWLI4Pa69c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/98] tools/virtio: initialize spinlocks in vring_test.c
Date:   Sun, 22 Jan 2023 16:03:20 +0100
Message-Id: <20230122150229.565008149@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Cañuelo <ricardo.canuelo@collabora.com>

[ Upstream commit c262f75cb6bb5a63828e72ce3b8fe808e5029479 ]

The virtio_device vqs_list spinlocks must be initialized before use to
prevent functions that manipulate the device virtualqueues, such as
vring_new_virtqueue(), from blocking indefinitely.

Signed-off-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Message-Id: <20221012062949.1526176-1-ricardo.canuelo@collabora.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/vringh_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index fa87b58bd5fa..98ff808d6f0c 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -308,6 +308,7 @@ static int parallel_test(u64 features,
 
 		gvdev.vdev.features = features;
 		INIT_LIST_HEAD(&gvdev.vdev.vqs);
+		spin_lock_init(&gvdev.vdev.vqs_list_lock);
 		gvdev.to_host_fd = to_host[1];
 		gvdev.notifies = 0;
 
@@ -455,6 +456,7 @@ int main(int argc, char *argv[])
 	getrange = getrange_iov;
 	vdev.features = 0;
 	INIT_LIST_HEAD(&vdev.vqs);
+	spin_lock_init(&vdev.vqs_list_lock);
 
 	while (argv[1]) {
 		if (strcmp(argv[1], "--indirect") == 0)
-- 
2.35.1



