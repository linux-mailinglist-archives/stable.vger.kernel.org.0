Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536F53CDF25
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345130AbhGSPH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345756AbhGSPE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66C566113A;
        Mon, 19 Jul 2021 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709533;
        bh=LcbxIa7e05ZX3ykG3csMpr0pbIBpzTAFA4Hu+i1Ttw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCn72H4VkOUz7xZ66EIF1hd0ZiPxp2ic93sw8jorIZ1d0U9h38zIt2Xp9K9ulj1Aj
         qxHHuHH/Wynoam2sEoVgaE+gnu8mKkazuFf4XdqPtcpUDuFxmLLbs7S3qwKM9wriQv
         /30+URcUXTu3PlXQ9+c8PwM6FYScihqFjGbhWsFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 421/421] scsi: scsi_dh_alua: Fix signedness bug in alua_rtpg()
Date:   Mon, 19 Jul 2021 16:53:52 +0200
Message-Id: <20210719145000.914979752@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 80927822e8b6be46f488524cd7d5fe683de97fc4 upstream.

The "retval" variable needs to be signed for the error handling to work.

Link: https://lore.kernel.org/r/YLjMEAFNxOas1mIp@mwanda
Fixes: 7e26e3ea0287 ("scsi: scsi_dh_alua: Check for negative result value")
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -522,7 +522,8 @@ static int alua_rtpg(struct scsi_device
 	struct alua_port_group *tmp_pg;
 	int len, k, off, bufflen = ALUA_RTPG_SIZE;
 	unsigned char *desc, *buff;
-	unsigned err, retval;
+	unsigned err;
+	int retval;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 	unsigned long flags;


