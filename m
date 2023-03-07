Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6286AED96
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCGSFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjCGSF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:05:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9CD94A76
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 893D6B81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF00EC433EF;
        Tue,  7 Mar 2023 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211902;
        bh=yysW5M1tTUvQ5PULybPKFKtjntc7qtk70DxuzXCvvLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pX6DV5UZFJlfIN4RMkdxXmT6Z/VViNMUkAk4SBv0ik6hWeQXWRG8/zyctPyispMbD
         Vt2q2koHns/xVv5Bvm8ltHqwmGggMxZ9wXW8j1Jz3+fgXyxdLp9PxBfSGEa/Mg42A1
         KfpCFCBDgyevmp+Ib4n6Cz9Irk/joi0bYx0pFE8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 6.1 004/885] ata: ahci: Revert "ata: ahci: Add Tiger Lake UP{3,4} AHCI controller"
Date:   Tue,  7 Mar 2023 17:48:58 +0100
Message-Id: <20230307170001.821308285@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 6210038aeaf49c395c2da57572246d93ec67f6d4 upstream.

Commit 104ff59af73a ("ata: ahci: Add Tiger Lake UP{3,4} AHCI
controller") enabled low power mode for the Tiger Lake AHIC adapter in
the author system but created regressions for others. Revert this patch
for now until a better solution is found to make this adapter
eco-friendly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217114
CC: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -422,7 +422,6 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x34d3), board_ahci_low_power }, /* Ice Lake LP AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d3), board_ahci_low_power }, /* Comet Lake PCH-U AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d7), board_ahci_low_power }, /* Comet Lake PCH RAID */
-	{ PCI_VDEVICE(INTEL, 0xa0d3), board_ahci_low_power }, /* Tiger Lake UP{3,4} AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


