Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3146666C790
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbjAPQcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbjAPQbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:31:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627912F798
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:19:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A02CB80E93
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A79C433D2;
        Mon, 16 Jan 2023 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885987;
        bh=Wkfrbj/x2gH5ER1wjzgzcLyEJ3eE1jfP9P3WCcgMWu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wI6KL1u1WzBx7gawFFW5N+yrZSFvXTfzjhl2yCiu+1WlXeQv7BPwHtH1Hylqo051
         SDzYI+fnZVQJSEy8LWRbhsurZdVNeZvRITA2fES55HNXHRGeG9zEXI31/3MIFosChe
         wQZwpShdzPxFfnXftFaO7cs7njyUVyJRElOpZWJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 260/658] scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()
Date:   Mon, 16 Jan 2023 16:45:48 +0100
Message-Id: <20230116154921.482656950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fda34a5d304d0b98cc967e8763b52221b66dc202 ]

If hpsa_sas_port_add_rphy() returns an error, the 'rphy' allocated in
sas_end_device_alloc() needs to be freed. Address this by calling
sas_rphy_free() in the error path.

Fixes: d04e62b9d63a ("hpsa: add in sas transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221111043012.1074466-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9d5d0c911130..ba125ed7e06a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9800,10 +9800,12 @@ static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
 
 	rc = hpsa_sas_port_add_rphy(hpsa_sas_port, rphy);
 	if (rc)
-		goto free_sas_port;
+		goto free_sas_rphy;
 
 	return 0;
 
+free_sas_rphy:
+	sas_rphy_free(rphy);
 free_sas_port:
 	hpsa_free_sas_port(hpsa_sas_port);
 	device->sas_port = NULL;
-- 
2.35.1



