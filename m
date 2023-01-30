Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFD4680F7C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbjA3NyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbjA3NyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:54:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3070739B98
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:54:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4B50B8114A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257D5C433D2;
        Mon, 30 Jan 2023 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086845;
        bh=/MnNoqcz1T2z69Lg6g7V2XP3DlxfH2snt+PaEGzmv6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOa7rk2hZBDIFYglBjs/wTJsP50mlFRse7+8Ht6YVEPNuITeE+yFOpp2UM680JAfv
         FxvA1xGx8ra1qFA/JTzpW/vPzuM0H8fgQzz6qmNMqpgn2f7BbB4TCv/So+U/w30Q3x
         4qXNo30JBHZUx9ftNymF9xINBZNuAJZ7z1nqig3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lucas Stach <l.stach@pengutronix.de>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/313] soc: imx: imx8mp-blk-ctrl: dont set power device name
Date:   Mon, 30 Jan 2023 14:47:32 +0100
Message-Id: <20230130134337.462745922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 21b84ebeee79d91e405f87f051e9489ef30ecad6 ]

Setting the device name after it has been registered confuses the sysfs
cleanup paths. This has already been fixed for the imx8m-blk-ctrl driver in
b64b46fbaa1d ("Revert "soc: imx: imx8m-blk-ctrl: set power device name""),
but the same problem exists in imx8mp-blk-ctrl.

Fixes: 556f5cf9568a ("soc: imx: add i.MX8MP HSIO blk-ctrl")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8mp-blk-ctrl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/soc/imx/imx8mp-blk-ctrl.c b/drivers/soc/imx/imx8mp-blk-ctrl.c
index 9852714eb2a4..0f13853901df 100644
--- a/drivers/soc/imx/imx8mp-blk-ctrl.c
+++ b/drivers/soc/imx/imx8mp-blk-ctrl.c
@@ -592,7 +592,6 @@ static int imx8mp_blk_ctrl_probe(struct platform_device *pdev)
 			ret = PTR_ERR(domain->power_dev);
 			goto cleanup_pds;
 		}
-		dev_set_name(domain->power_dev, "%s", data->name);
 
 		domain->genpd.name = data->name;
 		domain->genpd.power_on = imx8mp_blk_ctrl_power_on;
-- 
2.39.0



