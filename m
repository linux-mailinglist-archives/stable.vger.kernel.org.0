Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341FC2FF2AD
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 19:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbhAUSAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 13:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389159AbhAURzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 12:55:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B145207C5;
        Thu, 21 Jan 2021 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611251703;
        bh=zwXyeqL89HHn4l4P68Muqak5S1QFtRCvK6S9R/xqib4=;
        h=Subject:To:From:Date:From;
        b=vIE4NnB74DnzLvqzLVVlea88UaInJxwtKO5eObXeak13xtJG4UwKouv8cHr97zipu
         xIkhHMbghnq+HjTXr+Np1gvA8VBxjLDKXC+n/0DGrrOi28BphxdZ8b3UYRICDKl+8T
         xVIOxu2wFHYcCY4ugiYR9JIxlelw0O5feT8/KemM=
Subject: patch "stm class: Fix module init return on allocation failure" added to char-misc-linus
To:     john.wanghui@huawei.com, alexander.shishkin@linux.intel.com,
        gregkh@linuxfoundation.org, hulkci@huawei.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 Jan 2021 18:55:01 +0100
Message-ID: <16112517016329@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    stm class: Fix module init return on allocation failure

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 927633a6d20af319d986f3e42c3ef9f6d7835008 Mon Sep 17 00:00:00 2001
From: Wang Hui <john.wanghui@huawei.com>
Date: Fri, 15 Jan 2021 22:59:16 +0300
Subject: stm class: Fix module init return on allocation failure

In stm_heartbeat_init(): return value gets reset after the first
iteration by stm_source_register_device(), so allocation failures
after that will, after a clean up, return success. Fix that.

Fixes: 119291853038 ("stm class: Add heartbeat stm source device")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hui <john.wanghui@huawei.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20210115195917.3184-2-alexander.shishkin@linux.intel.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/stm/heartbeat.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/stm/heartbeat.c b/drivers/hwtracing/stm/heartbeat.c
index 3e7df1c0477f..81d7b21d31ec 100644
--- a/drivers/hwtracing/stm/heartbeat.c
+++ b/drivers/hwtracing/stm/heartbeat.c
@@ -64,7 +64,7 @@ static void stm_heartbeat_unlink(struct stm_source_data *data)
 
 static int stm_heartbeat_init(void)
 {
-	int i, ret = -ENOMEM;
+	int i, ret;
 
 	if (nr_devs < 0 || nr_devs > STM_HEARTBEAT_MAX)
 		return -EINVAL;
@@ -72,8 +72,10 @@ static int stm_heartbeat_init(void)
 	for (i = 0; i < nr_devs; i++) {
 		stm_heartbeat[i].data.name =
 			kasprintf(GFP_KERNEL, "heartbeat.%d", i);
-		if (!stm_heartbeat[i].data.name)
+		if (!stm_heartbeat[i].data.name) {
+			ret = -ENOMEM;
 			goto fail_unregister;
+		}
 
 		stm_heartbeat[i].data.nr_chans	= 1;
 		stm_heartbeat[i].data.link	= stm_heartbeat_link;
-- 
2.30.0


