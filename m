Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9406681268
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237693AbjA3OUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbjA3OUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:20:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B6CFF20
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:19:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8BC4B811C7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C244C433EF;
        Mon, 30 Jan 2023 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088359;
        bh=943133jui6r9WFeBmMycMBl+F7EKIy7CJB8mKCaDJlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2gB9WjAmT8aqFws6S6hxibsa+0dqS+QKfl3geuYxNZIx932m6e+d5ccgVF1byUQEz
         EJUdIwyIwFpfdqb4ToT0x92P0hRPhni9HoCUbaeiEaV31Ei66mgfkCvVsrtYBGc+jS
         J5KBoWMq1p+v/I9KqRZXXXeugY5solxOcLmejzxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ivo Borisov Shopov <ivoshopov@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/204] tools: gpio: fix -c option of gpio-event-mon
Date:   Mon, 30 Jan 2023 14:52:41 +0100
Message-Id: <20230130134325.197816096@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivo Borisov Shopov <ivoshopov@gmail.com>

[ Upstream commit 677d85e1a1ee69fa05ccea83847309484be3781c ]

Following line should listen for a rising edge and exit after the first
one since '-c 1' is provided.

    # gpio-event-mon -n gpiochip1 -o 0 -r -c 1

It works with kernel 4.19 but it doesn't work with 5.10. In 5.10 the
above command doesn't exit after the first rising edge it keep listening
for an event forever. The '-c 1' is not taken into an account.
The problem is in commit 62757c32d5db ("tools: gpio: add multi-line
monitoring to gpio-event-mon").
Before this commit the iterator 'i' in monitor_device() is used for
counting of the events (loops). In the case of the above command (-c 1)
we should start from 0 and increment 'i' only ones and hit the 'break'
statement and exit the process. But after the above commit counting
doesn't start from 0, it start from 1 when we listen on one line.
It is because 'i' is used from one more purpose, counting of lines
(num_lines) and it isn't restore to 0 after following code

    for (i = 0; i < num_lines; i++)
        gpiotools_set_bit(&values.mask, i);

Restore the initial value of the iterator to 0 in order to allow counting
of loops to work for any cases.

Fixes: 62757c32d5db ("tools: gpio: add multi-line monitoring to gpio-event-mon")
Signed-off-by: Ivo Borisov Shopov <ivoshopov@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
[Bartosz: tweak the commit message]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/gpio/gpio-event-mon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/gpio/gpio-event-mon.c b/tools/gpio/gpio-event-mon.c
index a2b233fdb572..667019990982 100644
--- a/tools/gpio/gpio-event-mon.c
+++ b/tools/gpio/gpio-event-mon.c
@@ -86,6 +86,7 @@ int monitor_device(const char *device_name,
 			gpiotools_test_bit(values.bits, i));
 	}
 
+	i = 0;
 	while (1) {
 		struct gpio_v2_line_event event;
 
-- 
2.39.0



