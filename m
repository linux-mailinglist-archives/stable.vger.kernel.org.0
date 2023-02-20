Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C53F69CEA0
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbjBTOA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbjBTOA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73AE1E5C4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:00:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B34360E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5DEC433D2;
        Mon, 20 Feb 2023 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901632;
        bh=BeQzhAygK/0+taI2usxd4/6EDpkOrj3G1OySmVwa3qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Puy7yCpeQxA9prqo7eZpxk2oU2DkHPUhF/6dGrReKbUHSWVbHTUsTQbNxtO4ddZPJ
         FUNjOWkUvFrek0jiOZs/OZqV57CzDfJ+2lMlmcAglD+JlVFPR3WmiOUEVrzth7n4U9
         3D88TYp1ytDVTvBO5xvGkUE4IAv73Y1rr25zvKGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Simon Gaiser <simon@invisiblethingslab.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 6.1 064/118] ata: ahci: Add Tiger Lake UP{3,4} AHCI controller
Date:   Mon, 20 Feb 2023 14:36:20 +0100
Message-Id: <20230220133602.990902082@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Gaiser <simon@invisiblethingslab.com>

commit 104ff59af73aba524e57ae0fef70121643ff270e upstream.

Mark the Tiger Lake UP{3,4} AHCI controller as "low_power". This enables
S0ix to work out of the box. Otherwise this isn't working unless the
user manually sets /sys/class/scsi_host/*/link_power_management_policy.

Intel lists a total of 4 SATA controller IDs in [1] for those mobile
PCHs. This commit just adds the "AHCI" variant since I only tested
those.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/631119

Signed-off-by: Simon Gaiser <simon@invisiblethingslab.com>
CC: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -422,6 +422,7 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x34d3), board_ahci_low_power }, /* Ice Lake LP AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d3), board_ahci_low_power }, /* Comet Lake PCH-U AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d7), board_ahci_low_power }, /* Comet Lake PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0xa0d3), board_ahci_low_power }, /* Tiger Lake UP{3,4} AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


