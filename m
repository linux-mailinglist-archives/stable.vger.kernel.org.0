Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E52657899
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiL1Owr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiL1OwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:52:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F28120A0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:52:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD02DB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3E2C433EF;
        Wed, 28 Dec 2022 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239124;
        bh=B+qOLWrrcjScKG5mowKSnO1AwUThhJxyTge94gyLfJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X//RHw9meV2gEu9YkR5bwhBPZ6YIsbhcTu8dhOwBSRpjSi9lmAKgpZ0S/kUOD5xGR
         taS0wSJEKYAt+nwj7ErXJ9PWSg8fD3t/x6Z58iz1Gf4mSTnZk9pyXoKoEg1eUJSrjn
         fDre/fIHxwQN/FDaU5BDwLFMYySHbCNG30TS++gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/731] rapidio: rio: fix possible name leak in rio_register_mport()
Date:   Wed, 28 Dec 2022 15:33:38 +0100
Message-Id: <20221228144259.768349372@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e92a216d16bde65d21a3227e0fb2aa0794576525 ]

If device_register() returns error, the name allocated by dev_set_name()
need be freed.  It should use put_device() to give up the reference in the
error path, so that the name can be freed in kobject_cleanup(), and
list_del() is called to delete the port from rio_mports.

Link: https://lkml.kernel.org/r/20221114152636.2939035-3-yangyingliang@huawei.com
Fixes: 2aaf308b95b2 ("rapidio: rework device hierarchy and introduce mport class of devices")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/rio.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index e74cf09eeff0..9544b8ee0c96 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -2186,11 +2186,16 @@ int rio_register_mport(struct rio_mport *port)
 	atomic_set(&port->state, RIO_DEVICE_RUNNING);
 
 	res = device_register(&port->dev);
-	if (res)
+	if (res) {
 		dev_err(&port->dev, "RIO: mport%d registration failed ERR=%d\n",
 			port->id, res);
-	else
+		mutex_lock(&rio_mport_list_lock);
+		list_del(&port->node);
+		mutex_unlock(&rio_mport_list_lock);
+		put_device(&port->dev);
+	} else {
 		dev_dbg(&port->dev, "RIO: registered mport%d\n", port->id);
+	}
 
 	return res;
 }
-- 
2.35.1



