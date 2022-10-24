Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F239D60B067
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiJXQFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiJXQD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:03:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4E31E393E;
        Mon, 24 Oct 2022 07:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C25E5B8166D;
        Mon, 24 Oct 2022 12:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26764C433C1;
        Mon, 24 Oct 2022 12:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614334;
        bh=uoeFd3MyW7Ujm+9BgZ79uuyLasaqd+zLWJbzadSXaxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7QlpgP7uDZhmG2a2xRnbtAxGc/MRd4lFW/FhqpsSFxhNo1KVe0bn4pAkMNTuRpFF
         gmpmhoAQhgVO6NclLOEH5OSv9rG55tVSPEhQK02p1k/N0RB+gQVtUHW9bUCpIFo04q
         CqD064w5j+UrT9/HnHq1g60aXaZk5kHaYb3Cl+BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/390] iio: inkern: only release the device node when done with it
Date:   Mon, 24 Oct 2022 13:29:46 +0200
Message-Id: <20221024113030.806122436@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 79c3e84874c7d14f04ad58313b64955a0d2e9437 ]

'of_node_put()' can potentially release the memory pointed to by
'iiospec.np' which would leave us with an invalid pointer (and we would
still pass it in 'of_xlate()'). Note that it is not guaranteed for the
of_node lifespan to be attached to the device (to which is attached)
lifespan so that there is (even though very unlikely) the possibility
for the node to be freed while the device is still around. Thus, as there
are indeed some of_xlate users which do access the node, a race is indeed
possible.

As such, we can only release the node after we are done with it.

Fixes: 17d82b47a215d ("iio: Add OF support")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220715122903.332535-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/inkern.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 8c3faa797284..c32b2577dd99 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -136,9 +136,10 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 
 	idev = bus_find_device(&iio_bus_type, NULL, iiospec.np,
 			       iio_dev_node_match);
-	of_node_put(iiospec.np);
-	if (idev == NULL)
+	if (idev == NULL) {
+		of_node_put(iiospec.np);
 		return -EPROBE_DEFER;
+	}
 
 	indio_dev = dev_to_iio_dev(idev);
 	channel->indio_dev = indio_dev;
@@ -146,6 +147,7 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 		index = indio_dev->info->of_xlate(indio_dev, &iiospec);
 	else
 		index = __of_iio_simple_xlate(indio_dev, &iiospec);
+	of_node_put(iiospec.np);
 	if (index < 0)
 		goto err_put;
 	channel->channel = &indio_dev->channels[index];
-- 
2.35.1



