Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836E5664A50
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbjAJScB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239467AbjAJSbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:31:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82C490856
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:26:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72ACFB81904
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1531C433EF;
        Tue, 10 Jan 2023 18:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375188;
        bh=vxs/uePeqY9uEnTL5udaLloHxcY/GXkuhbWxtSbsUG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XN7MPECFIronrK6jxTobczDGEzMUR//2/opAdv/4hCgX6HJKY5xTeALSD+5WWRHlY
         USPyWAdh9UO9h+X7SmPlzHLjElC0Pj5PFIZnWT4oxQOsNiscviZlFZ/JEYSYUoGmbE
         IcZ0nFzYZoJcXHGeRMPZwTuDHALeGn9NeLl7xT9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenwen Wang <wenwen@cs.uga.edu>,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 108/290] media: dvb-core: Fix double free in dvb_register_device()
Date:   Tue, 10 Jan 2023 19:03:20 +0100
Message-Id: <20230110180035.514496792@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

commit 6b0d0477fce747d4137aa65856318b55fba72198 upstream.

In function dvb_register_device() -> dvb_register_media_device() ->
dvb_create_media_entity(), dvb->entity is allocated and initialized. If
the initialization fails, it frees the dvb->entity, and return an error
code. The caller takes the error code and handles the error by calling
dvb_media_device_free(), which unregisters the entity and frees the
field again if it is not NULL. As dvb->entity may not NULLed in
dvb_create_media_entity() when the allocation of dvbdev->pad fails, a
double free may occur. This may also cause an Use After free in
media_device_unregister_entity().

Fix this by storing NULL to dvb->entity when it is freed.

Link: https://lore.kernel.org/linux-media/20220426052921.2088416-1-keitasuzuki.park@sslab.ics.keio.ac.jp
Fixes: fcd5ce4b3936 ("media: dvb-core: fix a memory leak bug")
Cc: stable@vger.kernel.org
Cc: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvbdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -345,6 +345,7 @@ static int dvb_create_media_entity(struc
 				       GFP_KERNEL);
 		if (!dvbdev->pads) {
 			kfree(dvbdev->entity);
+			dvbdev->entity = NULL;
 			return -ENOMEM;
 		}
 	}


