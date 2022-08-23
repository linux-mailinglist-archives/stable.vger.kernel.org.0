Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB9C59D86B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351069AbiHWJeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350747AbiHWJcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:32:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096CC94100;
        Tue, 23 Aug 2022 01:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7851614E7;
        Tue, 23 Aug 2022 08:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3458C433C1;
        Tue, 23 Aug 2022 08:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243939;
        bh=jc8IbrhXt3pWx3O2jMG/Q2BCERjfFZ+f+AaSbKN/cBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFKlkNlY7Qe4QmFGU/vt8DIHg9YwyE61MElOAJYhq9W8QdnlkuFH7Srypw7m5j2Ue
         tFbowQ+qDcx/6YCYRhsu+tXciG7nfbWxgj1NdZ/LypSpt+I2yUk5mVbS5Lic/8GW7Z
         dMRkeBS52x8WC3ZlckzVZdwlNrsgkJVB/iMBoJcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/229] dm: return early from dm_pr_call() if DM device is suspended
Date:   Tue, 23 Aug 2022 10:23:40 +0200
Message-Id: <20220823080055.836359364@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit e120a5f1e78fab6223544e425015f393d90d6f0d ]

Otherwise PR ops may be issued while the broader DM device is being
reconfigured, etc.

Fixes: 9c72bad1f31a ("dm: call PR reserve/unreserve on each underlying device")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 94018613b43b..9e6689fd2273 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2859,6 +2859,11 @@ static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
 		goto out;
 	ti = dm_table_get_target(table, 0);
 
+	if (dm_suspended_md(md)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	ret = -EINVAL;
 	if (!ti->type->iterate_devices)
 		goto out;
-- 
2.35.1



