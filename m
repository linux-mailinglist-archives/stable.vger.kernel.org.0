Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE996E6339
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjDRMiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjDRMix (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:38:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BAE13F82
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 489A7632D1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C69C433D2;
        Tue, 18 Apr 2023 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821525;
        bh=rNmDmM17I+T8T9DYe1vI0go47BpmCFMGB33NYpnoeyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYv/z7GM2Qz3biZSnkR6A7aKfoTOUo/KI4JGk7g4Cgvtpawf2dWFFg8rJMjFjOquH
         itF2VnAE3kvP9XipG0/nYG7zeksvR7/QR3V4dRK0xmg8+ZUQsHbkYPWfcB1RqnjkhW
         yFy6PHDDeVWw2qtXXfqoZjr7+OuFNQArArJNEsGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/91] RDMA/core: Fix GID entry ref leak when create_ah fails
Date:   Tue, 18 Apr 2023 14:21:37 +0200
Message-Id: <20230418120306.732123619@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
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

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit aca3b0fa3d04b40c96934d86cc224cccfa7ea8e0 ]

If AH create request fails, release sgid_attr to avoid GID entry
referrence leak reported while releasing GID table

Fixes: 1a1f460ff151 ("RDMA: Hold the sgid_attr inside the struct ib_ah/qp")
Link: https://lore.kernel.org/r/20230401063424.342204-1-saravanan.vajravel@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f0c07e4ba4388..cae013130eb1d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -540,6 +540,8 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 	else
 		ret = device->ops.create_ah(ah, &init_attr, NULL);
 	if (ret) {
+		if (ah->sgid_attr)
+			rdma_put_gid_attr(ah->sgid_attr);
 		kfree(ah);
 		return ERR_PTR(ret);
 	}
-- 
2.39.2



