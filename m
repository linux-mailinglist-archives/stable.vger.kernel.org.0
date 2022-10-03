Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67EF5F2AE6
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiJCHo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiJCHms (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:42:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97ADD237FD;
        Mon,  3 Oct 2022 00:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67949B80E96;
        Mon,  3 Oct 2022 07:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5E2C433D6;
        Mon,  3 Oct 2022 07:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781898;
        bh=Fic6drM20wOIy+Wl7LBE8Scc1pXUDEJK0y2SJhw/2g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTFqt+xF65KDB2e3JiJngKonASXxM9TZUAH+bhpPFH1tn0q+XqgOPhrUZugXpIsY0
         CxrPmo2SY1FRtMhwjnAlKaCWxMb6M9tT2qBuIMz31+NGlVLSfnrKiliSPJlzR+FmaC
         QjAyUm+cYfKYloDBF0h8Bq9AvrBzrKUIBrxYN9Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jaap Berkhout <j.j.berkhout@staalenberk.nl>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.19 07/25] libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and BDR-205
Date:   Mon,  3 Oct 2022 09:12:10 +0200
Message-Id: <20221003070715.622701551@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
References: <20221003070715.406550966@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

commit ea08aec7e77bfd6599489ec430f9f859ab84575a upstream.

Commit 1527f69204fe ("ata: ahci: Add Green Sardine vendor ID as
board_ahci_mobile") added an explicit entry for AMD Green Sardine
AHCI controller using the board_ahci_mobile configuration (this
configuration has later been renamed to board_ahci_low_power).

The board_ahci_low_power configuration enables support for low power
modes.

This explicit entry takes precedence over the generic AHCI controller
entry, which does not enable support for low power modes.

Therefore, when commit 1527f69204fe ("ata: ahci: Add Green Sardine
vendor ID as board_ahci_mobile") was backported to stable kernels,
it make some Pioneer optical drives, which was working perfectly fine
before the commit was backported, stop working.

The real problem is that the Pioneer optical drives do not handle low
power modes correctly. If these optical drives would have been tested
on another AHCI controller using the board_ahci_low_power configuration,
this issue would have been detected earlier.

Unfortunately, the board_ahci_low_power configuration is only used in
less than 15% of the total AHCI controller entries, so many devices
have never been tested with an AHCI controller with low power modes.

Fixes: 1527f69204fe ("ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile")
Cc: stable@vger.kernel.org
Reported-by: Jaap Berkhout <j.j.berkhout@staalenberk.nl>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4560,6 +4560,10 @@ static const struct ata_blacklist_entry
 	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
+	/* These specific Pioneer models have LPM issues */
+	{ "PIONEER BD-RW   BDR-207M",	NULL,	ATA_HORKAGE_NOLPM },
+	{ "PIONEER BD-RW   BDR-205",	NULL,	ATA_HORKAGE_NOLPM },
+
 	/* Crucial BX100 SSD 500GB has broken LPM support */
 	{ "CT500BX100SSD1",		NULL,	ATA_HORKAGE_NOLPM },
 


