Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768E2548D92
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376708AbiFMNcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377540AbiFMN21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:28:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E846CF69;
        Mon, 13 Jun 2022 04:24:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 852186114A;
        Mon, 13 Jun 2022 11:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AB2C34114;
        Mon, 13 Jun 2022 11:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119483;
        bh=tkpOGYV1bTpItAosshOafBc2iiWyrT1W7PBhzciJ1F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuD9SBO6Rw3wG+iXlkzI1x+4qvt92f9kzfwNyHaCRjUIosdU6S0IafIqD373Oviaj
         bGnMsTKUc8MRqiK2IXz9K5rwno4Ge1qWt4dDawF9ft+i7bdnsT/fwIaKOSjqBZ0s0N
         vAI4lKucZqQ7kz4CbCi39Vy5RJ1A91HDk2ID4w+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 031/339] rpmsg: virtio: Fix possible double free in rpmsg_probe()
Date:   Mon, 13 Jun 2022 12:07:36 +0200
Message-Id: <20220613094927.458668370@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

[ Upstream commit c2eecefec5df1306eafce28ccdf1ca159a552ecc ]

vch will be free in virtio_rpmsg_release_device() when
rpmsg_ns_register_device() fails. There is no need to call kfree() again.

Fix this by changing error path from free_vch to free_ctrldev.

Fixes: c486682ae1e2 ("rpmsg: virtio: Register the rpmsg_char device")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Tested-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Link: https://lore.kernel.org/r/20220426060536.15594-2-hbh25y@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 3ede25b1f2e4..d4e453062062 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -973,7 +973,8 @@ static int rpmsg_probe(struct virtio_device *vdev)
 
 		err = rpmsg_ns_register_device(rpdev_ns);
 		if (err)
-			goto free_vch;
+			/* vch will be free in virtio_rpmsg_release_device() */
+			goto free_ctrldev;
 	}
 
 	/*
@@ -997,8 +998,6 @@ static int rpmsg_probe(struct virtio_device *vdev)
 
 	return 0;
 
-free_vch:
-	kfree(vch);
 free_ctrldev:
 	rpmsg_virtio_del_ctrl_dev(rpdev_ctrl);
 free_coherent:
-- 
2.35.1



