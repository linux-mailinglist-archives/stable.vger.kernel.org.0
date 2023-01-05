Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F89E65EC62
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbjAENJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbjAENIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:08:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA1A41D57
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E762F619F7
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D4AC433EF;
        Thu,  5 Jan 2023 13:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672924105;
        bh=mmZ706Q0KrnSn7MWQeX1U+ORMNh1hu+YoDf5F4gdlnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/+z/+fEt7Nq4hUZh70fAIk7xM+NcMF5e4pUler+hz1NTqM1eax3z1WTXK32xPyaY
         KHpgDTi+MSdSR266sqXNuwX7LrZsMPe1MbzHQtGx2fLrI9c+Qc/sBuWRa1Dgu9XJ09
         DMKnIhYJ5WFSHYwsFooqliGHvMg2uKjRMhSRO8fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenwen Wang <wenwen@cs.uga.edu>,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.9 236/251] media: dvb-core: Fix double free in dvb_register_device()
Date:   Thu,  5 Jan 2023 13:56:13 +0100
Message-Id: <20230105125345.682014954@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
@@ -317,6 +317,7 @@ static int dvb_create_media_entity(struc
 				       GFP_KERNEL);
 		if (!dvbdev->pads) {
 			kfree(dvbdev->entity);
+			dvbdev->entity = NULL;
 			return -ENOMEM;
 		}
 	}


