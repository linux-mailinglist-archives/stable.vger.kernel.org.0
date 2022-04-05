Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEAF4F3535
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245459AbiDEIzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241200AbiDEIcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA7711156;
        Tue,  5 Apr 2022 01:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46F3860B0E;
        Tue,  5 Apr 2022 08:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54247C385A1;
        Tue,  5 Apr 2022 08:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147370;
        bh=7uhkbtOUa9s8KzYDK74oftBUK3hU4EOK2/CM37NcBEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNdWOBbf8EUHBrRBW44EgONtSetmgrAjpUXhvgkzNQyzTcqRkr+dn5uAlUIcMJ02v
         /DcX0Rm0cyt7zhErs3sGCgCJXrAe/+VO/qoeyiiWFXW25Km7naOolpZoR9dXH0/gDC
         +h3/Ztg0KTdKnbhIYe4cVzUK83IT5iA7s9LBMSto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zheng Bin <zhengbin13@huawei.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.17 1101/1126] ASoC: SOF: Intel: Fix build error without SND_SOC_SOF_PCI_DEV
Date:   Tue,  5 Apr 2022 09:30:48 +0200
Message-Id: <20220405070439.755867249@linuxfoundation.org>
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

From: Zheng Bin <zhengbin13@huawei.com>

commit 664d66dc0a64b32e60a5ad59a9aebb08676a612b upstream.

If SND_SOC_SOF_PCI_DEV is n, bulding fails:

sound/soc/sof/intel/pci-tng.o:(.data+0x1c0): undefined reference to `sof_pci_probe'
sound/soc/sof/intel/pci-tng.o:(.data+0x1c8): undefined reference to `sof_pci_remove'
sound/soc/sof/intel/pci-tng.o:(.data+0x1e0): undefined reference to `sof_pci_shutdown'
sound/soc/sof/intel/pci-tng.o:(.data+0x290): undefined reference to `sof_pci_pm'

Make SND_SOC_SOF_MERRIFIELD select SND_SOC_SOF_PCI_DEV to fix this.

Fixes: 8d4ba1be3d22 ("ASoC: SOF: pci: split PCI into different drivers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220323092501.145879-1-zhengbin13@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -84,6 +84,7 @@ if SND_SOC_SOF_PCI
 config SND_SOC_SOF_MERRIFIELD
 	tristate "SOF support for Tangier/Merrifield"
 	default SND_SOC_SOF_PCI
+	select SND_SOC_SOF_PCI_DEV
 	select SND_SOC_SOF_INTEL_ATOM_HIFI_EP
 	help
 	  This adds support for Sound Open Firmware for Intel(R) platforms


