Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB294F2DB4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348912AbiDEJy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343884AbiDEJOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:14:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E05517CC;
        Tue,  5 Apr 2022 02:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB3EB81A12;
        Tue,  5 Apr 2022 09:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C699C385A3;
        Tue,  5 Apr 2022 09:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149269;
        bh=dExiS92v/qYjImBWgWfdlXG7IooxBl9iDHDz+9FvNU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbclaV6JbuJgVaeDXI5943iRwIcB37ZN4IXv2bMyz4UnFrh5xlJs+jh36ljVsvJ1u
         aAga++WPfaIPAg7ON8BC1vjVFuZyW/xm8S+h2NPnUjGyryvdjDBd8yF6dfXtBc5Z+z
         AkGQ96hvKByAnbIBYCixF/YzHgExV2QMb0rypa+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Binuraj Ravindran <binuraj.ravindran@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0655/1017] dmaengine: idxd: restore traffic class defaults after wq reset
Date:   Tue,  5 Apr 2022 09:26:08 +0200
Message-Id: <20220405070413.726260105@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit ea7c8f598c323f6ebaf9ddae01fb2a981fe8c56a ]

When clearing the group configurations, the driver fails to restore the
default setting for DSA 1.x based devices. Add defaults in
idxd_groups_clear_state() for traffic class configuration.

Fixes: ade8a86b512c ("dmaengine: idxd: Set defaults for GRPCFG traffic class")
Reported-by: Binuraj Ravindran <binuraj.ravindran@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/164304123369.824298.6952463420266592087.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 83aa0c79f830..4bafc88f425f 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -691,8 +691,13 @@ static void idxd_groups_clear_state(struct idxd_device *idxd)
 		group->use_rdbuf_limit = false;
 		group->rdbufs_allowed = 0;
 		group->rdbufs_reserved = 0;
-		group->tc_a = -1;
-		group->tc_b = -1;
+		if (idxd->hw.version < DEVICE_VERSION_2 && !tc_override) {
+			group->tc_a = 1;
+			group->tc_b = 1;
+		} else {
+			group->tc_a = -1;
+			group->tc_b = -1;
+		}
 	}
 }
 
-- 
2.34.1



