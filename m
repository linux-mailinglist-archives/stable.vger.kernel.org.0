Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC77549040
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352317AbiFMLZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353663AbiFMLYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:24:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECE813D67;
        Mon, 13 Jun 2022 03:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 023E3B80E94;
        Mon, 13 Jun 2022 10:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCC9C34114;
        Mon, 13 Jun 2022 10:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116939;
        bh=n+qJvALMCv5MoMuwEOWidACoeDxGUQxdZNNnpfPP+fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QoUi/3HubrgQtAZHVwC/MznUxZipF8peLJ+uR3UYkZxZli8yrwm/Bne0dXJKbuuA
         PlrckQCiwi+S4gRRg+21Aj2GEm9PUATEdKH66rQev2/k0PaeK9PSsF0AMK4Tt0l1JR
         Z2oQW8pGyFNHrpLYAdXZsOk0nqjeY9+HnOP6ORpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 230/411] PCI/PM: Fix bridge_d3_blacklist[] Elo i2 overwrite of Gigabyte X299
Date:   Mon, 13 Jun 2022 12:08:23 +0200
Message-Id: <20220613094935.538317127@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit 12068bb346db5776d0ec9bb4cd073f8427a1ac92 upstream.

92597f97a40b ("PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold") omitted
braces around the new Elo i2 entry, so it overwrote the existing Gigabyte
X299 entry.  Add the appropriate braces.

Found by:

  $ make W=1 drivers/pci/pci.o
    CC      drivers/pci/pci.o
  drivers/pci/pci.c:2974:12: error: initialized field overwritten [-Werror=override-init]
   2974 |   .ident = "Elo i2",
        |            ^~~~~~~~

Link: https://lore.kernel.org/r/20220526221258.GA409855@bhelgaas
Fixes: 92597f97a40b ("PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org  # v5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2613,6 +2613,8 @@ static const struct dmi_system_id bridge
 			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
 			DMI_MATCH(DMI_BOARD_NAME, "X299 DESIGNARE EX-CF"),
 		},
+	},
+	{
 		/*
 		 * Downstream device is not accessible after putting a root port
 		 * into D3cold and back into D0 on Elo i2.


