Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6124FD982
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345340AbiDLHcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353659AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE2B2654A;
        Tue, 12 Apr 2022 00:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82DE2B81A8F;
        Tue, 12 Apr 2022 07:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB030C385A6;
        Tue, 12 Apr 2022 07:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747003;
        bh=kt8bCl6zviwQmwvSHDOF7FP52x9dCspdhUw6+zS4QsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIqGiPVc/VIGZW9Vm5WSD7O3Wovbp7QV+CEMJxXfR/H86E7FmqyAxqiJy6FzEJeKx
         f6NCGO+S+LUyZt3H9ZbyzrellvMmPd1F6jn+XcAj7mrd3a+V1TAsiJmLDwxXQoO/cL
         njhKMDjq6tInMdd799xt/GKdQEIikec3DkEeiaug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 201/285] scsi: sd: sd_read_cpr() requires VPD pages
Date:   Tue, 12 Apr 2022 08:30:58 +0200
Message-Id: <20220412062949.461893466@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Martin K. Petersen <martin.petersen@oracle.com>

[ Upstream commit 1700714b1ff252b634db21186db4d91e7e006043 ]

As such it should be called inside the scsi_device_supports_vpd()
conditional.

Link: https://lore.kernel.org/r/20220302053559.32147-13-martin.petersen@oracle.com
Fixes: e815d36548f0 ("scsi: sd: add concurrent positioning ranges support")
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dfca484dd0c4..95f4788619ed 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3321,6 +3321,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
 			sd_zbc_read_zones(sdkp, buffer);
+			sd_read_cpr(sdkp);
 		}
 
 		sd_print_capacity(sdkp, old_capacity);
@@ -3330,7 +3331,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_app_tag_own(sdkp, buffer);
 		sd_read_write_same(sdkp, buffer);
 		sd_read_security(sdkp, buffer);
-		sd_read_cpr(sdkp);
 	}
 
 	/*
-- 
2.35.1



