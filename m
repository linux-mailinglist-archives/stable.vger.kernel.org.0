Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF5654907F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380720AbiFMN7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381640AbiFMN5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:57:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240235F79;
        Mon, 13 Jun 2022 04:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B183612D2;
        Mon, 13 Jun 2022 11:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266B4C34114;
        Mon, 13 Jun 2022 11:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120240;
        bh=NeRGJsTd+8ow5SSHdLq19FLakGfB6AOFr65nju1xt/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ya1u09gHt1qMtcbzb7dpV8zQEhf/DbyQKzAmMyx67pPBeFyGcPw1SPC/wju53S05I
         787AqxHIU9fBHi3c7M7WaeyV3vTZeoyoxrTI32p/eDDCKgZR088iSMACqp/sF0zReW
         MGSVS2a1D2QxBDL9l/FGHy62+1HbOLKUOfIzn3c8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael English <michael.english@seagate.com>,
        Muhammad Ahmad <muhammad.ahmad@seagate.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Tyler Erickson <tyler.erickson@seagate.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.18 301/339] scsi: sd: Fix interpretation of VPD B9h length
Date:   Mon, 13 Jun 2022 12:12:06 +0200
Message-Id: <20220613094935.891462941@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

commit f92de9d110429e39929a49240d823251c2fe903e upstream.

Fixing the interpretation of the length of the B9h VPD page (Concurrent
Positioning Ranges). Adding 4 is necessary as the first 4 bytes of the page
is the header with page number and length information.  Adding 3 was likely
a misinterpretation of the SBC-5 specification which sets all offsets
starting at zero.

This fixes the error in dmesg:

[ 9.014456] sd 1:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page

Link: https://lore.kernel.org/r/20220602225113.10218-4-tyler.erickson@seagate.com
Fixes: e815d36548f0 ("scsi: sd: add concurrent positioning ranges support")
Cc: stable@vger.kernel.org
Tested-by: Michael English <michael.english@seagate.com>
Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3067,7 +3067,7 @@ static void sd_read_cpr(struct scsi_disk
 		goto out;
 
 	/* We must have at least a 64B header and one 32B range descriptor */
-	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
+	vpd_len = get_unaligned_be16(&buffer[2]) + 4;
 	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
 		sd_printk(KERN_ERR, sdkp,
 			  "Invalid Concurrent Positioning Ranges VPD page\n");


