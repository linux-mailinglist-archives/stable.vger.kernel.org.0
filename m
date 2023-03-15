Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9516BB2BA
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjCOMiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbjCOMhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:37:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2400DA1FCD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 927FEB81E09
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C6AC433D2;
        Wed, 15 Mar 2023 12:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883758;
        bh=g8LqNWo8ULGajspdQobRw2/BlnNPtxYZEW31rZA9jqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvmNHUhfSJ/xVgIIkOLUqYbzY9Mg55Y9d08rWLEAfNy1AQlf36B4CsRsKS0wOTmD1
         89y2c9k9J40AZOr+fBdVAtz8G/9JBfr0xqB7WyzUKkUfDvd/l2reS9CcesKzB6CPkf
         0vmA9Efcx2i7RXa119LgL+uaOwb1b6sF5yQ0MMa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Erkki Eilonen <erkki@bearmetal.eu>,
        Morten Linderud <morten@linderud.pw>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/143] tpm/eventlog: Dont abort tpm_read_log on faulty ACPI address
Date:   Wed, 15 Mar 2023 13:13:27 +0100
Message-Id: <20230315115744.190254413@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Morten Linderud <morten@linderud.pw>

[ Upstream commit 80a6c216b16d7f5c584d2148c2e4345ea4eb06ce ]

tpm_read_log_acpi() should return -ENODEV when no eventlog from the ACPI
table is found. If the firmware vendor includes an invalid log address
we are unable to map from the ACPI memory and tpm_read_log() returns -EIO
which would abort discovery of the eventlog.

Change the return value from -EIO to -ENODEV when acpi_os_map_iomem()
fails to map the event log.

The following hardware was used to test this issue:
    Framework Laptop (Pre-production)
    BIOS: INSYDE Corp, Revision: 3.2
    TPM Device: NTC, Firmware Revision: 7.2

Dump of the faulty ACPI TPM2 table:
    [000h 0000   4]                    Signature : "TPM2"    [Trusted Platform Module hardware interface Table]
    [004h 0004   4]                 Table Length : 0000004C
    [008h 0008   1]                     Revision : 04
    [009h 0009   1]                     Checksum : 2B
    [00Ah 0010   6]                       Oem ID : "INSYDE"
    [010h 0016   8]                 Oem Table ID : "TGL-ULT"
    [018h 0024   4]                 Oem Revision : 00000002
    [01Ch 0028   4]              Asl Compiler ID : "ACPI"
    [020h 0032   4]        Asl Compiler Revision : 00040000

    [024h 0036   2]               Platform Class : 0000
    [026h 0038   2]                     Reserved : 0000
    [028h 0040   8]              Control Address : 0000000000000000
    [030h 0048   4]                 Start Method : 06 [Memory Mapped I/O]

    [034h 0052  12]            Method Parameters : 00 00 00 00 00 00 00 00 00 00 00 00
    [040h 0064   4]           Minimum Log Length : 00010000
    [044h 0068   8]                  Log Address : 000000004053D000

Fixes: 0cf577a03f21 ("tpm: Fix handling of missing event log")
Tested-by: Erkki Eilonen <erkki@bearmetal.eu>
Signed-off-by: Morten Linderud <morten@linderud.pw>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/eventlog/acpi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/eventlog/acpi.c b/drivers/char/tpm/eventlog/acpi.c
index 0913d3eb8d518..cd266021d0103 100644
--- a/drivers/char/tpm/eventlog/acpi.c
+++ b/drivers/char/tpm/eventlog/acpi.c
@@ -143,8 +143,12 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 
 	ret = -EIO;
 	virt = acpi_os_map_iomem(start, len);
-	if (!virt)
+	if (!virt) {
+		dev_warn(&chip->dev, "%s: Failed to map ACPI memory\n", __func__);
+		/* try EFI log next */
+		ret = -ENODEV;
 		goto err;
+	}
 
 	memcpy_fromio(log->bios_event_log, virt, len);
 
-- 
2.39.2



