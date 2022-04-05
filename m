Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B494F2EEC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiDEI1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239434AbiDEIUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCBA8E184;
        Tue,  5 Apr 2022 01:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41843B81A37;
        Tue,  5 Apr 2022 08:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8974CC385A0;
        Tue,  5 Apr 2022 08:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146385;
        bh=4xVP+rc9dkDWqE/NBcuMen4mqzFB0WGjI6QqAFNahww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jl9kSJc86eqrYD0+K0VMzmycmVzBxGJUMzISMr2+p1YdR456vp+PKvzxMFH0lf2le
         ve8ev43eUA7eofMDyWovRr3Get1TCA1AswRCkdcGHie3UaUVkH0czhnzUqkHdrDGYx
         EIZePabB+saw8UYbMSP3RXzNrmIJi/7qtWdcwsyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Abel Vesa <abel.vesa@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0744/1126] clk: imx: off by one in imx_lpcg_parse_clks_from_dt()
Date:   Tue,  5 Apr 2022 09:24:51 +0200
Message-Id: <20220405070429.423447994@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 135efc3a76d127691afaf1864e4ab627bf09d53d ]

The > needs to be >= to prevent an off by one access.

Fixes: d5f1e6a2bb61 ("clk: imx: imx8qxp-lpcg: add parsing clocks from device tree")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20220228075014.GD13685@kili
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp-lpcg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx8qxp-lpcg.c b/drivers/clk/imx/clk-imx8qxp-lpcg.c
index b23758083ce5..5e31a6a24b3a 100644
--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -248,7 +248,7 @@ static int imx_lpcg_parse_clks_from_dt(struct platform_device *pdev,
 
 	for (i = 0; i < count; i++) {
 		idx = bit_offset[i] / 4;
-		if (idx > IMX_LPCG_MAX_CLKS) {
+		if (idx >= IMX_LPCG_MAX_CLKS) {
 			dev_warn(&pdev->dev, "invalid bit offset of clock %d\n",
 				 i);
 			ret = -EINVAL;
-- 
2.34.1



