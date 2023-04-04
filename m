Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCE46D5ABC
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 10:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbjDDIZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 04:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbjDDIZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 04:25:10 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7067A19A7;
        Tue,  4 Apr 2023 01:25:07 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id ek18so127305384edb.6;
        Tue, 04 Apr 2023 01:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680596706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qF/nMCildCwyVpeyLxx9Cd+w8QDEN538lEe16wXFDCI=;
        b=KPeJeCSwfeKvH7H6E26dseatEqJ9v0MMetQzsGXM1RDW2aIoacrBH4jEo3sHessNJx
         8XdDnvbed081Vz1ZrgkMUac7Qz1MHKoI10K8XqVGoyCq9XrYj1DpCCWLgklBbXUQJvqc
         HBfoDGXfQs7tr2em8wJNnIVxET3ZqeR1a+OZv7buK7aLvmmQ69/AHNsd7NCZDeO/aYCP
         jUR5ecJOa5V5WoCcayUxAiRMAeoqpyE1vexL+/nhWMFAbcl1fDyfNaPCmVaVR+2hcfQo
         BVFWRU/FewLlwT8XgkrXo/kEFud2xIRD1W9Q7xj9tNKKbYx+87iZQrcLdDKuELlYkUBh
         GIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680596706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qF/nMCildCwyVpeyLxx9Cd+w8QDEN538lEe16wXFDCI=;
        b=nZcEW7GCZPh30bPKD+I+zWv7mGTzfUqFDUtoTlsneVpXWXAqm3lQsXEK1PsDOAAW2E
         wxTEGsyneTDCT2otujaoBERfURHP6iGugkiZ8WJ9s56aP0NhWuNnQL3U0IgK+fj5HGpD
         DT4hfgols2Ak6EAghuSNn5K4oy/TlR9lvpXiTAbP5bmVzNeKQ3YWYWwxU1gDUzD9/hwg
         ogL2ffzHuNMHWDtEph87q1/0AyInWrh/FZVgjBa1e2cAOgTPOWJ/5vDYReIUgoESxEfm
         9FzACz8jqjPx4ZeGaXKoNXE5lMHXOXypCF9IQ7gmwe3dfCZ3l1+0bKY0NYcEfIULSMpS
         4V6A==
X-Gm-Message-State: AAQBX9d6CHe1IgX5DHGFjuIyvRopW6UiopCxtpEt1PdHB2/KlCAdLSdK
        iYXMGJzCoHSJslM7lfugUSY=
X-Google-Smtp-Source: AKy350aFi0idpnoR6KANcHGZyFCEUg8xjm8eY00CHU6x5aj4QXYqdnGg9gl2X6GiX//K2aVQf/Omaw==
X-Received: by 2002:a17:907:20aa:b0:931:9cd2:c214 with SMTP id pw10-20020a17090720aa00b009319cd2c214mr1429225ejb.66.1680596705882;
        Tue, 04 Apr 2023 01:25:05 -0700 (PDT)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id s5-20020a170906454500b008e54ac90de1sm5640652ejq.74.2023.04.04.01.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 01:25:05 -0700 (PDT)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     alberto.dassatti@heig-vd.ch
Cc:     damien.lemoal@opensource.wdc.com, xxm@rock-chips.com,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Johan Jonker <jbx6244@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Caleb Connolly <kc@postmarketos.org>,
        Lin Huang <hl@rock-chips.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/11] PCI: rockchip: Assert PCI Configuration Enable bit after probe
Date:   Tue,  4 Apr 2023 10:24:16 +0200
Message-Id: <20230404082426.3880812-4-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230404082426.3880812-1-rick.wertenbroek@gmail.com>
References: <20230404082426.3880812-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 9b835377bd9e..4c84e403e155 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -623,6 +623,8 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
 
 	ep->irq_pci_addr = ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR;
 
+	rockchip_pcie_write(rockchip, PCIE_CLIENT_CONF_ENABLE, PCIE_CLIENT_CONFIG);
+
 	return 0;
 err_epc_mem_exit:
 	pci_epc_mem_exit(epc);
-- 
2.25.1

