Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283CA64325C
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiLET0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiLETZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:25:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54DD1F2FC
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:21:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2D5D3CE13A3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06746C433D6;
        Mon,  5 Dec 2022 19:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268079;
        bh=NZhukwqmEYGZ98x4wA6xs3CPUjVU19bC2V823JnRVq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXi976pNM0GlUVpaTBbEXJfiNThb9YU9XIEg7mGlPSQx6rfd8ajkfvXn6OdA1xiXu
         z/QEyh+oZ3OtDL5GxQ1YsIpg2qOJyTFRr3vM04C5cbwy4BvUvERcW3X0UmOlvb2H82
         hB3FsUhoRCvNOBvwrxMASzYKLvqKAiVVmAUI/f80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tho Vu <tho.vu.wh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/105] net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed
Date:   Mon,  5 Dec 2022 20:09:51 +0100
Message-Id: <20221205190805.834024548@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit d66233a312ec9013af3e37e4030b479a20811ec3 ]

After system resumed on some environment board, the promiscuous mode
is disabled because the SoC turned off. So, call ravb_set_rx_mode() in
the ravb_resume() to fix the issue.

Reported-by: Tho Vu <tho.vu.wh@renesas.com>
Fixes: 0184165b2f42 ("ravb: add sleep PM suspend/resume support")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20221128065604.1864391-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index c24b7ea37e39..9077014f6f40 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2310,6 +2310,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 		ret = ravb_open(ndev);
 		if (ret < 0)
 			return ret;
+		ravb_set_rx_mode(ndev);
 		netif_device_attach(ndev);
 	}
 
-- 
2.35.1



