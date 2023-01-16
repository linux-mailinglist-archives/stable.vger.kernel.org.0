Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FD566C624
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjAPQPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjAPQOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:14:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466F22B60B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF079B8107E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C65C433EF;
        Mon, 16 Jan 2023 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885327;
        bh=xtoi+cL5e9Hl7BG0Y7UVhfjTsNzzC+GciBM14Jm1VT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qe0dTRqug1yqFFMfYwoitSv/c2onrImAG2oqYt/kifClVm+Q/xYRjxCE0Vi6NI6Ec
         4Hi4cvcDHXAey7AybSQNg8ow6Kq4Ofzm/ajSm8/orPYYvqrde/a1jb9RRT2M8SQN3d
         5/imE44M7oEgpRqb61TCjQyBfbqe0Rm8+V5WceDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 010/658] USB: serial: f81534: fix division by zero on line-speed change
Date:   Mon, 16 Jan 2023 16:41:38 +0100
Message-Id: <20230116154910.125965119@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 188c9c2e0c7f4ae864113f80c40bafb394062271 upstream.

The driver leaves the line speed unchanged in case a requested speed is
not supported. Make sure to handle the case where the current speed is
B0 (hangup) without dividing by zero when determining the clock source.

Fixes: 3aacac02f385 ("USB: serial: f81534: add high baud rate support")
Cc: stable@vger.kernel.org      # 4.16
Cc: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/f81534.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/f81534.c
+++ b/drivers/usb/serial/f81534.c
@@ -538,9 +538,6 @@ static int f81534_submit_writer(struct u
 
 static u32 f81534_calc_baud_divisor(u32 baudrate, u32 clockrate)
 {
-	if (!baudrate)
-		return 0;
-
 	/* Round to nearest divisor */
 	return DIV_ROUND_CLOSEST(clockrate, baudrate);
 }
@@ -570,9 +567,14 @@ static int f81534_set_port_config(struct
 	u32 baud_list[] = {baudrate, old_baudrate, F81534_DEFAULT_BAUD_RATE};
 
 	for (i = 0; i < ARRAY_SIZE(baud_list); ++i) {
-		idx = f81534_find_clk(baud_list[i]);
+		baudrate = baud_list[i];
+		if (baudrate == 0) {
+			tty_encode_baud_rate(tty, 0, 0);
+			return 0;
+		}
+
+		idx = f81534_find_clk(baudrate);
 		if (idx >= 0) {
-			baudrate = baud_list[i];
 			tty_encode_baud_rate(tty, baudrate, baudrate);
 			break;
 		}


