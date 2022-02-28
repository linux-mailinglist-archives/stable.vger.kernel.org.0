Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D724C7583
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbiB1RzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240286AbiB1RyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90751986F3;
        Mon, 28 Feb 2022 09:41:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F14F6153C;
        Mon, 28 Feb 2022 17:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE8EC340E7;
        Mon, 28 Feb 2022 17:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070110;
        bh=XF1c6l+ZV+WORH4b/vACdr35+2Do/8pE/ilyF5icJuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqZ4YwfmtkbaZ4f7xNtKJxBgn3CE1sZbKgoySFy6CMt9VDyYjJJAQaQgoqtVwjeVt
         oQdHx8NxICu9OiKdQt5BimzNoXFeCkJ7pFQoCSrQRnAK2z4DW5R/qjmSERmbbEusQt
         vxrURP2WMDkZQxv6Gq7ydbMsmU1VDt3ESwQpMh2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/139] RDMA/rtrs-clt: Move free_permit from free_clt to rtrs_clt_close
Date:   Mon, 28 Feb 2022 18:24:24 +0100
Message-Id: <20220228172357.092149071@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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
index 3272514f05405..a23438bacf12c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2753,7 +2753,6 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 
 static void free_clt(struct rtrs_clt *clt)
 {
-	free_permits(clt);
 	free_percpu(clt->pcpu_path);
 
 	/*
@@ -2869,6 +2868,7 @@ void rtrs_clt_close(struct rtrs_clt *clt)
 		rtrs_clt_destroy_sess_files(sess, NULL);
 		kobject_put(&sess->kobj);
 	}
+	free_permits(clt);
 	free_clt(clt);
 }
 EXPORT_SYMBOL(rtrs_clt_close);
-- 
2.34.1



