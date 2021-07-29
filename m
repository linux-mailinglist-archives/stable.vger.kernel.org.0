Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC8A3DA777
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 17:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbhG2PWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 11:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237757AbhG2PWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 11:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A09560F22;
        Thu, 29 Jul 2021 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627572149;
        bh=LSE4un793SgY4a8ApXSBCrOpQiGJF5Y3/6T0SZMTKhM=;
        h=Subject:To:From:Date:From;
        b=2TJyp6aTePx2ViGYVlvPuQfUt3nH+F5bUMXacVCfuan36+nRbMDUqLhEXsMggZxCk
         fb0s473VqugbVbHq4y70AtrAG4OhdcRnyl3bGRFYDqpYHLtXXDSuTaFz+igwo/jgjV
         jA5Tm4hBIqMC672KCuMQqYlZaRStvDvr8NZQZ0no=
Subject: patch "firmware_loader: use -ETIMEDOUT instead of -EAGAIN in" added to driver-core-linus
To:     mail@anirudhrb.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        skhan@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 29 Jul 2021 17:22:26 +0200
Message-ID: <16275721462299@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    firmware_loader: use -ETIMEDOUT instead of -EAGAIN in

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0d6434e10b5377a006f6dd995c8fc5e2d82acddc Mon Sep 17 00:00:00 2001
From: Anirudh Rayabharam <mail@anirudhrb.com>
Date: Wed, 28 Jul 2021 14:21:06 +0530
Subject: firmware_loader: use -ETIMEDOUT instead of -EAGAIN in
 fw_load_sysfs_fallback

The only motivation for using -EAGAIN in commit 0542ad88fbdd81bb
("firmware loader: Fix _request_firmware_load() return val for fw load
abort") was to distinguish the error from -ENOMEM, and so there is no
real reason in keeping it. -EAGAIN is typically used to tell the
userspace to try something again and in this case re-using the sysfs
loading interface cannot be retried when a timeout happens, so the
return value is also bogus.

-ETIMEDOUT is received when the wait times out and returning that
is much more telling of what the reason for the failure was. So, just
propagate that instead of returning -EAGAIN.

Suggested-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210728085107.4141-2-mail@anirudhrb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/fallback.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 91899d185e31..1a48be0a030e 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -535,8 +535,6 @@ static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs, long timeout)
 	if (fw_state_is_aborted(fw_priv)) {
 		if (retval == -ERESTARTSYS)
 			retval = -EINTR;
-		else
-			retval = -EAGAIN;
 	} else if (fw_priv->is_paged_buf && !fw_priv->data)
 		retval = -ENOMEM;
 
-- 
2.32.0


