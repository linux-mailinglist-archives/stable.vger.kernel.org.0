Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9576675B9
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbjALOYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236789AbjALOX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:23:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA8059D2D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:15:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DAB56202B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED1DC433EF;
        Thu, 12 Jan 2023 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532935;
        bh=xIDhPjzrdbsH1EIa8aW6wNiVlsnjOwprJl3w1/448BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyvAdkSlG3hiJQNW583T5Dx4S2ndFJt4wbSrs8nnyN3LZQeQ4tHoIwCN5m/JrP8/v
         0MmtXRZDUp4O8U8uM4mPjuWBiJrGX+XRn6AsUWjoCO62ZL+UmkUvuhIW/Sc8g/oC8x
         gArZOzr3JdEpxft4zEQFOlRCPMKVkXjlZ5RIo1/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 318/783] scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()
Date:   Thu, 12 Jan 2023 14:50:34 +0100
Message-Id: <20230112135539.069513584@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 48be84b4e95c..b2d4b6c78b5c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9801,10 +9801,12 @@ static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
 
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



