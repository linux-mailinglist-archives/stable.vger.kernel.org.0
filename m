Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD66541681
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376308AbiFGUxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378242AbiFGUve (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:51:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457061FE4FC;
        Tue,  7 Jun 2022 11:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 681B4B81FE1;
        Tue,  7 Jun 2022 18:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B469AC385A5;
        Tue,  7 Jun 2022 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627312;
        bh=7MXVjTOkzkp0cqe05piXDI6xTc6wj6lQz9zsbLMEO/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGWHXBWKIOMbVoaWzOiMx+klrGb349evyc5BMqwOuugzWDyySdCybxmHgN/imODP/
         VPi0fxe/jP8LHdUQ/awNP2IPqB6DVjHFx16KHrTHAq1mQKOoSvKzFxkgqytNb7h7jB
         5Zv4rJdlFPObaPQ5CVachN41Ue3F6NsccVKZH+qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.17 653/772] PCI/PM: Fix bridge_d3_blacklist[] Elo i2 overwrite of Gigabyte X299
Date:   Tue,  7 Jun 2022 19:04:05 +0200
Message-Id: <20220607165008.305445579@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
@@ -2920,6 +2920,8 @@ static const struct dmi_system_id bridge
 			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
 			DMI_MATCH(DMI_BOARD_NAME, "X299 DESIGNARE EX-CF"),
 		},
+	},
+	{
 		/*
 		 * Downstream device is not accessible after putting a root port
 		 * into D3cold and back into D0 on Elo i2.


