Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A592D60B6B4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJXTIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbiJXTIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:08:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E5415624B;
        Mon, 24 Oct 2022 10:47:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 589EFB8198C;
        Mon, 24 Oct 2022 12:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA87C433C1;
        Mon, 24 Oct 2022 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615314;
        bh=kZUsTiHIkaa9hs1Jt4yO8D2XSADJB0le79/zB/+UV98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBmqA8cqhHg11X8tGsy6tFwjARZT5zp8G4kvsNry9K8NyYhjpVbrhQHWoG89bqZGR
         tS3vIe8PlywXm2SDDSpoL898EuYXU9O46h1YhlZNZDGvPLKncQdU2AEbPjOO85PB/y
         u7EuCy9xnmRNxzVdaHB6a4cGEck9GQIxlDAq4XTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/530] net: wwan: iosm: Call mutex_init before locking it
Date:   Mon, 24 Oct 2022 13:29:08 +0200
Message-Id: <20221024113054.291523955@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit ba0fbdb95da5ddd8db457ce6ba09d16dd979a294 ]

wwan_register_ops calls wwan_create_default_link, which ends up in the
ipc_wwan_newlink callback that locks ipc_wwan->if_mutex. However, this
mutex is not yet initialized by that point. Fix it by moving mutex_init
above the wwan_register_ops call. This also makes the order of
operations in ipc_wwan_init symmetric to ipc_wwan_deinit.

Fixes: 83068395bbfc ("net: iosm: create default link via WWAN core")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index b571d9cedba4..92f064a8f837 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -322,15 +322,16 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 	ipc_wwan->dev = dev;
 	ipc_wwan->ipc_imem = ipc_imem;
 
+	mutex_init(&ipc_wwan->if_mutex);
+
 	/* WWAN core will create a netdev for the default IP MUX channel */
 	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan,
 			      IP_MUX_SESSION_DEFAULT)) {
+		mutex_destroy(&ipc_wwan->if_mutex);
 		kfree(ipc_wwan);
 		return NULL;
 	}
 
-	mutex_init(&ipc_wwan->if_mutex);
-
 	return ipc_wwan;
 }
 
-- 
2.35.1



