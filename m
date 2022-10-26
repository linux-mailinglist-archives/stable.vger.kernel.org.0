Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A2360E42D
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiJZPKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiJZPKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:10:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561A85E565
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E220E61F72
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFCDC433D6;
        Wed, 26 Oct 2022 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666797038;
        bh=ucqWQUAPvMUVRrKyQFMv2cy3GOBtZJQ5fEreLsQCayg=;
        h=Subject:To:Cc:From:Date:From;
        b=ODlMX7yJRe/gcw0fuNX4OBOU3ovGMrQ4ARtw8HcTdFgGdTvWG9VjX8WPwwWAXbe/P
         zegFTZfzvLdvZ6VAqCmXsUawzqY4ARR/dEs5DlEvoTYDZ7fA6kL4qQGH61V7lAyeLt
         orx9id5OYFf15/EiBr/XrHwiBdRgK6M9xY+HjVa8=
Subject: FAILED: patch "[PATCH] media: mceusb: set timeout to at least timeout provided" failed to apply to 4.19-stable tree
To:     sean@mess.org, mchehab@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:10:27 +0200
Message-ID: <1666797027198162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

20b794ddce47 ("media: mceusb: set timeout to at least timeout provided")
528222d853f9 ("media: rc: harmonize infrared durations to microseconds")
261463dbc34f ("media: rc: add support for Infrared Toy and IR Droid devices")
6f5129e251ae ("media: rtl28xxu: fix idle handling")
e43148645d18 ("media: mceusb: fix out of bounds read in MCE receiver buffer")
81bab3fa6ca8 ("media: rc: increase rc-mm tolerance and add debug message")
9fc3ce31f5bd ("media: mceusb: fix (eliminate) TX IR signal length limit")
0c4df39e504b ("media: technisat-usb2: break out of loop at end of buffer")
172876928f98 ("media: rc: xbox_remote: add protocol and set timeout")
a49a7a4635de ("media: smipcie: add universal ir capability")
721074b03411 ("media: rc: rcmm decoder and encoder")
903b77c63167 ("Merge tag 'linux-kselftest-4.21-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 20b794ddce475ed012deb365000527c17b3e93e6 Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Fri, 2 Sep 2022 12:32:21 +0200
Subject: [PATCH] media: mceusb: set timeout to at least timeout provided

By rounding down, the actual timeout can be lower than requested. As a
result, long spaces just below the requested timeout can be incorrectly
reported as timeout and truncated.

Fixes: 877f1a7cee3f ("media: rc: mceusb: allow the timeout to be configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 39d2b03e2631..c76ba24c1f55 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1077,7 +1077,7 @@ static int mceusb_set_timeout(struct rc_dev *dev, unsigned int timeout)
 	struct mceusb_dev *ir = dev->priv;
 	unsigned int units;
 
-	units = DIV_ROUND_CLOSEST(timeout, MCE_TIME_UNIT);
+	units = DIV_ROUND_UP(timeout, MCE_TIME_UNIT);
 
 	cmdbuf[2] = units >> 8;
 	cmdbuf[3] = units;

