Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453ED5493E7
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377858AbiFMNg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377677AbiFMNe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:34:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8697D73572;
        Mon, 13 Jun 2022 04:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA95261036;
        Mon, 13 Jun 2022 11:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFD7C3411C;
        Mon, 13 Jun 2022 11:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119631;
        bh=71fgyx31FlJXB3KBqqZRjsjypAgRiOnHSNsD/a22XSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijkLp3HW7xlyph3Idha2qsYC7B7WCpJnnFOGCJcQjYD5D2dRkcxqlATSRzokbJGPn
         U1gu7GoPsH6Vq0xgtUOf8l3QXq47zyrjAjod3o/5DniwD9SZDGF5fGk6nOPhkf80ry
         RafGfjDzz2KkBWu/4EIYQiAwRFkx0Ih2rFogyZig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 083/339] scsi: sd: Dont call blk_cleanup_disk() in sd_probe()
Date:   Mon, 13 Jun 2022 12:08:28 +0200
Message-Id: <20220613094929.035356697@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7274ce0558adb4b9b1f5c5b613fb4fe331c18911 ]

In SCSI the midlayer has ownership of the request_queue, so on probe
failure we must only put the gendisk, but leave the request_queue alone.

Link: https://lore.kernel.org/r/20220523083813.227935-1-hch@lst.de
Fixes: 03252259e18e ("scsi: sd: Clean up gendisk if device_add_disk() failed")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dc6e55761fd1..5539d75dcfe7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3475,7 +3475,7 @@ static int sd_probe(struct device *dev)
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
 		put_device(&sdkp->disk_dev);
-		blk_cleanup_disk(gd);
+		put_disk(gd);
 		goto out;
 	}
 
-- 
2.35.1



