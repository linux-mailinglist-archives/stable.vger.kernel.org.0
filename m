Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8135D594280
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbiHOVvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350348AbiHOVvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:51:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65959104B24;
        Mon, 15 Aug 2022 12:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 463EECE12DB;
        Mon, 15 Aug 2022 19:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D3EC433C1;
        Mon, 15 Aug 2022 19:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591945;
        bh=exXlSyE6+QPcILp+nxmGivamKTdZ39q0PQQr8Zupu9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFZWbY3+/XlNxBUkgyiEpFi3kJuYnh59rhShxtM6vOgqmOL4U8YnAHcFvQ+DbDRe7
         vPCZ4UbIyPC33UOs73GFWvZcgBOytnB/1HoWa8MObWS38KXolRrCBNj/c8QeLx1yKi
         kc4DuXasggjHduFAX5VPxb5I+KrIRgTs+YiAMVww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0708/1095] clk: qcom: ipq8074: fix NSS port frequency tables
Date:   Mon, 15 Aug 2022 20:01:47 +0200
Message-Id: <20220815180458.671139666@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 0e9e61a2815b5cd34f1b495b2d72e8127ce9b794 ]

NSS port 5 and 6 frequency tables are currently broken and are causing a
wide ranges of issue like 1G not working at all on port 6 or port 5 being
clocked with 312 instead of 125 MHz as UNIPHY1 gets selected.

So, update the frequency tables with the ones from the downstream QCA 5.4
based kernel which has already fixed this.

Fixes: 7117a51ed303 ("clk: qcom: ipq8074: add NSS ethernet port clocks")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220515210048.483898-3-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq8074.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index b4291ba53c78..f1017f2e61bd 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -1788,8 +1788,10 @@ static struct clk_regmap_div nss_port4_tx_div_clk_src = {
 static const struct freq_tbl ftbl_nss_port5_rx_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(25000000, P_UNIPHY1_RX, 12.5, 0, 0),
+	F(25000000, P_UNIPHY0_RX, 5, 0, 0),
 	F(78125000, P_UNIPHY1_RX, 4, 0, 0),
 	F(125000000, P_UNIPHY1_RX, 2.5, 0, 0),
+	F(125000000, P_UNIPHY0_RX, 1, 0, 0),
 	F(156250000, P_UNIPHY1_RX, 2, 0, 0),
 	F(312500000, P_UNIPHY1_RX, 1, 0, 0),
 	{ }
@@ -1828,8 +1830,10 @@ static struct clk_regmap_div nss_port5_rx_div_clk_src = {
 static const struct freq_tbl ftbl_nss_port5_tx_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(25000000, P_UNIPHY1_TX, 12.5, 0, 0),
+	F(25000000, P_UNIPHY0_TX, 5, 0, 0),
 	F(78125000, P_UNIPHY1_TX, 4, 0, 0),
 	F(125000000, P_UNIPHY1_TX, 2.5, 0, 0),
+	F(125000000, P_UNIPHY0_TX, 1, 0, 0),
 	F(156250000, P_UNIPHY1_TX, 2, 0, 0),
 	F(312500000, P_UNIPHY1_TX, 1, 0, 0),
 	{ }
@@ -1867,8 +1871,10 @@ static struct clk_regmap_div nss_port5_tx_div_clk_src = {
 
 static const struct freq_tbl ftbl_nss_port6_rx_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
+	F(25000000, P_UNIPHY2_RX, 5, 0, 0),
 	F(25000000, P_UNIPHY2_RX, 12.5, 0, 0),
 	F(78125000, P_UNIPHY2_RX, 4, 0, 0),
+	F(125000000, P_UNIPHY2_RX, 1, 0, 0),
 	F(125000000, P_UNIPHY2_RX, 2.5, 0, 0),
 	F(156250000, P_UNIPHY2_RX, 2, 0, 0),
 	F(312500000, P_UNIPHY2_RX, 1, 0, 0),
@@ -1907,8 +1913,10 @@ static struct clk_regmap_div nss_port6_rx_div_clk_src = {
 
 static const struct freq_tbl ftbl_nss_port6_tx_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
+	F(25000000, P_UNIPHY2_TX, 5, 0, 0),
 	F(25000000, P_UNIPHY2_TX, 12.5, 0, 0),
 	F(78125000, P_UNIPHY2_TX, 4, 0, 0),
+	F(125000000, P_UNIPHY2_TX, 1, 0, 0),
 	F(125000000, P_UNIPHY2_TX, 2.5, 0, 0),
 	F(156250000, P_UNIPHY2_TX, 2, 0, 0),
 	F(312500000, P_UNIPHY2_TX, 1, 0, 0),
-- 
2.35.1



