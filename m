Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA5F540645
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347037AbiFGReP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347859AbiFGRbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9703B1059CB;
        Tue,  7 Jun 2022 10:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC931CE2396;
        Tue,  7 Jun 2022 17:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8030C385A5;
        Tue,  7 Jun 2022 17:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622914;
        bh=hKaaFKKJkTwL/NOcTKoKRquAfxInXdQEATkMxPCLz1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euZ1V3lF2vYOho1A7FOeMBiaq5VSfaiLCRZsxr6UpHSySd2o7BGheEiGRC/Ga4Iml
         7PqgM+Km1z4YLfcrSYQ02yvS7NbVVcaX2q5Fz5gu7E8YB3CcNLYgzMFimtnED2Vn+F
         9VbaCJ3ru9UvvWVZpRqTzz3G50iEpl9OMLjyKGEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/452] media: ov7670: remove ov7670_power_off from ov7670_remove
Date:   Tue,  7 Jun 2022 19:01:25 +0200
Message-Id: <20220607164915.356419505@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_SUBJ_WIPE_DEBT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 5bf19572e31375368f19edd2dbb2e0789518bb99 ]

In ov7670_probe, it always invokes ov7670_power_off() no matter
the execution is successful or failed. So we cannot invoke it
agiain in ov7670_remove().

Fix this by removing ov7670_power_off from ov7670_remove.

Fixes: 030f9f682e66 ("media: ov7670: control clock along with power")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov7670.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index b42b289faaef..154776d0069e 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -2000,7 +2000,6 @@ static int ov7670_remove(struct i2c_client *client)
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
 	media_entity_cleanup(&info->sd.entity);
-	ov7670_power_off(sd);
 	return 0;
 }
 
-- 
2.35.1



