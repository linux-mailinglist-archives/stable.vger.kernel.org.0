Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C26E51A8E3
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356462AbiEDRNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356857AbiEDRJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE8941631;
        Wed,  4 May 2022 09:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E759B8278E;
        Wed,  4 May 2022 16:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE57C385A5;
        Wed,  4 May 2022 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683362;
        bh=MHJqpfJfKuElTaqjHbxfjwwRYPPXj/+pu17OoUxRRzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wITdWzYeUpzDvV89fx/MfNj9aW3Xt3kyxV5Yp+QUHbqYLWIBDG/WqpfPJPVqKD9j
         j+Lge1dLMzds+y0hWbrZBJIVbWTvS4GMz3RQ3J4W4iTSHUVbxxosIWFSA7ZUzsjZya
         HtDPPRWw2d69QI3lvbm7X4NeDOj/Zm5dcHJhhnw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.17 049/225] bus: fsl-mc-msi: Fix MSI descriptor mutex lock for msi_first_desc()
Date:   Wed,  4 May 2022 18:44:47 +0200
Message-Id: <20220504153114.491213159@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit c7d2f89fea26c84d5accc55d9976dd7e5305e63a upstream.

Commit e8604b1447b4 introduced a call to the helper function
msi_first_desc(), which needs MSI descriptor mutex lock before
call. However, the required mutex lock was not added. This results in
lockdep assertion:

 WARNING: CPU: 4 PID: 119 at kernel/irq/msi.c:274 msi_first_desc+0xd0/0x10c
  msi_first_desc+0xd0/0x10c
  fsl_mc_msi_domain_alloc_irqs+0x7c/0xc0
  fsl_mc_populate_irq_pool+0x80/0x3cc

Fix this by adding the mutex lock and unlock around the function call.

Fixes: e8604b1447b4 ("bus: fsl-mc-msi: Simplify MSI descriptor handling")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220412075636.755454-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-msi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-msi.c b/drivers/bus/fsl-mc/fsl-mc-msi.c
index 5e0e4393ce4d..0cfe859a4ac4 100644
--- a/drivers/bus/fsl-mc/fsl-mc-msi.c
+++ b/drivers/bus/fsl-mc/fsl-mc-msi.c
@@ -224,8 +224,12 @@ int fsl_mc_msi_domain_alloc_irqs(struct device *dev,  unsigned int irq_count)
 	if (error)
 		return error;
 
+	msi_lock_descs(dev);
 	if (msi_first_desc(dev, MSI_DESC_ALL))
-		return -EINVAL;
+		error = -EINVAL;
+	msi_unlock_descs(dev);
+	if (error)
+		return error;
 
 	/*
 	 * NOTE: Calling this function will trigger the invocation of the
-- 
2.36.0



