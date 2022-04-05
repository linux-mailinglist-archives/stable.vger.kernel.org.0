Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AAC4F3632
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245658AbiDEK7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347210AbiDEJqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA8CDD97B;
        Tue,  5 Apr 2022 02:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27313615E5;
        Tue,  5 Apr 2022 09:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39962C385A2;
        Tue,  5 Apr 2022 09:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151156;
        bh=TdNHD+ThQdFDNYzUnyywSIQFu/8Rmrh1akcMl4pdADg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTqCmeGdGNXyAGp+MeGmYdeQuVVJUFjroorq57uFz8FF00U5mqasa+pzXq/YUlhRK
         4tCJr+h989D6vfEOHP9BFXKb77T5S4v3SPjF+q0yi9LJzzJ7JbZZhi4ZHe17/cxAGV
         5sxXMgghaZRZ4PFB+eVZVICX1MueVr1q74WukJ+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/913] media: usb: go7007: s2250-board: fix leak in probe()
Date:   Tue,  5 Apr 2022 09:22:56 +0200
Message-Id: <20220405070349.265093600@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 67e4550ecd6164bfbdff54c169e5bbf9ccfaf14d ]

Call i2c_unregister_device(audio) on this error path.

Fixes: d3b2ccd9e307 ("[media] s2250: convert to the control framework")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/s2250-board.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/go7007/s2250-board.c b/drivers/media/usb/go7007/s2250-board.c
index c742cc88fac5..1fa6f10ee157 100644
--- a/drivers/media/usb/go7007/s2250-board.c
+++ b/drivers/media/usb/go7007/s2250-board.c
@@ -504,6 +504,7 @@ static int s2250_probe(struct i2c_client *client,
 	u8 *data;
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct go7007_usb *usb = go->hpi_context;
+	int err = -EIO;
 
 	audio = i2c_new_dummy_device(adapter, TLV320_ADDRESS >> 1);
 	if (IS_ERR(audio))
@@ -532,11 +533,8 @@ static int s2250_probe(struct i2c_client *client,
 		V4L2_CID_HUE, -512, 511, 1, 0);
 	sd->ctrl_handler = &state->hdl;
 	if (state->hdl.error) {
-		int err = state->hdl.error;
-
-		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
-		return err;
+		err = state->hdl.error;
+		goto fail;
 	}
 
 	state->std = V4L2_STD_NTSC;
@@ -600,7 +598,7 @@ static int s2250_probe(struct i2c_client *client,
 	i2c_unregister_device(audio);
 	v4l2_ctrl_handler_free(&state->hdl);
 	kfree(state);
-	return -EIO;
+	return err;
 }
 
 static int s2250_remove(struct i2c_client *client)
-- 
2.34.1



