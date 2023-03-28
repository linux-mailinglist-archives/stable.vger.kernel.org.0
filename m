Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A966CC363
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbjC1Oxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjC1Ox1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:53:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7205D308
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78585B81BBF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59A6C4339E;
        Tue, 28 Mar 2023 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015203;
        bh=9hsS/okGxwCBR+WOx4ZbRSqYvE2dmW31JTytB/zOLpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FP9FlxZOcs7maLETeWMwUjmtZ2WMexvHPHlpuhl53eWxQeftcYc7zb1edCkdhR56A
         2T9AdHIwRm+T1sXRtoIYx+Uu5BZ6hJRbCgy9YOalQ4SVXiuhooPVUWFEu6PKsPzKJO
         phTsDLoBVKACVNt8gb4rl4loXLbxXUvzAv1a/dKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Joel Selvaraj <joelselvaraj.oss@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.2 172/240] scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR
Date:   Tue, 28 Mar 2023 16:42:15 +0200
Message-Id: <20230328142626.806645010@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Selvaraj <joelselvaraj.oss@gmail.com>

commit a204b490595de71016b2360a1886ec8c12d0afac upstream.

Xiaomi Poco F1 (qcom/sdm845-xiaomi-beryllium*.dts) comes with a SKhynix
H28U74301AMR UFS. The sd_read_cpr() operation leads to a 120 second
timeout, making the device bootup very slow:

[  121.457736] sd 0:0:0:1: [sdb] tag#23 timing out command, waited 120s

Setting the BLIST_SKIP_VPD_PAGES allows the device to skip the failing
sd_read_cpr operation and boot normally.

Signed-off-by: Joel Selvaraj <joelselvaraj.oss@gmail.com>
Link: https://lore.kernel.org/r/20230313041402.39330-1-joelselvaraj.oss@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_devinfo.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -234,6 +234,7 @@ static struct {
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
 	{"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"SKhynix", "H28U74301AMR", NULL, BLIST_SKIP_VPD_PAGES},
 	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},


