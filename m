Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B064FD688
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354385AbiDLHin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353533AbiDLHZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC23D42EFF;
        Tue, 12 Apr 2022 00:01:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 592BA615B4;
        Tue, 12 Apr 2022 07:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66825C385A1;
        Tue, 12 Apr 2022 07:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746865;
        bh=hUN9yw1tKUHXlZHF50cIZfu/c6O6GRL/XpekaWNpOQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oemTtePxwN2ddsEUQ3q4/cZW/GP7ZcCRkcYdoBJsZt2O4YYyYz34DM1DIhfYTVTwK
         O+Xytdw6DB8GlHZJe/G5uvNBHJyiL/iq2+FSzZxowIjokZ8M9P/Mseq/GYoNJ62OvW
         U6qt5Z/OPRQ0xasRBoc3EDSGXufZ2OzeyOnRnwJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kevin Groeneveld <kgroeneveld@lenbrook.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 156/285] scsi: sr: Fix typo in CDROM(CLOSETRAY|EJECT) handling
Date:   Tue, 12 Apr 2022 08:30:13 +0200
Message-Id: <20220412062948.173744187@linuxfoundation.org>
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

From: Kevin Groeneveld <kgroeneveld@lenbrook.com>

[ Upstream commit bc5519c18a32ce855bb51b9f5eceb77a9489d080 ]

Commit 2e27f576abc6 ("scsi: scsi_ioctl: Call scsi_cmd_ioctl() from
scsi_ioctl()") seems to have a typo as it is checking ret instead of cmd in
the if statement checking for CDROMCLOSETRAY and CDROMEJECT.  This changes
the behaviour of these ioctls as the cdrom_ioctl handling of these is more
restrictive than the scsi_ioctl version.

Link: https://lore.kernel.org/r/20220323002242.21157-1-kgroeneveld@lenbrook.com
Fixes: 2e27f576abc6 ("scsi: scsi_ioctl: Call scsi_cmd_ioctl() from scsi_ioctl()")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kevin Groeneveld <kgroeneveld@lenbrook.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index f5a2eed54345..9f683fed8f2c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -579,7 +579,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 	scsi_autopm_get_device(sdev);
 
-	if (ret != CDROMCLOSETRAY && ret != CDROMEJECT) {
+	if (cmd != CDROMCLOSETRAY && cmd != CDROMEJECT) {
 		ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
 		if (ret != -ENOSYS)
 			goto put;
-- 
2.35.1



