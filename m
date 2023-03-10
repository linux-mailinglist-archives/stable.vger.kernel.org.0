Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A836B41CD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjCJN4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjCJN4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:56:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E894D112DE7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF7A96187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79D2C433EF;
        Fri, 10 Mar 2023 13:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456590;
        bh=nptuSFR5rvt714xXu1z8V49GSSGOAgPCPPKXYPnBRck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxAwCwOpGq/hDyZPdv/4idM2LQWu2F8pBx0B2DKiA2Orv6lgp0c06l5crs73azQ+F
         ekyuN3vBMA5w5RpFXxZ2z4h5EyWY4CiO/PxHBzslxs5qfEGVt+FAY7RLQ2SF9An2ky
         t46gdLu226ViVyKVajB7zFJ1/yGPTWtFW4oPWLfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Berg <benjamin.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 056/211] um: virtio_uml: mark device as unregistered when breaking it
Date:   Fri, 10 Mar 2023 14:37:16 +0100
Message-Id: <20230310133720.429770786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 8e9cd85139a2149d5a7c121b05e0cdb8287311f9 ]

Mark the device as not registered anymore when scheduling the work to
remove it. Otherwise we could end up scheduling the work multiple times
in a row, including scheduling it while it is already running.

Fixes: af9fb41ed315 ("um: virtio_uml: Fix broken device handling in time-travel")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 588930a0ced17..dcfd0ca534eef 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -168,6 +168,8 @@ static void vhost_user_check_reset(struct virtio_uml_device *vu_dev,
 	if (!vu_dev->registered)
 		return;
 
+	vu_dev->registered = 0;
+
 	virtio_break_device(&vu_dev->vdev);
 	schedule_work(&pdata->conn_broken_wk);
 }
-- 
2.39.2



