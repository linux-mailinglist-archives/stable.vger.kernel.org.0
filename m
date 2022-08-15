Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEA9594FDA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiHPEd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiHPEdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:33:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A2116947F;
        Mon, 15 Aug 2022 13:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E7D61007;
        Mon, 15 Aug 2022 20:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5A7C433D6;
        Mon, 15 Aug 2022 20:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595035;
        bh=iYOlz1WzvJN15nVIkSZo/bulMOhv/IOHP6xVWbuO5kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8hZFaNK15158kG+IOdKX9RVl01q2g6tb21GCwyFGwp1bxNF+eO6pWaj/Mt3Ek+Rw
         lyvr6zJF40nV/Ye1C18zYM/ox4xh9fi4Cdkf0pdgJKCtSvVlFlg4TVRCeHf2QEyUZ/
         RcfMw4sQP2n8NzJa35ZZJncGvjc4qNkeCBteHGr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0636/1157] iio: accel: sca3000: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:52 +0200
Message-Id: <20220815180505.143152324@linuxfoundation.org>
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

[ Upstream commit a263456f0e27ec2f00d25119757f4d4bd656b2e9 ]

____cacheline_aligned is insufficient guarantee for non-coherent DMA.
Switch to the updated IIO_DMA_MINALIGN definition.

The second alignment marking is left in place to avoid doing more than
the simple fix in this patch.

Fixes: ced5c03d360ae ("staging:iio:accel:sca3000 merge files into one.")
Fixes: 152a6a884ae13 ("staging:iio:accel:sca3000 move to hybrid hard / soft buffer design.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-8-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/sca3000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/sca3000.c b/drivers/iio/accel/sca3000.c
index 29a68a7d34cd..cc0aa1dda611 100644
--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -167,8 +167,8 @@ struct sca3000_state {
 	int				mo_det_use_count;
 	struct mutex			lock;
 	/* Can these share a cacheline ? */
-	u8				rx[384] ____cacheline_aligned;
-	u8				tx[6] ____cacheline_aligned;
+	u8				rx[384] __aligned(IIO_DMA_MINALIGN);
+	u8				tx[6] __aligned(IIO_DMA_MINALIGN);
 };
 
 /**
-- 
2.35.1



