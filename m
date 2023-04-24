Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7B66ECEDA
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbjDXNf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbjDXNfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:35:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65DF7293
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4383623D5
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36B8C4339B;
        Mon, 24 Apr 2023 13:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343328;
        bh=rq5cJCW4nduU2inL89NY07DZtQ1bNPXu5XRxzFf6FBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mubS1mDPXlmxn00u+D0mAjkCVjyv5vg/8VRh5Pb5XBkmWGm/KVuXx7eHckKzu7X9e
         dTf7ek0mr0j9X3rD0astnUE1wPyq6jYwYBlMoH13Enxgr5yvY91s3FG07ShON00cOH
         QrvQfvRqvSSv+M9qb5YhI+yfiv/Rt3KSN1PKQcHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/68] scsi: core: Improve scsi_vpd_inquiry() checks
Date:   Mon, 24 Apr 2023 15:17:54 +0200
Message-Id: <20230424131128.525486378@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit f0aa59a33d2ac2267d260fe21eaf92500df8e7b4 ]

Some USB-SATA adapters have broken behavior when an unsupported VPD page is
probed: Depending on the VPD page number, a 4-byte header with a valid VPD
page number but with a 0 length is returned. Currently, scsi_vpd_inquiry()
only checks that the page number is valid to determine if the page is
valid, which results in receiving only the 4-byte header for the
non-existent page. This error manifests itself very often with page 0xb9
for the Concurrent Positioning Ranges detection done by sd_read_cpr(),
resulting in the following error message:

sd 0:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page

Prevent such misleading error message by adding a check in
scsi_vpd_inquiry() to verify that the page length is not 0.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20230322022211.116327-1-damien.lemoal@opensource.wdc.com
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 6ad834d61d4c7..d6c25a88cebc9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -317,11 +317,18 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	if (result)
 		return -EIO;
 
-	/* Sanity check that we got the page back that we asked for */
+	/*
+	 * Sanity check that we got the page back that we asked for and that
+	 * the page size is not 0.
+	 */
 	if (buffer[1] != page)
 		return -EIO;
 
-	return get_unaligned_be16(&buffer[2]) + 4;
+	result = get_unaligned_be16(&buffer[2]);
+	if (!result)
+		return -EIO;
+
+	return result + 4;
 }
 
 /**
-- 
2.39.2



