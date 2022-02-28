Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BED4C7454
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbiB1RmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbiB1RkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:40:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43892986C7;
        Mon, 28 Feb 2022 09:34:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D704FB815A6;
        Mon, 28 Feb 2022 17:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F08C340E7;
        Mon, 28 Feb 2022 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069671;
        bh=/TC6U4bhgC1qLOu19zfPJeKQe7FGvbvv3H7xnnBIuCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uErlsgpPhFHGJScBWxdya2ARdDl9/o2V11y51UkZs7g/FPbxx7NBKnkGzQyh8IMrG
         QXcvQK768fAWoqDIYfP+6OyGV++KHFxkqC0MSgbeIILDw3F5ca6I6Zq7CLxZMYgUQx
         chpPYHjHGLmI5XpnkGQfN1wF+MVsxVFRPUTXC0TA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/80] RDMA/rtrs-clt: Move free_permit from free_clt to rtrs_clt_close
Date:   Mon, 28 Feb 2022 18:24:30 +0100
Message-Id: <20220228172317.581029281@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit c46fa8911b17e3f808679061a8af8bee219f4602 ]

Error path of rtrs_clt_open() calls free_clt(), where free_permit is
called.  This is wrong since error path of rtrs_clt_open() does not need
to call free_permit().

Also, moving free_permits() call to rtrs_clt_close(), makes it more
aligned with the call to alloc_permit() in rtrs_clt_open().

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20220217030929.323849-2-haris.iqbal@ionos.com
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 5a3c11b0b3102..13634eda833de 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2638,7 +2638,6 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 
 static void free_clt(struct rtrs_clt *clt)
 {
-	free_permits(clt);
 	free_percpu(clt->pcpu_path);
 
 	/*
@@ -2759,6 +2758,7 @@ void rtrs_clt_close(struct rtrs_clt *clt)
 		rtrs_clt_destroy_sess_files(sess, NULL);
 		kobject_put(&sess->kobj);
 	}
+	free_permits(clt);
 	free_clt(clt);
 }
 EXPORT_SYMBOL(rtrs_clt_close);
-- 
2.34.1



