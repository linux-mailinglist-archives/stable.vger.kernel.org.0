Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320A3549151
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385814AbiFMOuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385899AbiFMOss (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB5BC047E;
        Mon, 13 Jun 2022 04:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A57C61425;
        Mon, 13 Jun 2022 11:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350A9C34114;
        Mon, 13 Jun 2022 11:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121179;
        bh=B7tnLXZ9zOFwqW4lhSdUyligTwXyJWYFGo6O+Ex6O7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekT9F0orK09gyrOiv+HF26iJ+yKR21hsv1JdK5FGrnAGZifekzdjj8c5oEdvo/vGX
         LGfCcTADGHMH6Crghq0UYTXwHxzVVIT2L2kNr6op99sqbmECWeF02wsqs7Z79pxAsq
         unEj2+qVY25lhGWUS0xHFvxDMmE0QMHk+3doLU+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tyler Erickson <tyler.erickson@seagate.com>,
        Muhammad Ahmad <muhammad.ahmad@seagate.com>,
        Michael English <michael.english@seagate.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.17 267/298] libata: fix reading concurrent positioning ranges log
Date:   Mon, 13 Jun 2022 12:12:41 +0200
Message-Id: <20220613094933.170957037@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Tyler Erickson <tyler.erickson@seagate.com>

commit c745dfc541e78428ba3986f1d17fe1dfdaca8184 upstream.

The concurrent positioning ranges log is not a fixed size and may depend
on how many ranges are supported by the device. This patch uses the size
reported in the GPL directory to determine the number of pages supported
by the device before attempting to read this log page.

This resolves this error from the dmesg output:
    ata6.00: Read log 0x47 page 0x00 failed, Emask 0x1

Cc: stable@vger.kernel.org
Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
Tested-by: Michael English <michael.english@seagate.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2003,16 +2003,16 @@ retry:
 	return err_mask;
 }
 
-static bool ata_log_supported(struct ata_device *dev, u8 log)
+static int ata_log_supported(struct ata_device *dev, u8 log)
 {
 	struct ata_port *ap = dev->link->ap;
 
 	if (dev->horkage & ATA_HORKAGE_NO_LOG_DIR)
-		return false;
+		return 0;
 
 	if (ata_read_log_page(dev, ATA_LOG_DIRECTORY, 0, ap->sector_buf, 1))
-		return false;
-	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
+		return 0;
+	return get_unaligned_le16(&ap->sector_buf[log * 2]);
 }
 
 static bool ata_identify_page_supported(struct ata_device *dev, u8 page)
@@ -2448,15 +2448,20 @@ static void ata_dev_config_cpr(struct at
 	struct ata_cpr_log *cpr_log = NULL;
 	u8 *desc, *buf = NULL;
 
-	if (ata_id_major_version(dev->id) < 11 ||
-	    !ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES))
+	if (ata_id_major_version(dev->id) < 11)
+		goto out;
+
+	buf_len = ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES);
+	if (buf_len == 0)
 		goto out;
 
 	/*
 	 * Read the concurrent positioning ranges log (0x47). We can have at
-	 * most 255 32B range descriptors plus a 64B header.
+	 * most 255 32B range descriptors plus a 64B header. This log varies in
+	 * size, so use the size reported in the GPL directory. Reading beyond
+	 * the supported length will result in an error.
 	 */
-	buf_len = (64 + 255 * 32 + 511) & ~511;
+	buf_len <<= 9;
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		goto out;


