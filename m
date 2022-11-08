Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC464621579
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiKHOMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbiKHOMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E47862F0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:12:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B28E9615D1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B089DC433C1;
        Tue,  8 Nov 2022 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916722;
        bh=Nc8kSPEkGq8kW3xsazcd9kReF6iwp1rS0iJ+zghNEYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o++XI9uJ9+xc+ACLfawFkBn2/jNGj5tlQ+8hYFb4fJxk7ToO9GiOR8nXCn3vL3ZkB
         LKc4LUMIbkRgC9qV74aaGtc3n1i11+qCS/TMLx91zgWbAvpAUcc6GFU3zxmuZ/ypHk
         Ch5Z2Ua0SI6qkJMj9kdSAEY8RdCRh2Eq4dpObbZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Lei <ming.lei@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 112/197] ublk_drv: return flag of UBLK_F_URING_CMD_COMP_IN_TASK in case of module
Date:   Tue,  8 Nov 2022 14:39:10 +0100
Message-Id: <20221108133400.044968772@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 224e858f215a3d6304f95a92357a1753475ca9cf ]

UBLK_F_URING_CMD_COMP_IN_TASK needs to be set and returned to userspace
if ublk driver is built as module, otherwise userspace may get wrong
flags shown.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221029010432.598367-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 6a4a94b4cdf4..31a8715d3a4d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1507,6 +1507,9 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	 */
 	ub->dev_info.flags &= UBLK_F_ALL;
 
+	if (!IS_BUILTIN(CONFIG_BLK_DEV_UBLK))
+		ub->dev_info.flags |= UBLK_F_URING_CMD_COMP_IN_TASK;
+
 	/* We are not ready to support zero copy */
 	ub->dev_info.flags &= ~UBLK_F_SUPPORT_ZERO_COPY;
 
-- 
2.35.1



