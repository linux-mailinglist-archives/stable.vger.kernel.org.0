Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D5657D5B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiL1Pmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiL1PmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7635B17066
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:42:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E23B6155E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211BDC433D2;
        Wed, 28 Dec 2022 15:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242135;
        bh=f3goJPiWeWuX3lm3VmiWceNuahHI+ShEQLqFCGH1UQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrP4jKbj4SFJ5WzZx2UfV7NWHwiaLAPXarQxn+uhoAXgYFOLK+/srRW80ywHbkUh8
         qNfDNI5rGNNhHtEHlHcGALu2i6rOxGLrdwZUiRkeGUQJSFEJ09p7PTrFzjVLh5JmOa
         o4x0bnW4xi3W/F34mE6ZtxNBmYoPFXxhA5VAcRBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joel Granados <j.granados@samsung.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0333/1146] nvme: return err on nvme_init_non_mdts_limits fail
Date:   Wed, 28 Dec 2022 15:31:12 +0100
Message-Id: <20221228144339.206920430@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Joel Granados <j.granados@samsung.com>

[ Upstream commit bcaf434b8f04e1ee82a8b1e1bce0de99fbff67fa ]

In nvme_init_non_mdts_limits function we were returning 0 when kzalloc
failed; it now returns -ENOMEM.

Fixes: 5befc7c26e5a ("nvme: implement non-mdts command limits")
Signed-off-by: Joel Granados <j.granados@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7e3893d06bab..a4ea0607bc98 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3049,7 +3049,7 @@ static int nvme_init_non_mdts_limits(struct nvme_ctrl *ctrl)
 
 	id = kzalloc(sizeof(*id), GFP_KERNEL);
 	if (!id)
-		return 0;
+		return -ENOMEM;
 
 	c.identify.opcode = nvme_admin_identify;
 	c.identify.cns = NVME_ID_CNS_CS_CTRL;
-- 
2.35.1



