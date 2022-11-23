Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FED6355D0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiKWJXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237485AbiKWJWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:22:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2CD10B404
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:21:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E53E3B81EF7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0D4C433D6;
        Wed, 23 Nov 2022 09:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195314;
        bh=LYB/PlXxnYtq0oMbwb+X3LffkwD40L1PzhSxTFziOLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRYgLkyBPzI3YLdtCnGMH494Uk9KfwFNyKUEPeEmVUnXla9/TJp+pUGWNGUJ3XKra
         VB7dbH6Kke4KratN3ZHZ2FnquDSJrNpQRKsrLz97K5l0F6TlgCGI7z3NHZnVoaKvlb
         i4QmisVb9bQxx3Gt79ierh+bP5PbLR8Rj6Y09dAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/149] siox: fix possible memory leak in siox_device_add()
Date:   Wed, 23 Nov 2022 09:50:32 +0100
Message-Id: <20221123084559.698131000@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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
index f8c08fb9891d..e0ffef6e9386 100644
--- a/drivers/siox/siox-core.c
+++ b/drivers/siox/siox-core.c
@@ -835,6 +835,8 @@ static struct siox_device *siox_device_add(struct siox_master *smaster,
 
 err_device_register:
 	/* don't care to make the buffer smaller again */
+	put_device(&sdevice->dev);
+	sdevice = NULL;
 
 err_buf_alloc:
 	siox_master_unlock(smaster);
-- 
2.35.1



