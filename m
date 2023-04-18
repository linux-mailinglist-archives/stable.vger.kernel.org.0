Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF69A6E5AD0
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 09:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjDRHsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 03:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjDRHsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 03:48:14 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AAB7282;
        Tue, 18 Apr 2023 00:47:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dm2so70932344ejc.8;
        Tue, 18 Apr 2023 00:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681804072; x=1684396072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2z2R80OMli9rIgGN+Ri0ZIDvyCO42RC0Zf1krQq6+rI=;
        b=LpqzbLwkRO1auyk7jpK72HLpuMMWEBAc+xnrjZ0AGw0NjBYJW0ZSdyvFNERhcoU8mn
         Ox1TOa26VhjZEifW9eAmjemdpSzndaCGu9lpwskDUde5tQap+inZaI7a9a9GM0/Y9/cL
         N7Keu6ZeROEmBwj2XdiqOnje4gUFyry3jn4Gr+380t1VNV923CdtDj64k08E7XatYHLc
         vH2rm2czqruIatSwbzBFBNJ5zYk0N+qBwACkbJOZ1L5FWPSHdBXUKH1qMuBDQNeD2wXX
         MSRaHYYaaK2FDekzIHarewfJJvxEj5nRFNNohP4Z7e+wVV/Fysi/sKtkXEXHg1dsvizF
         7FLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681804072; x=1684396072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2z2R80OMli9rIgGN+Ri0ZIDvyCO42RC0Zf1krQq6+rI=;
        b=lvCnTf2fabrP/NfzJMQfWjGtItcfX0Kc53lKdvc325BetJNTnFb4TnLQfEs45sNRrF
         Ad9zJDGixM0rLEfAeRDKuOQwln7gtAmZQJ7LT/eWbDDxvoYYiR43tnfI4HqH1ZhRsi+g
         xAzzoaYl9SNJ55D1pUE7eZ8ie4l6yaeMCNLd0taSUkKGyqOhP2AhCX0IaE3oprmG6+zE
         ytCedKaN2eKkPFn7dLh46CRnpnp/Mi2DSFpZ6NbWFgi8lAAZ6ndZH9kFGS0DC47O/1/e
         NfZsAyINGqi18CVdirh+guSe3hxdPsRpozfZ6AmYt9Aex6JX1eELr/W4q6yWo0RCPTTQ
         2BPQ==
X-Gm-Message-State: AAQBX9e4sIP11e1CMwYbPXrAlxF4evU8R9oLFJyHN43D/4VoxrXodzJK
        IgmOFbYduWZ7DoSYiGhW3l4=
X-Google-Smtp-Source: AKy350am/zry1AdYQTC1umJP8nQYB9WSA9fwlD9GorRS9Knzt10w4q4IXGXAo5cpWB+w2c+eaW6ZCw==
X-Received: by 2002:a17:906:af9a:b0:94e:e6b9:fef2 with SMTP id mj26-20020a170906af9a00b0094ee6b9fef2mr10101019ejb.67.1681804071970;
        Tue, 18 Apr 2023 00:47:51 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id gs8-20020a1709072d0800b0094f694e4ecbsm3048545ejc.146.2023.04.18.00.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 00:47:51 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, dlemoal@kernel.org,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Johan Jonker <jbx6244@gmail.com>,
        Caleb Connolly <kc@postmarketos.org>,
        Brian Norris <briannorris@chromium.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 03/11] PCI: rockchip: Assert PCI Configuration Enable bit after probe
Date:   Tue, 18 Apr 2023 09:46:50 +0200
Message-Id: <20230418074700.1083505-4-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418074700.1083505-1-rick.wertenbroek@gmail.com>
References: <20230418074700.1083505-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Assert PCI Configuration Enable bit after probe. When this bit is left to
0 in the endpoint mode, the RK3399 PCIe endpoint core will generate
configuration request retry status (CRS) messages back to the root complex.
Assert this bit after probe to allow the RK3399 PCIe endpoint core to reply
to configuration requests from the root complex.
This is documented in section 17.5.8.1.2 of the RK3399 TRM.

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 9b835377bd9e..d00baed65eba 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -623,6 +623,9 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
 
 	ep->irq_pci_addr = ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR;
 
+	rockchip_pcie_write(rockchip, PCIE_CLIENT_CONF_ENABLE,
+			    PCIE_CLIENT_CONFIG);
+
 	return 0;
 err_epc_mem_exit:
 	pci_epc_mem_exit(epc);
-- 
2.25.1

