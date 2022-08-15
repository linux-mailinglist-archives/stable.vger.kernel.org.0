Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D14593962
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244109AbiHOTVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344350AbiHOTVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:21:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E6857241;
        Mon, 15 Aug 2022 11:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ACCE6117E;
        Mon, 15 Aug 2022 18:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A35C433D6;
        Mon, 15 Aug 2022 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588807;
        bh=MqgJVKreUtjvSuyszG3RqV1no/q+gQLMEaab0NnhavA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONp/c1Tc83ovhMCKEJTx6bn3nwdcBNXh+HTK6SgFdMsO07SDpDVY480kkGVjLwPcv
         1oesb29wG7NtSiZBgHLnkKQ0spSiR/0ZMp6AQhTx8zCYbyzgZT2V7uyGsRMwMLTKid
         TQZpCq6MfTB4xZZAyDnfswPQeCawudAzXezpwars=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 519/779] HID: amd_sfh: Add NULL check for hid device
Date:   Mon, 15 Aug 2022 20:02:43 +0200
Message-Id: <20220815180359.436246090@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index a4bda2ac713e..3b0615c6aecf 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_hid.c
@@ -98,11 +98,15 @@ static int amdtp_wait_for_response(struct hid_device *hid)
 
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



