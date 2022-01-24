Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8CC49807B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242937AbiAXNJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242933AbiAXNJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:09:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4AFC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:09:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7168B61225
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FB6C340E1;
        Mon, 24 Jan 2022 13:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643029748;
        bh=SwzenZHvXMJT3oCeZ5WqKoXinn7RLTvfi0nbJZkDpRQ=;
        h=Subject:To:Cc:From:Date:From;
        b=MmfX6lBTOs+S6ZKd7RbMj1wUj0PfBYbXEPj7mB8lbk+hz+Bgz0MjEMqSxCZArK4kK
         xsXhhd7YpF7ie8XkhmioIXzYkSco+vKb8i+ZZ92ckeDos5DEenVvV0YtnnPnN85Djv
         Ku7wmgkRocw9VLxobHAT/4kJ4E6OD5tangyWQuk0=
Subject: FAILED: patch "[PATCH] rtc: cmos: Evaluate century appropriate" failed to apply to 4.14-stable tree
To:     luriwen@kylinos.cn, alexandre.belloni@bootlin.com, e@80x24.org,
        mat.jonczyk@o2.pl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:09:03 +0100
Message-ID: <164302974316890@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ff164ae39b82ee483b24579c8e22a13a8ce5bd04 Mon Sep 17 00:00:00 2001
From: Riwen Lu <luriwen@kylinos.cn>
Date: Thu, 6 Jan 2022 16:46:09 +0800
Subject: [PATCH] rtc: cmos: Evaluate century appropriate
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There's limiting the year to 2069. When setting the rtc year to 2070,
reading it returns 1970. Evaluate century starting from 19 to count the
correct year.

$ sudo date -s 20700106
Mon 06 Jan 2070 12:00:00 AM CST
$ sudo hwclock -w
$ sudo hwclock -r
1970-01-06 12:00:49.604968+08:00

Fixes: 2a4daadd4d3e5071 ("rtc: cmos: ignore bogus century byte")

Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
Acked-by: Eric Wong <e@80x24.org>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220106084609.1223688-1-luriwen@kylinos.cn

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 7f689f1bafc5..ae9f131b43c0 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -159,7 +159,7 @@ int mc146818_get_time(struct rtc_time *time)
 #endif
 
 #ifdef CONFIG_ACPI
-	if (p.century > 20)
+	if (p.century > 19)
 		time->tm_year += (p.century - 19) * 100;
 #endif
 

