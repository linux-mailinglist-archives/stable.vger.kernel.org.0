Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D496356CC
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbiKWJe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbiKWJeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:34:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF6085A12
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:31:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2625A61B66
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74192C433D6;
        Wed, 23 Nov 2022 09:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195916;
        bh=XpwRcAo2jfwOpMnSgLEF1oXMai8/FPRyv23ruHXnGqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIf4JLfOBewM18GGTaR0qbqWDMJeJ3Q7smgMOt1c6M8FTO15Ry4r/d1sPpU/NaxzL
         JbS71omyArvQ9zKHAAH1jpeHMq3e+4spg+1Qlf/R1xTOD12MpoNmYY9v/kdo3J6o4a
         5+rLD1TJJI6EF6zbJcZY+CMP2NU44a4PD3SVrOnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/181] siox: fix possible memory leak in siox_device_add()
Date:   Wed, 23 Nov 2022 09:50:24 +0100
Message-Id: <20221123084605.006524154@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

[ Upstream commit 6e63153db50059fb78b8a8447b132664887d24e3 ]

If device_register() returns error in siox_device_add(),
the name allocated by dev_set_name() need be freed. As
comment of device_register() says, it should use put_device()
to give up the reference in the error path. So fix this
by calling put_device(), then the name can be freed in
kobject_cleanup(), and sdevice is freed in siox_device_release(),
set it to null in error path.

Fixes: bbecb07fa0af ("siox: new driver framework for eckelmann SIOX")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20221104021334.618189-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/siox/siox-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/siox/siox-core.c b/drivers/siox/siox-core.c
index 7c4f32d76966..561408583b2b 100644
--- a/drivers/siox/siox-core.c
+++ b/drivers/siox/siox-core.c
@@ -839,6 +839,8 @@ static struct siox_device *siox_device_add(struct siox_master *smaster,
 
 err_device_register:
 	/* don't care to make the buffer smaller again */
+	put_device(&sdevice->dev);
+	sdevice = NULL;
 
 err_buf_alloc:
 	siox_master_unlock(smaster);
-- 
2.35.1



