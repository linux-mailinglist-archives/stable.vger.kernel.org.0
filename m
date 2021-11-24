Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B68045C615
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349676AbhKXOFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353618AbhKXOAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21D0E61244;
        Wed, 24 Nov 2021 13:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759357;
        bh=CKrfun4YaJMnTvB3qUf9eaC7pdw17lPkUjX475xzcfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaCRrYTWlGX7czFAAORzz2uxYfyVYbPPEoMuxYByXVqp7pQ97ZEH05YUU3pSp6VPh
         NoUWgM8n0JY93TkEdz6eMRYg8WH2p48kMpG4pP9ypKhReOnVEytCn/aFZWPymqVPwD
         oW5Cg148SjA9BD9ueyRu332Rm9rIxUi559W4EW4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay <knv418@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Matthew Perkowski <mgperkow@gmail.com>, stable@kernel.org
Subject: [PATCH 5.15 214/279] ata: libata: add missing ata_identify_page_supported() calls
Date:   Wed, 24 Nov 2021 12:58:21 +0100
Message-Id: <20211124115726.136794577@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 06f6c4c6c3e8354dceddd77bd58f9a7a84c67246 upstream.

ata_dev_config_ncq_prio() and ata_dev_config_devslp() both access pages
of the IDENTIFY DEVICE data log. Before calling ata_read_log_page(),
make sure to check for the existence of the IDENTIFY DEVICE data log and
of the log page accessed using ata_identify_page_supported(). This
avoids useless error messages from ata_read_log_page() and failures with
some LLDD scsi drivers using libsas.

Reported-by: Nikolay <knv418@gmail.com>
Cc: stable@kernel.org # 5.15
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Matthew Perkowski <mgperkow@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2167,6 +2167,9 @@ static void ata_dev_config_ncq_prio(stru
 	struct ata_port *ap = dev->link->ap;
 	unsigned int err_mask;
 
+	if (!ata_identify_page_supported(dev, ATA_LOG_SATA_SETTINGS))
+		return;
+
 	err_mask = ata_read_log_page(dev,
 				     ATA_LOG_IDENTIFY_DEVICE,
 				     ATA_LOG_SATA_SETTINGS,
@@ -2443,7 +2446,8 @@ static void ata_dev_config_devslp(struct
 	 * Check device sleep capability. Get DevSlp timing variables
 	 * from SATA Settings page of Identify Device Data Log.
 	 */
-	if (!ata_id_has_devslp(dev->id))
+	if (!ata_id_has_devslp(dev->id) ||
+	    !ata_identify_page_supported(dev, ATA_LOG_SATA_SETTINGS))
 		return;
 
 	err_mask = ata_read_log_page(dev,


