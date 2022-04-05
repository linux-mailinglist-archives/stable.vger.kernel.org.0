Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADE84F3271
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241755AbiDEIfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239372AbiDEIUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA142BF94F;
        Tue,  5 Apr 2022 01:12:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64B80B81B92;
        Tue,  5 Apr 2022 08:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39EEC385A0;
        Tue,  5 Apr 2022 08:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146322;
        bh=PrqKqxk9HKNIKj9f4o0ZvQLx3bU8TWNvQjua6K6EI6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=syx3L7MQmgXe22tByjCslSAl8J2XblEpXXszphXGdHRlrEUKYZ6zrJoh452ggWNcm
         v1JVztsaNiaVYKrkmsrjWlnSeIXISgoFhXAAfRTd5poIgouGSpehKEUeXnJSB/UC1H
         A1yoLKgMzEePUXIvENzrTyvTLKZqL6+aKatIbjcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Binuraj Ravindran <binuraj.ravindran@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0723/1126] dmaengine: idxd: restore traffic class defaults after wq reset
Date:   Tue,  5 Apr 2022 09:24:30 +0200
Message-Id: <20220405070428.813673030@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 573ad8b86804..3061fe857d69 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -681,8 +681,13 @@ static void idxd_groups_clear_state(struct idxd_device *idxd)
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



