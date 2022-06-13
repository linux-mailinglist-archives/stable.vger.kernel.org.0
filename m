Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11F1549790
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383428AbiFMO0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383695AbiFMOXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2040746C9F;
        Mon, 13 Jun 2022 04:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B48B0612A8;
        Mon, 13 Jun 2022 11:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AD8C34114;
        Mon, 13 Jun 2022 11:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120695;
        bh=7VwtMFW1AMc4/lyAzgdPsDpmsJE+fVMKFqOIJTo4+zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLg+1KbiIfNgzYMvXqvGMbg/HRiveo8dybPJbF6P1qXZnHMCO89lYXdefmHaBrWxx
         SGzm3cGzNZqQ4wzPmeeLadikHlfrtzj8ez61x+7W3JyufCv5HW2soNp8onOonQfY/9
         rjFvHu+efkCgyqKZOaJtGWrQ9LtwBYMiuBvaMkmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 124/298] scsi: sd: Fix potential NULL pointer dereference
Date:   Mon, 13 Jun 2022 12:10:18 +0200
Message-Id: <20220613094928.703076298@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 05fbde3a77a4f1d62e4c4428f384288c1f1a0be5 ]

If sd_probe() sees an early error before sdkp->device is initialized,
sd_zbc_release_disk() is called. This causes a NULL pointer dereference
when sd_is_zoned() is called inside that function. Avoid this by removing
the call to sd_zbc_release_disk() in sd_probe() error path.

This change is safe and does not result in zone information memory leakage
because the zone information for a zoned disk is allocated only when
sd_revalidate_disk() is called, at which point sdkp->disk_dev is fully set,
resulting in sd_disk_release() being called when needed to cleanup a disk
zone information using sd_zbc_release_disk().

Link: https://lore.kernel.org/r/20220601062544.905141-2-damien.lemoal@opensource.wdc.com
Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8b5d2a4076c2..65b501859141 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3605,7 +3605,6 @@ static int sd_probe(struct device *dev)
  out_put:
 	put_disk(gd);
  out_free:
-	sd_zbc_release_disk(sdkp);
 	kfree(sdkp);
  out:
 	scsi_autopm_put_device(sdp);
-- 
2.35.1



