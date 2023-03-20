Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7906E6C165F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjCTPFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjCTPEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:04:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B498F40D9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04EC0B80EC3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70944C433EF;
        Mon, 20 Mar 2023 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324394;
        bh=utcI07NSYk/VChAJ9f8B0ug29705//maxDCts0fopGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvs3x/Uc5DkV+0hsv6T7szFJ8LUij6gr66RuiY5F7gkGKrVwkEiYaUviXGiQrNxH5
         CZq0030lO6BdP8Uv7bQgiXuTmMnbl1UL8M1nHOblTFpOYc0z5f02g0fuEagx5WaayV
         rkYZZ96fT77Qp1p2sU1rpUNYKXIrHMHER4zmRxf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/36] block: sunvdc: add check for mdesc_grab() returning NULL
Date:   Mon, 20 Mar 2023 15:54:38 +0100
Message-Id: <20230320145424.712171883@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 6030363199e3a6341afb467ddddbed56640cbf6a ]

In vdc_port_probe(), we should check the return value of mdesc_grab() as
it may return NULL, which can cause potential NPD bug.

Fixes: 43fdf27470b2 ("[SPARC64]: Abstract out mdesc accesses for better MD update handling.")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20230315062032.1741692-1-windhl@126.com
[axboe: style cleanup]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/sunvdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 6b7b0d8a2acbc..d2e9ffd2255f4 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -947,6 +947,8 @@ static int vdc_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	print_version();
 
 	hp = mdesc_grab();
+	if (!hp)
+		return -ENODEV;
 
 	err = -ENODEV;
 	if ((vdev->dev_no << PARTITION_SHIFT) & ~(u64)MINORMASK) {
-- 
2.39.2



