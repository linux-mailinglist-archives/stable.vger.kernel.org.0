Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D35C65D989
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbjADQ0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240018AbjADQZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:25:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24F833D4A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:25:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 823B0B81731
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABACC433D2;
        Wed,  4 Jan 2023 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849507;
        bh=AipgWh0lSkZV+fTw1vScQ4PtoBkZ3hoHnYYd+w57pTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQLONr+1unYZG1Iulm6H0080E24E+LTW3hUDrt3G6JNoyB4jIKYbknFa8Hj+tvf+C
         kwXA18exI699nend7/DwBvrTS1JuCimcOuxA03Yhz5iUkQlqe4ok2IjvgQMzr4MeKN
         3x6WCT61/bxEpeEWxGKCJyFJ9sEGmY8YIR+7TSB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 6.0 120/177] parisc: led: Fix potential null-ptr-deref in start_task()
Date:   Wed,  4 Jan 2023 17:06:51 +0100
Message-Id: <20230104160511.278947471@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

commit 41f563ab3c33698bdfc3403c7c2e6c94e73681e4 upstream.

start_task() calls create_singlethread_workqueue() and not checked the
ret value, which may return NULL. And a null-ptr-deref may happen:

start_task()
    create_singlethread_workqueue() # failed, led_wq is NULL
    queue_delayed_work()
        queue_delayed_work_on()
            __queue_delayed_work()  # warning here, but continue
                __queue_work()      # access wq->flags, null-ptr-deref

Check the ret value and return -ENOMEM if it is NULL.

Fixes: 3499495205a6 ("[PARISC] Use work queue in LED/LCD driver instead of tasklet.")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/led.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -137,6 +137,9 @@ static int start_task(void)
 
 	/* Create the work queue and queue the LED task */
 	led_wq = create_singlethread_workqueue("led_wq");	
+	if (!led_wq)
+		return -ENOMEM;
+
 	queue_delayed_work(led_wq, &led_task, 0);
 
 	return 0;


