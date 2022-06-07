Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015CF541460
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358291AbiFGURb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359515AbiFGUP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:15:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AEF1C8A16;
        Tue,  7 Jun 2022 11:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51657B82340;
        Tue,  7 Jun 2022 18:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC384C385A2;
        Tue,  7 Jun 2022 18:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626504;
        bh=z9mF0vJTOcJM8P1H/x/lKWNpzNoK2T2OoNZu9lJkCpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zcd02FogVB+CswnfhtE6oJFaXVFkfhlQOxUgAiBuTLfQTvT1sgiuHwS4+hBXp3ddl
         XFnagWzeoVFSmJycNFhS7jm+pSvNBz4WZAEjKMYJiZ55ZMChrg3k4ZVsrfG6LAPTE/
         rBo8IJfArvk9EnfCRU8usQlUBrXNVNPx8AbF/djw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 402/772] media: ov7670: remove ov7670_power_off from ov7670_remove
Date:   Tue,  7 Jun 2022 18:59:54 +0200
Message-Id: <20220607165000.856480982@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 196746423116..1be2c0e5bdc1 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -2017,7 +2017,6 @@ static int ov7670_remove(struct i2c_client *client)
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
 	media_entity_cleanup(&info->sd.entity);
-	ov7670_power_off(sd);
 	return 0;
 }
 
-- 
2.35.1



