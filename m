Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E796C1751
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbjCTPMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbjCTPMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:12:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70A4977C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75785614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C85C433EF;
        Mon, 20 Mar 2023 15:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324837;
        bh=SpPh+I7xeHftGYBxdbXF0tOKYqDuo1eSbaNd/vs/C0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1Fr0lbY/kN1OZFAX/TcG3HyetajfC576j8Dx84vaWfZzwT7dx0OKwrfciA7rJPdm
         iQ/M64gxXz49lDkOkqVAfKzTUFIBDYgL+/g6rySQRDOtrn3lFM7mj4EqCEVxMDUl3P
         jrICy9uuY0e/fmLFJEJ6LXIIByDB6+weRNCRCcqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/115] nvmet: avoid potential UAF in nvmet_req_complete()
Date:   Mon, 20 Mar 2023 15:54:11 +0100
Message-Id: <20230320145451.098284126@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 6173a77b7e9d3e202bdb9897b23f2a8afe7bf286 ]

An nvme target ->queue_response() operation implementation may free the
request passed as argument. Such implementation potentially could result
in a use after free of the request pointer when percpu_ref_put() is
called in nvmet_req_complete().

Avoid such problem by using a local variable to save the sq pointer
before calling __nvmet_req_complete(), thus avoiding dereferencing the
req pointer after that function call.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index cfd0385511564..4c6d56dd29adc 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -756,8 +756,10 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 
 void nvmet_req_complete(struct nvmet_req *req, u16 status)
 {
+	struct nvmet_sq *sq = req->sq;
+
 	__nvmet_req_complete(req, status);
-	percpu_ref_put(&req->sq->ref);
+	percpu_ref_put(&sq->ref);
 }
 EXPORT_SYMBOL_GPL(nvmet_req_complete);
 
-- 
2.39.2



