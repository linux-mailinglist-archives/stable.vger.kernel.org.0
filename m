Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0D766490F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238928AbjAJSRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239169AbjAJSRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:17:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9DD15723
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:15:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C6046186E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3942FC433F0;
        Tue, 10 Jan 2023 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374531;
        bh=I5+E7RCwRQpQ6m2jnvmsVnbn2uXvIuJJeQCZx5A0CzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=181xCxKz0Hkdo5Gsz/KyWZ2tdQZKYxTYycHJBgOnUyJzlH1tckf0iScrZHLf2eyJ6
         LZKcWaUO4s9Jn1Iv+0a8oFCwuXrdTP1ogRddJfT8A3If4tl7OfDdzfRxza7oAlj36u
         6kPe7o8Q0TkqouZpEyhAb1+Jo7XFYnIEDpT4PJUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>,
        zhenwei pi <pizhenwei@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/159] virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()
Date:   Tue, 10 Jan 2023 19:03:16 +0100
Message-Id: <20230110180019.839104598@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit b1d65f717cd6305a396a8738e022c6f7c65cfbe8 ]

'vc_ctrl_req' is alloced in virtio_crypto_alg_skcipher_close_session(),
and should be freed in the invalid ctrl_status->status error handling
case. Otherwise there is a memory leak.

Fixes: 0756ad15b1fe ("virtio-crypto: use private buffer for control request")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Message-Id: <20221114110740.537276-1-weiyongjun@huaweicloud.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Acked-by: zhenwei pi<pizhenwei@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index e553ccadbcbc..e5876286828b 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -239,7 +239,8 @@ static int virtio_crypto_alg_skcipher_close_session(
 		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
 			ctrl_status->status, destroy_session->session_id);
 
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	err = 0;
-- 
2.35.1



