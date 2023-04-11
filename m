Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68C36DD469
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 09:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjDKHk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 03:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjDKHk5 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 11 Apr 2023 03:40:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905D9E77
        for <Stable@vger.kernel.org>; Tue, 11 Apr 2023 00:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BEA46225C
        for <Stable@vger.kernel.org>; Tue, 11 Apr 2023 07:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384D4C433D2;
        Tue, 11 Apr 2023 07:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681198855;
        bh=hXetoUbrXQF5rkZBp2YJXTcEoBK3WuIBSd4Z1/bQaTU=;
        h=Subject:To:From:Date:From;
        b=tvqsULX5mTz+ezeI0zBbihO3wi8b6sU7iLs5yxuFX8X2px7YNFzxM7kFMlD9LuQxs
         njiYjLGj2MKIisACKzQlUiURM04g3QGT0ONNhQhgOTa5HFaeEgxV7L+SGjaClhCkDl
         EMMf0qXpW9/cfJh/jo4VJEykOr8eWUO9KhPG2/so=
Subject: patch "iio: light: tsl2772: fix reading proximity-diodes from device tree" added to char-misc-linus
To:     bmasney@redhat.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, trix@redhat.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 09:40:45 +0200
Message-ID: <2023041145-extortion-drearily-bb89@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: tsl2772: fix reading proximity-diodes from device tree

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b1cb00d51e361cf5af93649917d9790e1623647e Mon Sep 17 00:00:00 2001
From: Brian Masney <bmasney@redhat.com>
Date: Mon, 3 Apr 2023 21:14:55 -0400
Subject: iio: light: tsl2772: fix reading proximity-diodes from device tree

tsl2772_read_prox_diodes() will correctly parse the properties from
device tree to determine which proximity diode(s) to read from, however
it didn't actually set this value on the struct tsl2772_settings. Let's
go ahead and fix that.

Reported-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/lkml/20230327120823.1369700-1-trix@redhat.com/
Fixes: 94cd1113aaa0 ("iio: tsl2772: add support for reading proximity led settings from device tree")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20230404011455.339454-1-bmasney@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/tsl2772.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/light/tsl2772.c b/drivers/iio/light/tsl2772.c
index ad50baa0202c..e823c145f679 100644
--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -601,6 +601,7 @@ static int tsl2772_read_prox_diodes(struct tsl2772_chip *chip)
 			return -EINVAL;
 		}
 	}
+	chip->settings.prox_diode = prox_diode_mask;
 
 	return 0;
 }
-- 
2.40.0


