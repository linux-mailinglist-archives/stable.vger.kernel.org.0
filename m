Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E205594AA2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347207AbiHPAFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356590AbiHPACi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E41169C5B;
        Mon, 15 Aug 2022 13:24:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64ADD61089;
        Mon, 15 Aug 2022 20:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A90C433D6;
        Mon, 15 Aug 2022 20:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595038;
        bh=BPYGU0prx8vy2rm3ykiDuUfKlScpRpunExDGsvyfH6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HOhM7e8+D2UQommMMvK0MUq9IhKoHx+yrnbkwM6ytJ99llMS8wiLzcJ9ckaPSfSK
         vWwv5WHxkXcBTMeO6aw8+UpnjyeCZILiJMOxTuKtwENDbP2XZC2hQwLDAsXWa64ZGW
         LOLx39eS5MqI58XreVtpacaXSCXS4LACbPc+Coto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Tomas Melin <tomas.melin@vaisala.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0637/1157] iio: accel: sca3300: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:53 +0200
Message-Id: <20220815180505.187670903@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit b1d3a806630dbbf3b4d75a2e850adccf4f4439e7 ]

____cacheline_aligned is insufficient guarantee for non-coherent DMA.
Switch to the updated IIO_DMA_MINALIGN definition.

Fixes: 9cc9806e22178 ("iio: accel: Add driver for Murata SCA3300 accelerometer")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Tomas Melin <tomas.melin@vaisala.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-9-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/sca3300.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/sca3300.c b/drivers/iio/accel/sca3300.c
index f7ef8ecfd34a..39e0c24364ae 100644
--- a/drivers/iio/accel/sca3300.c
+++ b/drivers/iio/accel/sca3300.c
@@ -115,7 +115,7 @@ struct sca3300_data {
 		s16 channels[4];
 		s64 ts __aligned(sizeof(s64));
 	} scan;
-	u8 txbuf[4] ____cacheline_aligned;
+	u8 txbuf[4] __aligned(IIO_DMA_MINALIGN);
 	u8 rxbuf[4];
 };
 
-- 
2.35.1



