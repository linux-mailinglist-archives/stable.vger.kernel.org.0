Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441DA6AEFA8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjCGSZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbjCGSYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:24:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B3F738BF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:20:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05A4DB818EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6D6C433D2;
        Tue,  7 Mar 2023 18:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213201;
        bh=GzmUm3VOWQdLobvHfaTyjwWRZiMDcuEDKxVev8MLmjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sno1R7KmkmV0clrW9xy7MfKVZdcDkr6p5faR+iM1FVUH3oy0U2GXsvbn7Eq/5T1w5
         Plkw4w8Vv9/qyBfpjoOqGTdOM5y/PnXgpgZ+EWFIFBeAuibqQJbYv0td5yL8GKpEDi
         plr0tD0Y7fy/zjVoaqRxodojc3PM2dlBkHBLMxog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 431/885] tty: serial: qcom-geni-serial: stop operations in progress at shutdown
Date:   Tue,  7 Mar 2023 17:56:05 +0100
Message-Id: <20230307170021.139332126@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit d8aca2f96813d51df574a811eda9a2cbed00f261 ]

We don't stop transmissions in progress at shutdown. This is fine with
FIFO SE mode but with DMA (support for which we'll introduce later) it
causes trouble so fix it now.

Fixes: e83766334f96 ("tty: serial: qcom_geni_serial: No need to stop tx/rx on UART shutdown")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20221229155030.418800-2-brgl@bgdev.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 7905935b9f1b4..fd72644605e05 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -891,6 +891,8 @@ static int setup_fifos(struct qcom_geni_serial_port *port)
 static void qcom_geni_serial_shutdown(struct uart_port *uport)
 {
 	disable_irq(uport->irq);
+	qcom_geni_serial_stop_tx(uport);
+	qcom_geni_serial_stop_rx(uport);
 }
 
 static int qcom_geni_serial_port_setup(struct uart_port *uport)
-- 
2.39.2



