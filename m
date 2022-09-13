Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347765B6F40
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiIMOKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiIMOJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831F257547;
        Tue, 13 Sep 2022 07:09:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB922614A1;
        Tue, 13 Sep 2022 14:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C470BC433D6;
        Tue, 13 Sep 2022 14:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078140;
        bh=gwP3S6ajr8CxYz3Aciix+GgU1iK/lY9JbhNwdsK/vas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBZxfRII7PALLbwu+cXtwaASYG/V9U0Wab3vi/QxD4g3kYmU065YMCdBFjWac066C
         uMc3aVNr3qdgvrn3tnMbP2GlDuFMUiPI8dEqNZjr2T0gi71RtQBk1+wST6LACUclpx
         VuuuPVJG7aLETWMoG7679wijXK0tEtD/MKC0keIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sloan <david.sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 028/192] md: Flush workqueue md_rdev_misc_wq in md_alloc()
Date:   Tue, 13 Sep 2022 16:02:14 +0200
Message-Id: <20220913140411.314952410@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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
index 91e7e80fce489..25d18b67a1620 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5647,6 +5647,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * removed (mddev_delayed_delete).
 	 */
 	flush_workqueue(md_misc_wq);
+	flush_workqueue(md_rdev_misc_wq);
 
 	mutex_lock(&disks_mutex);
 	mddev = mddev_alloc(dev);
-- 
2.35.1



