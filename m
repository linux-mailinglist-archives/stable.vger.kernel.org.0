Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32316086F5
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiJVHzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiJVHyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819A059EAA;
        Sat, 22 Oct 2022 00:47:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A558F60B1B;
        Sat, 22 Oct 2022 07:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93A4C43470;
        Sat, 22 Oct 2022 07:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424830;
        bh=KNf54MzYOzZQ7PIZ9pF8uzpHZeVH6NK8nEr5MpJ/Xzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKGdVYKysi7jdCE8zbZjoZbRPXYN2+/hHKhwSYMpPYfdML60nGKJTs08uHO0Xa4qE
         rfaNpefxPOWPUBwbAO12FU9/oaaucMqYQXVj9UsrO2jRjdpF6WZbbEi0+Fz+8HhK73
         H0cijDpXQu4Cm3vP+nSlEFZ2crOtGgnMb84Rk9DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 291/717] net: wwan: iosm: Call mutex_init before locking it
Date:   Sat, 22 Oct 2022 09:22:50 +0200
Message-Id: <20221022072504.847688169@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 27151148c782..4712f01a7e33 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -323,15 +323,16 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
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



