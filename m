Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0112548BDC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381287AbiFMOIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382367AbiFMOFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94186939D7;
        Mon, 13 Jun 2022 04:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6690E612E9;
        Mon, 13 Jun 2022 11:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C8FC34114;
        Mon, 13 Jun 2022 11:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120423;
        bh=/TBjeYpkzCFVk4aqwV047MV/124Kf0KH7y124ulAzEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+PO5n0+8yFnh7L+mTlHjd041h/JJziJAKNKYrenZfQZrZHAGx2waXcTLZMzxDX5A
         itV/K/518bP7qM6oz+TS8qw8lrNZTPbwpQHzH5Ze+ifRAiMrwbLP6uSIqcOTceaXpf
         +FY3sIGQhypj/GsS/NnHhVB/JueC88O92DT0bwbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 028/298] rpmsg: virtio: Fix possible double free in rpmsg_virtio_add_ctrl_dev()
Date:   Mon, 13 Jun 2022 12:08:42 +0200
Message-Id: <20220613094925.784011360@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 1680939e9ecf7764fba8689cfb3429c2fe2bb23c ]

vch will be free in virtio_rpmsg_release_device() when
rpmsg_ctrldev_register_device() fails. There is no need to call
kfree() again.

Fixes: c486682ae1e2 ("rpmsg: virtio: Register the rpmsg_char device")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Tested-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Link: https://lore.kernel.org/r/20220426060536.15594-3-hbh25y@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 1c39e9c4fa02..99e0de65733a 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -851,7 +851,7 @@ static struct rpmsg_device *rpmsg_virtio_add_ctrl_dev(struct virtio_device *vdev
 
 	err = rpmsg_chrdev_register_device(rpdev_ctrl);
 	if (err) {
-		kfree(vch);
+		/* vch will be free in virtio_rpmsg_release_device() */
 		return ERR_PTR(err);
 	}
 
-- 
2.35.1



