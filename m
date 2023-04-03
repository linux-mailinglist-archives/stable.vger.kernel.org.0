Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B33A6D4725
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjDCORe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbjDCORd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:17:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA072BECD
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF8ACB81B91
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228AFC433D2;
        Mon,  3 Apr 2023 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531449;
        bh=4omZSKTkIffqnauG7bNimvPwSOxuc8Am1Pj7x1PgLXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtQVyPiLbUGxXskhRJLouWEskfPqvjeyyp67bPzZQeAeig25Rlwmq+FAmym5LWI9L
         c9B+drAWw5u7svdb5alm2OcP+JLYOI6FiGACJhz/IaHv4JBMgBp9UzyMNhC6nJekZQ
         YxiEah6uNPkk3qMwIZhAwsvV4dAxbF7ATrs/WLwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Joel Selvaraj <joelselvaraj.oss@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 37/84] scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR
Date:   Mon,  3 Apr 2023 16:08:38 +0200
Message-Id: <20230403140354.621391025@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
@@ -232,6 +232,7 @@ static struct {
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
 	{"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"SKhynix", "H28U74301AMR", NULL, BLIST_SKIP_VPD_PAGES},
 	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},


