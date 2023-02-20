Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74E769CCEE
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjBTNov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbjBTNol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:44:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359C01D92D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:44:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD9E1B80D4C
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FBEC433D2;
        Mon, 20 Feb 2023 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900660;
        bh=urNEpxlN7SQmd05exw+I8T43fbxJUL0ZR0hyBXLLML8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9BTTGFOCACZ+mgpjOvTh6UQsjBOec6Qzb85BWPKNPhE8XMnVBjRsbhpGjSZV9BTp
         ID6nSGM/dr38bRBWvdz7F5rIyKDFtNrVlVQ8pI/o2kp8iNM+bgqfGqk+gW7swgGGJU
         Qlm6YEDCKXAEYlVGLP/xydHjx91bMRjp4VA6KI78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Pirko <jiri@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/156] virtio-net: Keep stop() to follow mirror sequence of open()
Date:   Mon, 20 Feb 2023 14:34:24 +0100
Message-Id: <20230220133603.293408938@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 63b114042d8a9c02d9939889177c36dbdb17a588 ]

Cited commit in fixes tag frees rxq xdp info while RQ NAPI is
still enabled and packet processing may be ongoing.

Follow the mirror sequence of open() in the stop() callback.
This ensures that when rxq info is unregistered, no rx
packet processing is ongoing.

Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://lore.kernel.org/r/20230202163516.12559-1-parav@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 579df7c5411d..5212d9cb0372 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1910,8 +1910,8 @@ static int virtnet_close(struct net_device *dev)
 	cancel_delayed_work_sync(&vi->refill);
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
 		napi_disable(&vi->rq[i].napi);
+		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
 		virtnet_napi_tx_disable(&vi->sq[i].napi);
 	}
 
-- 
2.39.0



