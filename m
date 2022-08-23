Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5E259D87B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbiHWJv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351913AbiHWJvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4149E2D7;
        Tue, 23 Aug 2022 01:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5E03B81C4D;
        Tue, 23 Aug 2022 08:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE16CC433C1;
        Tue, 23 Aug 2022 08:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244289;
        bh=DR1snfRLybVmdH1tOb3/8khLmueGUFR93/TihdxZuYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgN/ROKslviYay73BT5PFe37Z9xKdY2gAOnXXsG0u/s01EwSs8zZao1wFMn/HcEAN
         5Mg/opfFZC7GP7x5/PP36cYr6wT2bCrp6CPi8VHfniifTFx7/PjMNKZpqnSFWAY888
         P6bFUI+sO2wmOP7MOxJTasQ7Ethb7l4TKrSh9igI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 068/244] Input: exc3000 - fix return value check of wait_for_completion_timeout
Date:   Tue, 23 Aug 2022 10:23:47 +0200
Message-Id: <20220823080101.347387951@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 6bb7144c3fa16a5efb54a8e2aff1817b4168018e upstream.

wait_for_completion_timeout() returns unsigned long not int.
It returns 0 if timed out, and positive if completed.
The check for <= 0 is ambiguous and should be == 0 here
indicating timeout which is the only error case.

Fixes: 102feb1ddfd0 ("Input: exc3000 - factor out vendor data request")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220411105828.22140-1-linmq006@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/exc3000.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/input/touchscreen/exc3000.c
+++ b/drivers/input/touchscreen/exc3000.c
@@ -220,6 +220,7 @@ static int exc3000_vendor_data_request(s
 {
 	u8 buf[EXC3000_LEN_VENDOR_REQUEST] = { 0x67, 0x00, 0x42, 0x00, 0x03 };
 	int ret;
+	unsigned long time_left;
 
 	mutex_lock(&data->query_lock);
 
@@ -233,9 +234,9 @@ static int exc3000_vendor_data_request(s
 		goto out_unlock;
 
 	if (response) {
-		ret = wait_for_completion_timeout(&data->wait_event,
-						  timeout * HZ);
-		if (ret <= 0) {
+		time_left = wait_for_completion_timeout(&data->wait_event,
+							timeout * HZ);
+		if (time_left == 0) {
 			ret = -ETIMEDOUT;
 			goto out_unlock;
 		}


