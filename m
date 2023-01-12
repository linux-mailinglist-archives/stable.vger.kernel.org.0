Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA7667629
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbjALO3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbjALO2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:28:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B502E4FD7F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:19:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54A6F60A69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47285C433EF;
        Thu, 12 Jan 2023 14:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533191;
        bh=iTNFMNNwZZhGXBQzlLPWpwR3MRVJdJY4XBWn7m6QOBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuPEyOMOS/+xlb0SD8FckR839HkvO+490w2dBakT+ZgM6s/dFe5rwnrLCY+nI9iga
         FJtZzSQpdU92cM2p+15qRzG8VDQwee5X6zTOg01lg4B7B8nB1XAz7utkYbmjgjBxvA
         kDcf7mFKPUiWzi+630A+DyT4HUZgc6hxAc5hkHEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 398/783] fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()
Date:   Thu, 12 Jan 2023 14:51:54 +0100
Message-Id: <20230112135542.760868708@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a94371040712031ba129c7e9d8ff04a06a2f8207 ]

If an error occurs after a successful uvesafb_init_mtrr() call, it must be
undone by a corresponding arch_phys_wc_del() call, as already done in the
remove function.

This has been added in the remove function in commit 63e28a7a5ffc
("uvesafb: Clean up MTRR code")

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/uvesafb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index def14ac0ebe1..661f12742e4f 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1756,6 +1756,7 @@ static int uvesafb_probe(struct platform_device *dev)
 out_unmap:
 	iounmap(info->screen_base);
 out_mem:
+	arch_phys_wc_del(par->mtrr_handle);
 	release_mem_region(info->fix.smem_start, info->fix.smem_len);
 out_reg:
 	release_region(0x3c0, 32);
-- 
2.35.1



