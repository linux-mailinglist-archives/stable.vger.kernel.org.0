Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD306965A3
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjBNOBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjBNOBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:01:03 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC05729417
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id gn39so1992411ejc.8
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTWPMQ5IkIsp33gvRTV303Woi805qt5LWeJY1A4m9uw=;
        b=QwMO0jLYP/Cb5IxKWAleZTQW6+mG608+WpsOQfM/Ffw+EnNfHoUINX1QEVxlQJKdzV
         rozLkcwjPml6UZJZYsufRRawXSFTbGSVLZq2StdvgYZALP4usCFsrKreC/rVUt6CBA6Z
         LlFdtOtbKxmolgp8EpGEAiZhC0xkMhW7cq0HIP2RgYr7CS/+KNNcgzFDBUXxcBAdBtT7
         IoxGscYITBCxpqPyN4Guu+px1KYUxNOwBvIPPDRIUzU8O7vj8zkniW7+TbaqaX6l8Pq+
         Zp1Qo6oaR62c/l481r2li3f7zJZZdHrW5u2GunAL93yltMJesZEN1wLbNH02bD9oaULD
         XR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CTWPMQ5IkIsp33gvRTV303Woi805qt5LWeJY1A4m9uw=;
        b=OojUvB68c5nwORvhgn/30MoaliOKMDPDthQ+zB29Qu+SwTM4lQSzMETdIzlEyiCIWr
         9AXmZ4X6ZE7SDBaEl5HFWVWVFXlAJoDZhl+JPasjv/aBEx6Ma97zPH7dfvs0dJqPwTRB
         76+F/ZyELH18anVA3YotF0a8S/eJX1NxHO2wC2bg76+0qWaQ/ztoVC56pn2cnMqwdTfk
         0a9BsS5UmASuEKhxIGXYIMZNRkNUl6pQa1ljnJMUUfF9aWpHYB/T1WegYx+WAX4iNAbl
         7zvLcXND916fjpZflbGvJwzOcPQhMlOlKOnE2AEa9NLp/SWYR5P/raDLSJ9Q0TtBelp+
         evSA==
X-Gm-Message-State: AO0yUKWLnVMfvUq50xxSAUlETrS1UB3xKe6VaAA+tkyxSe+GA345whWq
        OYdTbwAgBjGWMiRnLoSLlHnvRpEtlZo=
X-Google-Smtp-Source: AK7set8E7CpDgGUTsUZI7xuwC+3BZFUlKBetsnH2j8P4ZgxPrLHUpyi+l6SbIYfk02RWQ5fWS0oe4w==
X-Received: by 2002:a17:907:215a:b0:8aa:bdeb:83b5 with SMTP id rk26-20020a170907215a00b008aabdeb83b5mr2882952ejb.18.1676383228091;
        Tue, 14 Feb 2023 06:00:28 -0800 (PST)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id r1-20020a17090638c100b0088091cca1besm8273624ejd.134.2023.02.14.06.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:00:27 -0800 (PST)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     rick.wertenbroek@heig-vd.ch
Cc:     Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/9] PCI: rockchip: Assert PCI Configuration Enable bit after probe
Date:   Tue, 14 Feb 2023 14:56:24 +0100
Message-Id: <20230214135630.1131245-4-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214135630.1131245-1-rick.wertenbroek@gmail.com>
References: <20230214135630.1131245-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 drivers/pci/controller/pcie-rockchip-ep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 9b835377b..4c84e403e 100644
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

