Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4EB6D2C99
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjDABl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbjDABlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:41:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D851D2DA;
        Fri, 31 Mar 2023 18:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B9B362CFE;
        Sat,  1 Apr 2023 01:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B6DC433A1;
        Sat,  1 Apr 2023 01:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313304;
        bh=uPMOlphHBamsx4/oDxVMrw3tPvD+rItJxPuTUtzs+Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rh4xC2nhYC3zqyKcp/DyXr7G05UssJQZ4RDMnLi9Ujzx/NV5kpHNJX/sAK7G2ZKqv
         3wC9vvl7xUKQDQMnPSL0304C7KJbEAcIBV59UoDjN2UkI3u3Qm6xtieAD9hcjohI5K
         XHfazUVqcM0MoOu2TYfH5dmpIEdJVzhdq0aAnAChHVl6lKxPb6+vLYHIi7dqajQuHY
         Dpx04fajlakRJ0cAZJxo9az1jdr9kcWV/E4JpW0Tj3IZICDF0FXkO62nDQeTGsFEaK
         ZRVTdxPq7K0YJ0p/n7qoCbGdE6CROwHI0lahbhUIKfe/O4b3c53jdT98UJDvg3shLU
         Oyg0kd0tnzqLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        aisheng.dong@nxp.com, shawnguo@kernel.org,
        linux-i2c@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.2 09/25] i2c: imx-lpi2c: clean rx/tx buffers upon new message
Date:   Fri, 31 Mar 2023 21:41:07 -0400
Message-Id: <20230401014126.3356410-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 987dd36c0141f6ab9f0fbf14d6b2ec3342dedb2f ]

When start sending a new message clear the Rx & Tx buffer pointers in
order to avoid using stale pointers.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Tested-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 9b2f9544c5681..a49b14d52a986 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -463,6 +463,8 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 		if (num == 1 && msgs[0].len == 0)
 			goto stop;
 
+		lpi2c_imx->rx_buf = NULL;
+		lpi2c_imx->tx_buf = NULL;
 		lpi2c_imx->delivered = 0;
 		lpi2c_imx->msglen = msgs[i].len;
 		init_completion(&lpi2c_imx->complete);
-- 
2.39.2

