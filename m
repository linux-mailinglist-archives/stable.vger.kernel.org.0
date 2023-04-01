Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9CE6D2CDA
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbjDABno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbjDABnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:43:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7562661B2;
        Fri, 31 Mar 2023 18:42:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD6F862CF4;
        Sat,  1 Apr 2023 01:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC49C4339C;
        Sat,  1 Apr 2023 01:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313318;
        bh=xJod11SsprX4EwkdikpQC51szxq+xH/GFQps0769JuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8xULYOWaQYJUZ+lV11B1P57CZFRaJtS2g63xIUFd69ogdHqt0wMZyOeBemktDIXM
         cbNk/w+iBfyUD9lFJrM5jgBccsSPwQwi0yReavbEVgtOtiroI4mvfi340RlFvU8S/y
         pe1U3xCr8fpSaD9F48Ww8xAStSMu3PPKNG4mfwZ/8Hxn6o3brLxMEvAiqBnXoRAQ+F
         +66SQpZHMsaWlYXcCk2xkiUlqCf5YHV7WRCZnz5o02P62cA0nTJWrSeJ/4i/FBZIlf
         qT5fB9D0vIzLZKbUcnw/6tSTGlhAxkks0xSHLDNbobFI0RDqlUQ5AbFQL5QB8fcs33
         mIcbtKKCnTbew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin George <martinus.gpy@gmail.com>,
        Martin George <marting@netapp.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.2 19/25] nvme: send Identify with CNS 06h only to I/O controllers
Date:   Fri, 31 Mar 2023 21:41:17 -0400
Message-Id: <20230401014126.3356410-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin George <martinus.gpy@gmail.com>

[ Upstream commit def84ab600b71ea3fcc422a876d5d0d0daa7d4f3 ]

Identify CNS 06h (I/O Command Set Specific Identify Controller data
structure) is supported only on i/o controllers.

But nvme_init_non_mdts_limits() currently invokes this on all
controllers.  Correct this by ensuring this is sent to I/O
controllers only.

Signed-off-by: Martin George <marting@netapp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 70b5e891f6b3b..a8ad9c9fd2323 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3106,7 +3106,8 @@ static int nvme_init_non_mdts_limits(struct nvme_ctrl *ctrl)
 	else
 		ctrl->max_zeroes_sectors = 0;
 
-	if (nvme_ctrl_limited_cns(ctrl))
+	if (ctrl->subsys->subtype != NVME_NQN_NVME ||
+	    nvme_ctrl_limited_cns(ctrl))
 		return 0;
 
 	id = kzalloc(sizeof(*id), GFP_KERNEL);
-- 
2.39.2

