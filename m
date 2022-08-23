Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5025759E145
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358856AbiHWLy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358720AbiHWLxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4BFD5711;
        Tue, 23 Aug 2022 02:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9A1C60F50;
        Tue, 23 Aug 2022 09:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F9DC433C1;
        Tue, 23 Aug 2022 09:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247155;
        bh=hH9EABSe28KlyoKoCa/fmsYDX15i5Xi3gViSaf2aJNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C11U5nzjgSRslYmWcuVrRFMymdebMbP6mAuVuK74rdbwS5+YBceEVTGTeH2KqH6VL
         uKFcNM8ShACV+hcEIOnnWPlvRklz9gijH4uxatfoadvPHGu/YdMSvlLZsUwDO/jU93
         gOVTIxFi1G3iEJbuYRgGAayMFKpkRp0NZIf0TgLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Alexander Kochetkov <al.kochet@gmail.com>
Subject: [PATCH 5.4 336/389] clk: rockchip: add sclk_mac_lbtest to rk3188_critical_clocks
Date:   Tue, 23 Aug 2022 10:26:54 +0200
Message-Id: <20220823080129.556787490@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Alex Bee <knaerzche@gmail.com>

commit ef990bcad58cf1d13c5a49191a2c2342eb8d6709 upstream.

Since the loopbacktest clock is not exported and is not touched in the
driver, it has to be added to rk3188_critical_clocks to be protected from
being disabled and in order to get the emac working.

Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20200722161820.5316-1-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Cc: Alexander Kochetkov <al.kochet@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/rockchip/clk-rk3188.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -751,6 +751,7 @@ static const char *const rk3188_critical
 	"pclk_peri",
 	"hclk_cpubus",
 	"hclk_vio_bus",
+	"sclk_mac_lbtest",
 };
 
 static struct rockchip_clk_provider *__init rk3188_common_clk_init(struct device_node *np)


