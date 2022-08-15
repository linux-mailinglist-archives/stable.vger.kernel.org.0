Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019D9594590
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiHOWTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348183AbiHOWQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:16:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9707A75C;
        Mon, 15 Aug 2022 12:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C845B611F6;
        Mon, 15 Aug 2022 19:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A74C433C1;
        Mon, 15 Aug 2022 19:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592394;
        bh=Lt3I10bBaab6peJvJL+7PA1gYSbRnSA2Jze6Kx9+sVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmPxvpXWHMww+jpn09hObe32/+sWaBSLvZ7thlNqmpfLropxZK6dISWyGD9dN7c+P
         tm7V0nHNnFsMtPUdpKkV34o1ugNkrAPn5ssNzNR4zWu6khO8n0/tfGl0rgUuHwg5gd
         KR2BtRu8YG7rPdLLpOmepxg9L5uTQ0iGt72UwHzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0780/1095] HID: amd_sfh: Add NULL check for hid device
Date:   Mon, 15 Aug 2022 20:02:59 +0200
Message-Id: <20220815180501.524385994@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 06aa2a43c307cf4096f422dcb575e5d2913e528f ]

On removal of hid device during SFH set report may cause NULL pointer
exception. Hence add NULL check for hid device before accessing.

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_hid.c b/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
index e2a9679e32be..54fe224050f9 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
@@ -100,11 +100,15 @@ static int amdtp_wait_for_response(struct hid_device *hid)
 
 void amdtp_hid_wakeup(struct hid_device *hid)
 {
-	struct amdtp_hid_data *hid_data = hid->driver_data;
-	struct amdtp_cl_data *cli_data = hid_data->cli_data;
+	struct amdtp_hid_data *hid_data;
+	struct amdtp_cl_data *cli_data;
 
-	cli_data->request_done[cli_data->cur_hid_dev] = true;
-	wake_up_interruptible(&hid_data->hid_wait);
+	if (hid) {
+		hid_data = hid->driver_data;
+		cli_data = hid_data->cli_data;
+		cli_data->request_done[cli_data->cur_hid_dev] = true;
+		wake_up_interruptible(&hid_data->hid_wait);
+	}
 }
 
 static struct hid_ll_driver amdtp_hid_ll_driver = {
-- 
2.35.1



