Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E774159425C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349816AbiHOVsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350257AbiHOVrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:47:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB875FAD0;
        Mon, 15 Aug 2022 12:31:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DB68B81125;
        Mon, 15 Aug 2022 19:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BC0C433C1;
        Mon, 15 Aug 2022 19:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591886;
        bh=8xVoADYwIv4LNKJ9F7p8sP2HeEkSfNtj+oTvGTxCvuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kv6aiWSxGJ9RKEg0+EpWhF7HNZNZXcTNkQYH9pdX8scKioL3qCXyLhWmCeaFEPi/4
         vN78iUEE6uI32yrralX6PNAUrR21jaX+F5BYo+0QbdofvnbK9Yi+X1cGIItx48cq1m
         300yNkG/c53ouISPSnaHCGWxZjq8QX45haY1NaN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Neal Liu <neal_liu@aspeedtech.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0699/1095] usb: gadget: f_mass_storage: Make CD-ROM emulation works with Windows OS
Date:   Mon, 15 Aug 2022 20:01:38 +0200
Message-Id: <20220815180458.306057483@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Liu <neal_liu@aspeedtech.com>

[ Upstream commit 3b91edd624ab1ab694deef513a45eb9e9d49d75f ]

Add read TOC with format 1 to support CD-ROM emulation with
Windows OS.
This patch is tested on Windows OS Server 2019.

Fixes: 89ada0fe669a ("usb: gadget: f_mass_storage: Make CD-ROM emulation work with Mac OS-X")
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
Link: https://lore.kernel.org/r/20220628021436.3252262-1-neal_liu@aspeedtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 3a77bca0ebe1..e884f295504f 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -1192,13 +1192,14 @@ static int do_read_toc(struct fsg_common *common, struct fsg_buffhd *bh)
 	u8		format;
 	int		i, len;
 
+	format = common->cmnd[2] & 0xf;
+
 	if ((common->cmnd[1] & ~0x02) != 0 ||	/* Mask away MSF */
-			start_track > 1) {
+			(start_track > 1 && format != 0x1)) {
 		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 		return -EINVAL;
 	}
 
-	format = common->cmnd[2] & 0xf;
 	/*
 	 * Check if CDB is old style SFF-8020i
 	 * i.e. format is in 2 MSBs of byte 9
@@ -1208,8 +1209,8 @@ static int do_read_toc(struct fsg_common *common, struct fsg_buffhd *bh)
 		format = (common->cmnd[9] >> 6) & 0x3;
 
 	switch (format) {
-	case 0:
-		/* Formatted TOC */
+	case 0:	/* Formatted TOC */
+	case 1:	/* Multi-session info */
 		len = 4 + 2*8;		/* 4 byte header + 2 descriptors */
 		memset(buf, 0, len);
 		buf[1] = len - 2;	/* TOC Length excludes length field */
@@ -1250,7 +1251,7 @@ static int do_read_toc(struct fsg_common *common, struct fsg_buffhd *bh)
 		return len;
 
 	default:
-		/* Multi-session, PMA, ATIP, CD-TEXT not supported/required */
+		/* PMA, ATIP, CD-TEXT not supported/required */
 		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 		return -EINVAL;
 	}
-- 
2.35.1



