Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACBD69CE99
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbjBTOAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbjBTOAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F18F93C6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C45C760EB0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E20C433EF;
        Mon, 20 Feb 2023 13:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901572;
        bh=MpCiOHqhya3aRizMfpaodbu0HD3zzhJeJesP8MeQfOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ile9k+Q81P76ZZ+sP1b20A/LF76EBJbmc2UXyKKOk5yre/S9GmBUd3VItOq3EeOFB
         1+V53RDxcssGdtt00XE6VDHbZxIHynHeiGb1MhffC+gcCfsmLoSnnXa0ep2/QPSoNz
         hHL7lyL7u4NOMNLKU7jvEYLKAEVNyLLfwy+vdtDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amit Engel <Amit.Engel@dell.com>,
        James Smart <jsmart2021@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/118] nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association
Date:   Mon, 20 Feb 2023 14:35:46 +0100
Message-Id: <20230220133601.638793387@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Amit Engel <Amit.Engel@dell.com>

[ Upstream commit 0cab4404874f2de52617de8400c844891c6ea1ce ]

As part of nvmet_fc_ls_create_association there is a case where
nvmet_fc_alloc_target_queue fails right after a new association with an
admin queue is created. In this case, no one releases the get taken in
nvmet_fc_alloc_target_assoc.  This fix is adding the missing put.

Signed-off-by: Amit Engel <Amit.Engel@dell.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index ab2627e17bb97..1ab6601fdd5cf 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1685,8 +1685,10 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
 		else {
 			queue = nvmet_fc_alloc_target_queue(iod->assoc, 0,
 					be16_to_cpu(rqst->assoc_cmd.sqsize));
-			if (!queue)
+			if (!queue) {
 				ret = VERR_QUEUE_ALLOC_FAIL;
+				nvmet_fc_tgt_a_put(iod->assoc);
+			}
 		}
 	}
 
-- 
2.39.0



