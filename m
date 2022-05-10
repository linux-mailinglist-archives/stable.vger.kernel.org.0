Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD26521A1B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241635AbiEJNxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245034AbiEJNrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83853F37;
        Tue, 10 May 2022 06:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 212C3615C8;
        Tue, 10 May 2022 13:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA89C385A6;
        Tue, 10 May 2022 13:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189638;
        bh=UhBKpGL8cPyYowpKftBHgS+lPYgVg1AsN+aW/7096eI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VpmNEpDBG7egfpwitvuhqqXiDaupt+QfPvSv4CuYp/PRZxA4XuYWrnyNwgg7MhXH
         8frW7Xpb9mvaf/k/JAPC1/i07YyInkxsIVitn6zAjyrdUTW4bXU5l9OSuCP8DW27kO
         +Io/ONYuyFafHgtlcBKJiLo6UjaQdI73v3dGOVDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 114/135] PCI: aardvark: Assert PERST# when unbinding driver
Date:   Tue, 10 May 2022 15:08:16 +0200
Message-Id: <20220510130743.672985202@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 1f54391be8ce0c981d312cb93acdc5608def576a upstream.

Put the PCIe card into reset by asserting PERST# signal when unbinding
driver. It doesn't make sense to leave the card working if it can't
communicate with the host. This should also save some power.

Link: https://lore.kernel.org/r/20211130172913.9727-10-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1721,6 +1721,10 @@ static int advk_pcie_remove(struct platf
 	/* Free config space for emulated root bridge */
 	pci_bridge_emul_cleanup(&pcie->bridge);
 
+	/* Assert PERST# signal which prepares PCIe card for power down */
+	if (pcie->reset_gpio)
+		gpiod_set_value_cansleep(pcie->reset_gpio, 1);
+
 	/* Disable outbound address windows mapping */
 	for (i = 0; i < OB_WIN_COUNT; i++)
 		advk_pcie_disable_ob_win(pcie, i);


