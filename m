Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C276CC2D1
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbjC1OtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbjC1Osn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDB7E05C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AFAB61820
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168BBC4339B;
        Tue, 28 Mar 2023 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014900;
        bh=sl8fodqyPyil+UwMfvdzP6rQuO0LdTnkkPudQJLTjyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDu+o22G26UoTKPEzQSvYnhWEne5InR4r6EKhu4Ok5IZwbn1sLUKt+gQZGoHrMELh
         /X9X3x2+ZtJZxHgoHwH9TSibxEFpsT+nAH9SElJbZL6/GBNGHk0RqHgFU3+IYiBpV8
         OjA/WFDxBarq6zaKo3HgN0huE5Dp0Y1im8dRdMyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Gix <brian.gix@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 093/240] Bluetooth: Remove "Power-on" check from Mesh feature
Date:   Tue, 28 Mar 2023 16:40:56 +0200
Message-Id: <20230328142623.646321969@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,TVD_SUBJ_WIPE_DEBT autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Gix <brian.gix@gmail.com>

[ Upstream commit 52dd5e964a55c98c1b0bcf5fc737a5ddd00e7d4d ]

The Bluetooth mesh experimental feature enable was requiring the
controller to be powered off in order for the Enable to work. Mesh is
supposed to be enablable regardless of the controller state, and created
an unintended requirement that the mesh daemon be started before the
classic bluetoothd daemon.

Fixes: af6bcc1921ff ("Bluetooth: Add experimental wrapper for MGMT based mesh")
Signed-off-by: Brian Gix <brian.gix@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index d2ea8e19aa1b5..71b65ac6343a0 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4627,12 +4627,6 @@ static int set_mgmt_mesh_func(struct sock *sk, struct hci_dev *hdev,
 				       MGMT_OP_SET_EXP_FEATURE,
 				       MGMT_STATUS_INVALID_INDEX);
 
-	/* Changes can only be made when controller is powered down */
-	if (hdev_is_powered(hdev))
-		return mgmt_cmd_status(sk, hdev->id,
-				       MGMT_OP_SET_EXP_FEATURE,
-				       MGMT_STATUS_REJECTED);
-
 	/* Parameters are limited to a single octet */
 	if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
 		return mgmt_cmd_status(sk, hdev->id,
-- 
2.39.2



