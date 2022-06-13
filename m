Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5BF5480DE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237307AbiFMHu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbiFMHu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B662EAE78
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FC8860FEE
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59010C34114;
        Mon, 13 Jun 2022 07:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655106655;
        bh=f+vyQsupKn+03MnYnqQ0am71Nhca70/abQQhReC2Jpc=;
        h=Subject:To:Cc:From:Date:From;
        b=b84IxCGbS9KeIpIX9NAKsARt/9c3QNcRERomMvVCWHM+v1ES0JxJtxqTNQmvBblCr
         5esjTvPvRylZ3mJPsw1XhAfnIUdUOx5YQngHmPCGfilKq8JWuROxaGwwclJAIz4XsN
         5jiQ1L83vk6T3XSD40JwhqB8+QCvWOk15EOM1tJ8=
Subject: FAILED: patch "[PATCH] virtio-rng: make device ready before making request" failed to apply to 4.9-stable tree
To:     jasowang@redhat.com, lvivier@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:50:49 +0200
Message-ID: <165510664930103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 228432551bd8783211e494ab35f42a4344580502 Mon Sep 17 00:00:00 2001
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 8 Jun 2022 14:14:22 +0800
Subject: [PATCH] virtio-rng: make device ready before making request

Current virtio-rng does a entropy request before DRIVER_OK, this
violates the spec:

virtio spec requires that all drivers set DRIVER_OK
before using devices.

Further, kernel will ignore the interrupt after commit
8b4ec69d7e09 ("virtio: harden vring IRQ").

Fixing this by making device ready before the request.

Cc: stable@vger.kernel.org
Fixes: 8b4ec69d7e09 ("virtio: harden vring IRQ")
Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
Reported-and-tested-by: syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20220608061422.38437-1-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Laurent Vivier <lvivier@redhat.com>

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index e856df7e285c..a6f3a8a2aca6 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -159,6 +159,8 @@ static int probe_common(struct virtio_device *vdev)
 		goto err_find;
 	}
 
+	virtio_device_ready(vdev);
+
 	/* we always have a pending entropy request */
 	request_entropy(vi);
 

