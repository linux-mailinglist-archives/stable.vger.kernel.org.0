Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BEE66CB73
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbjAPRPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjAPROd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:14:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC514C0FA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 458DFB80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ECCC433EF;
        Mon, 16 Jan 2023 16:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888102;
        bh=tYIEuLSNTWlXjFmgvDwBaG8GSlNO4i8M05o/zEICOGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHGT5ex3Fk+CrNf9N/mIP3A2+k7Q79unSq8AOQDKkkh8F0+/O0UxcuwJ1j41RwsPX
         uVzYejcSGbxig0gtvzFPY741igpcZ0P7KQhIMJJjg2EM0e3AoVfCKmNiSNt9abqwAT
         xQP/y+hN48HD4iF6SOUQTyX+hzKt3SOht84EYg9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 402/521] parisc: led: Fix potential null-ptr-deref in start_task()
Date:   Mon, 16 Jan 2023 16:51:04 +0100
Message-Id: <20230116154905.050739492@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
@@ -141,6 +141,9 @@ static int start_task(void)
 
 	/* Create the work queue and queue the LED task */
 	led_wq = create_singlethread_workqueue("led_wq");	
+	if (!led_wq)
+		return -ENOMEM;
+
 	queue_delayed_work(led_wq, &led_task, 0);
 
 	return 0;


