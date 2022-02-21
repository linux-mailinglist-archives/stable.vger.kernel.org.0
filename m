Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FBE4BE1AA
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350926AbiBUJls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:41:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350932AbiBUJkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:40:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9853C72B;
        Mon, 21 Feb 2022 01:17:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2D1DDCE0E80;
        Mon, 21 Feb 2022 09:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17864C340E9;
        Mon, 21 Feb 2022 09:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435035;
        bh=Sb1/oLxtF230QlfTreXW7Wx98AaF9vDhD7/AD7g450I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpFcnG+0t4Jvp36KFhtTQMczibNXXEbf99QqZ1OYF0939RjRAB8EQskdlXaSVFt8M
         oLvgJAfNoCvmByfmAhZ0M8vJgj6lcyo9SQlXCLJ0Rw1FzvdKLe6IrAFy/CiwCBDUmB
         I34xeu5LB0S+0g0tp9lEZAV9MpzGL+utSuR8IO+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.16 022/227] HID: amd_sfh: Increase sensor command timeout
Date:   Mon, 21 Feb 2022 09:47:21 +0100
Message-Id: <20220221084935.584019784@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit a7072c01c3ac3ae6ecd08fa7b43431cfc8ed331f upstream.

HPD sensors take more time to initialize. Hence increasing sensor
command timeout to get response with status within a max timeout.

Fixes: 173709f50e98 ("HID: amd_sfh: Add command response to check command status")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -37,11 +37,11 @@ static int amd_sfh_wait_response_v2(stru
 {
 	union cmd_response cmd_resp;
 
-	/* Get response with status within a max of 800 ms timeout */
+	/* Get response with status within a max of 1600 ms timeout */
 	if (!readl_poll_timeout(mp2->mmio + AMD_P2C_MSG(0), cmd_resp.resp,
 				(cmd_resp.response_v2.response == sensor_sts &&
 				cmd_resp.response_v2.status == 0 && (sid == 0xff ||
-				cmd_resp.response_v2.sensor_id == sid)), 500, 800000))
+				cmd_resp.response_v2.sensor_id == sid)), 500, 1600000))
 		return cmd_resp.response_v2.response;
 
 	return SENSOR_DISABLED;


