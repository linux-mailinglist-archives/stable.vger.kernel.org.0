Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112C46E64CA
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjDRMwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbjDRMw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:52:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E0416F80
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:52:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3266663430
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A517C433D2;
        Tue, 18 Apr 2023 12:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822288;
        bh=BtN74MdN6UuwAWMoiJU7MEVhLAAI6OppMhi7cFsH2T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALC+zhSQCBZXOX8vRwCtvQlM40l5EWSC0qjjoWVuXCi+/hVRCr1hwsJPQYk4jJEYS
         KP1BXCWDKf/FrYoSZ4tCSnOnTGF5h+SsoMSdLCAq0qb2kvBH7gr2Pj7oq8G8rTy4r+
         FnE8ePMEiDQgx9rd0DOx+PTkwXzKjF8v7XvHtEuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin George <marting@netapp.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 093/139] nvme: send Identify with CNS 06h only to I/O controllers
Date:   Tue, 18 Apr 2023 14:22:38 +0200
Message-Id: <20230418120317.288326231@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index ee1b075d12cfc..c0429f9f50920 100644
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



