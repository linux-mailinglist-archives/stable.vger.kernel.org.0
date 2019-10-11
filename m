Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC10D3980
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 08:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfJKGp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 02:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfJKGp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 02:45:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC34D214E0;
        Fri, 11 Oct 2019 06:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570776357;
        bh=cJMPVKndQH8vQ2vx8WEHa1cxfsXOSyxG6wfm1I3b+9s=;
        h=Subject:To:From:Date:From;
        b=LiWtB1d5RXGcDQbWXchzbkQYz2J5+rjid45DYZRzPn/pkUl2iDGFuiyPoNMEpG24r
         zm80wDGyYtNLOYJtFjKj0uyYZ/CEz6bElgZh2t2T0Jp0XsyPi3bxEKFpgMI5nsyS0X
         21OkFbDzMNVnbmqWa/mnoHLVLoTVSQHP7AHX16C4=
Subject: patch "firmware: google: increment VPD key_len properly" added to char-misc-linus
To:     briannorris@chromium.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, hungte@chromium.org, stable@vger.kernel.org,
        swboyd@chromium.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Oct 2019 08:45:54 +0200
Message-ID: <157077635414568@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    firmware: google: increment VPD key_len properly

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 442f1e746e8187b9deb1590176f6b0ff19686b11 Mon Sep 17 00:00:00 2001
From: Brian Norris <briannorris@chromium.org>
Date: Mon, 30 Sep 2019 14:45:22 -0700
Subject: firmware: google: increment VPD key_len properly

Commit 4b708b7b1a2c ("firmware: google: check if size is valid when
decoding VPD data") adds length checks, but the new vpd_decode_entry()
function botched the logic -- it adds the key length twice, instead of
adding the key and value lengths separately.

On my local system, this means vpd.c's vpd_section_create_attribs() hits
an error case after the first attribute it parses, since it's no longer
looking at the correct offset. With this patch, I'm back to seeing all
the correct attributes in /sys/firmware/vpd/...

Fixes: 4b708b7b1a2c ("firmware: google: check if size is valid when decoding VPD data")
Cc: <stable@vger.kernel.org>
Cc: Hung-Te Lin <hungte@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20190930214522.240680-1-briannorris@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/google/vpd_decode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/google/vpd_decode.c b/drivers/firmware/google/vpd_decode.c
index dda525c0f968..5c6f2a74f104 100644
--- a/drivers/firmware/google/vpd_decode.c
+++ b/drivers/firmware/google/vpd_decode.c
@@ -52,7 +52,7 @@ static int vpd_decode_entry(const u32 max_len, const u8 *input_buf,
 	if (max_len - consumed < *entry_len)
 		return VPD_FAIL;
 
-	consumed += decoded_len;
+	consumed += *entry_len;
 	*_consumed = consumed;
 	return VPD_OK;
 }
-- 
2.23.0


