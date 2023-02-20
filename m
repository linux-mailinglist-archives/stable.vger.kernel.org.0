Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4D669CEA2
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjBTOBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjBTOBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:01:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763691EBCC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:00:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36238B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91504C433EF;
        Mon, 20 Feb 2023 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901579;
        bh=VggQe6XIzkvZUU0GcnuQDlaxkGBO8ax39sAdfkODASs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPuHuNYJWgH1oi3VFG9S5ZYI6Uxnso5OOYKMMTGKeFEPlV1dXNfQ+ePzEtW/lcsTy
         Hn1/W8dae2yEAyCUDNeQM+lP8Vnzvd2rM73Hth2yEG1MMhn0bLpPnMLx6qLFZxAwOH
         nVNJ5xGAKt6Ecd2Dz1pB9Ka++Ake5Si/irFuKdH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.1 072/118] gpio: sim: fix a memory leak
Date:   Mon, 20 Feb 2023 14:36:28 +0100
Message-Id: <20230220133603.312930951@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 79eeab1d85e0fee4c0bc36f3b6ddf3920f39f74b upstream.

Fix an inverted logic bug in gpio_sim_remove_hogs() that leads to GPIO
hog structures never being freed.

Fixes: cb8c474e79be ("gpio: sim: new testing module")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -732,7 +732,7 @@ static void gpio_sim_remove_hogs(struct
 
 	gpiod_remove_hogs(dev->hogs);
 
-	for (hog = dev->hogs; !hog->chip_label; hog++) {
+	for (hog = dev->hogs; hog->chip_label; hog++) {
 		kfree(hog->chip_label);
 		kfree(hog->line_name);
 	}


