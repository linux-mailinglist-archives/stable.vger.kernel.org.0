Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51CD4BE723
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348909AbiBUJXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349932AbiBUJVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511742DDC;
        Mon, 21 Feb 2022 01:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B6D1ACE0E86;
        Mon, 21 Feb 2022 09:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95101C340E9;
        Mon, 21 Feb 2022 09:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434555;
        bh=73vwgUD43t7AoZddUTnSrZqXoWbzL9ptrVd6gHU2/qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bc08qcQ1mJZZ8N6HGHxb5WNwGf8mfSwg75KY+ehrUVKnBIgI7ZT9HaOziMhcGoafi
         g0PjEHIoboSz0PUgucIXmXh6uZwhTyl3E8CU7TRB7YoUcqSsT8Pi+C2K6cbQuj8yHk
         mIeeSFOkZnU1VHddhpeP9lnZ6I+h/x7OBdi3lLos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 016/196] HID: amd_sfh: Increase sensor command timeout
Date:   Mon, 21 Feb 2022 09:47:28 +0100
Message-Id: <20220221084931.437834667@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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
@@ -36,11 +36,11 @@ static int amd_sfh_wait_response_v2(stru
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


