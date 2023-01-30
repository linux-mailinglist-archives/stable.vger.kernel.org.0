Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFBD9681260
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbjA3OUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237650AbjA3OUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:20:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88813FF28
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:18:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B02CB811C7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B929DC433EF;
        Mon, 30 Jan 2023 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088334;
        bh=2TLub+3kRioy2ZRzoNLQAHe0p8oWW+ig02HOuGD3sAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfAt1O5aqCwiZgqdzIm58xpJUpAdwF/L8em8IJEI/8fCQ6bZ7D6JdEdRXtwG11Lx4
         wYZ5qsGjzPzNchGXIE6sg12mrTmldMQCCFSdjcbiZtwxYvjuEiTjsldo+Aw5X3X0jQ
         SQ+riWHM3Setwqoe+ENAW0LUgck5C1CoNKnFe3xY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/204] net: ravb: Fix lack of register setting after system resumed for Gen3
Date:   Mon, 30 Jan 2023 14:52:34 +0100
Message-Id: <20230130134324.858933455@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit c2b6cdee1d13ffbb24baca3c9b8a572d6b541e4e ]

After system entered Suspend to RAM, registers setting of this
hardware is reset because the SoC will be turned off. On R-Car Gen3
(info->ccc_gac), ravb_ptp_init() is called in ravb_probe() only. So,
after system resumed, it lacks of the initial settings for ptp. So,
add ravb_ptp_{init,stop}() into ravb_{resume,suspend}().

Fixes: f5d7837f96e5 ("ravb: ptp: Add CONFIG mode support")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index dcb18f1e6db0..046189507ec1 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2446,6 +2446,9 @@ static int __maybe_unused ravb_suspend(struct device *dev)
 	else
 		ret = ravb_close(ndev);
 
+	if (priv->info->ccc_gac)
+		ravb_ptp_stop(ndev);
+
 	return ret;
 }
 
@@ -2482,6 +2485,9 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	/* Restore descriptor base address table */
 	ravb_write(ndev, priv->desc_bat_dma, DBAT);
 
+	if (priv->info->ccc_gac)
+		ravb_ptp_init(ndev, priv->pdev);
+
 	if (netif_running(ndev)) {
 		if (priv->wol_enabled) {
 			ret = ravb_wol_restore(ndev);
-- 
2.39.0



