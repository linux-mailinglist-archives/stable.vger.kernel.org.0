Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF3C37FA8E
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhEMPXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234825AbhEMPXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 962AD61182;
        Thu, 13 May 2021 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620919327;
        bh=lPt9fwViL4atmvmfzrBrnSW57DnGw+Grj9zndHSO9ro=;
        h=Subject:To:From:Date:From;
        b=dWa618sQ61ucyBklIJyoiQr8JxDQI1U2g++DPZVFYFll/OJjeCOJinHXor2+lVAXm
         QKvgzDtWQT6+iQkcTDkMjcMWHcHiYNzNGrgOY3OVo0tvStrkiT0kmZKvVG8507wib9
         IKdQQuu62FTnaCT/0E6MoVgOwhyA30geVv/s3AvU=
Subject: patch "ics932s401: fix broken handling of errors when word reading fails" added to char-misc-linus
To:     djwong@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:22:04 +0200
Message-ID: <1620919324235226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ics932s401: fix broken handling of errors when word reading fails

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a73b6a3b4109ce2ed01dbc51a6c1551a6431b53c Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Wed, 28 Apr 2021 15:25:34 -0700
Subject: ics932s401: fix broken handling of errors when word reading fails

In commit b05ae01fdb89, someone tried to make the driver handle i2c read
errors by simply zeroing out the register contents, but for some reason
left unaltered the code that sets the cached register value the function
call return value.

The original patch was authored by a member of the Underhanded
Mangle-happy Nerds, I'm not terribly surprised.  I don't have the
hardware anymore so I can't test this, but it seems like a pretty
obvious API usage fix to me...

Fixes: b05ae01fdb89 ("misc/ics932s401: Add a missing check to i2c_smbus_read_word_data")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20210428222534.GJ3122264@magnolia
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ics932s401.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/ics932s401.c b/drivers/misc/ics932s401.c
index 2bdf560ee681..0f9ea75b0b18 100644
--- a/drivers/misc/ics932s401.c
+++ b/drivers/misc/ics932s401.c
@@ -134,7 +134,7 @@ static struct ics932s401_data *ics932s401_update_device(struct device *dev)
 	for (i = 0; i < NUM_MIRRORED_REGS; i++) {
 		temp = i2c_smbus_read_word_data(client, regs_to_copy[i]);
 		if (temp < 0)
-			data->regs[regs_to_copy[i]] = 0;
+			temp = 0;
 		data->regs[regs_to_copy[i]] = temp >> 8;
 	}
 
-- 
2.31.1


