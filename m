Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3944FD9A3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377274AbiDLHte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358424AbiDLHlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7B14B41C;
        Tue, 12 Apr 2022 00:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E9176153F;
        Tue, 12 Apr 2022 07:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B05C385A1;
        Tue, 12 Apr 2022 07:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747880;
        bh=n5yPUWkMd95tE3x0rxoJM9innYGchDcsor/IkUmA+mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrKBVr6nnSDMcl+bCMnvmpE9dxuribOg9sd+D7+RojZjcO4ULYo2Xzj/sSv1qtSnY
         8zV8ZuIZGm447D41/s2AbsNkrL/8I8PKl2dsTlhoqGRfq0T8IdBptPGbaJ3sOXWmsK
         89AcW1XBBG8TkJSaJyC1ffYD2XkprscaEIVAepJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 199/343] scsi: core: scsi_logging: Fix a BUG
Date:   Tue, 12 Apr 2022 08:30:17 +0200
Message-Id: <20220412062957.099091906@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit f06aa52cb2723ec67e92df463827b800d6c477d1 ]

The request_queue may be NULL in a request, for example when it comes from
scsi_ioctl_reset(). Check it before use.

Fixes: f3fa33acca9f ("block: remove the ->rq_disk field in struct request")
Link: https://lore.kernel.org/r/20220324134603.28463-1-thenzl@redhat.com
Reported-by: Changhui Zhong <czhong@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_logging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 1f8f80b2dbfc..a9f8de5e9639 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -30,7 +30,7 @@ static inline const char *scmd_name(const struct scsi_cmnd *scmd)
 {
 	struct request *rq = scsi_cmd_to_rq((struct scsi_cmnd *)scmd);
 
-	if (!rq->q->disk)
+	if (!rq->q || !rq->q->disk)
 		return NULL;
 	return rq->q->disk->disk_name;
 }
-- 
2.35.1



