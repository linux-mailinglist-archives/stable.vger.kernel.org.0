Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDE854950B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbiFMOri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385701AbiFMOqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1576EBE175;
        Mon, 13 Jun 2022 04:52:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A176124E;
        Mon, 13 Jun 2022 11:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57C5C34114;
        Mon, 13 Jun 2022 11:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121146;
        bh=KKeoL48rZJn6/zPjlSpjTvPqmKvNat2ujrv+PiAbrHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQyv6c5GOq7ylQUqTHJuD3Kr9NGhVoSj/z8n2EOC+O5midlvuaQFiu2FspDrCLgb+
         M+9l02WoN9bRPg4op/jLxdGHGH1jwtESsSnxU3V7OgeZ4E+dY1fxWoRXd+MdNrcGUc
         f6JIvKKMr7PBdzCNTATJDNRYimJ0x7AKFTmOo03Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com
Subject: [PATCH 5.17 288/298] virtio-rng: make device ready before making request
Date:   Mon, 13 Jun 2022 12:13:02 +0200
Message-Id: <20220613094933.814157705@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jason Wang <jasowang@redhat.com>

commit 228432551bd8783211e494ab35f42a4344580502 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/virtio-rng.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -159,6 +159,8 @@ static int probe_common(struct virtio_de
 		goto err_find;
 	}
 
+	virtio_device_ready(vdev);
+
 	/* we always have a pending entropy request */
 	request_entropy(vi);
 


