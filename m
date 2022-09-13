Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6939B5B7237
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiIMOtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiIMOsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:48:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6063566A6C;
        Tue, 13 Sep 2022 07:25:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D653BB80F88;
        Tue, 13 Sep 2022 14:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5A3C433D6;
        Tue, 13 Sep 2022 14:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078630;
        bh=K1zKnhaS0xWYZkglRZlSKoFxP/z5W33rxEsdOrt6MQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVTjGLjpjFZb2x6SIplqbxsNbZKf4aYIkntdE+YR+IuK3temOUaVk+FT2bNSgnKzD
         UmYle7pyEYRhBNRit22x9/D6Xkr1MknUrx38l2idPucgksCT11XTMqCwWBRM2FXRIy
         5ijEaKw7JX0vMUnbB1K84uUrdn4aeWqFNApsosyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sloan <david.sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/121] md: Flush workqueue md_rdev_misc_wq in md_alloc()
Date:   Tue, 13 Sep 2022 16:03:34 +0200
Message-Id: <20220913140358.341556082@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: David Sloan <david.sloan@eideticom.com>

[ Upstream commit 5e8daf906f890560df430d30617c692a794acb73 ]

A race condition still exists when removing and re-creating md devices
in test cases. However, it is only seen on some setups.

The race condition was tracked down to a reference still being held
to the kobject by the rdev in the md_rdev_misc_wq which will be released
in rdev_delayed_delete().

md_alloc() waits for previous deletions by waiting on the md_misc_wq,
but the md_rdev_misc_wq may still be holding a reference to a recently
removed device.

To fix this, also flush the md_rdev_misc_wq in md_alloc().

Signed-off-by: David Sloan <david.sloan@eideticom.com>
[logang@deltatee.com: rewrote commit message]
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c8f2e8524bfb7..04e1e294b4b1e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5651,6 +5651,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * removed (mddev_delayed_delete).
 	 */
 	flush_workqueue(md_misc_wq);
+	flush_workqueue(md_rdev_misc_wq);
 
 	mutex_lock(&disks_mutex);
 	mddev = mddev_alloc(dev);
-- 
2.35.1



