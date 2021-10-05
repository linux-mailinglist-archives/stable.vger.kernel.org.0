Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2E9422CE3
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 17:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhJEPsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 11:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236250AbhJEPsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 11:48:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 720CF61131;
        Tue,  5 Oct 2021 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633448770;
        bh=Rj/0jHRMsB6F9MLOSYgfUq/M54kkJZlGAsxmV279FQ4=;
        h=Subject:To:From:Date:From;
        b=LxrM1HhQ4RaO3dewA7DbM8p5aFro7CKZnL8V7/0IfIEY83xjnyKheYYx7MMyE92dt
         t95z0UU5yJXIv4KW+SFFF+x2rODWV0DXqiC37ZKAKp9MXKut7nyjm2BQi6piQ/ru5g
         /FcIYUIRDitIONdoOuReUnb4mOjxFX5Ne/8hyWbE=
Subject: patch "driver core: Reject pointless SYNC_STATE_ONLY device links" added to driver-core-linus
To:     saravanak@google.com, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, stable@vger.kernel.org,
        ulf.hansson@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 17:46:08 +0200
Message-ID: <1633448768149175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: Reject pointless SYNC_STATE_ONLY device links

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f729a592adb6760013c3e48622a5bf256b992452 Mon Sep 17 00:00:00 2001
From: Saravana Kannan <saravanak@google.com>
Date: Wed, 29 Sep 2021 12:05:49 -0700
Subject: driver core: Reject pointless SYNC_STATE_ONLY device links

SYNC_STATE_ONLY device links intentionally allow cycles because cyclic
sync_state() dependencies are valid and necessary.

However a SYNC_STATE_ONLY device link where the consumer and the supplier
are the same device is pointless because the device link would be deleted
as soon as the device probes (because it's also the consumer) and won't
affect when the sync_state() callback is called. It's a waste of CPU cycles
and memory to create this device link. So reject any attempts to create
such a device link.

Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
Cc: stable <stable@vger.kernel.org>
Reported-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210929190549.860541-1-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 15986cc2fe5e..249da496581a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -687,7 +687,8 @@ struct device_link *device_link_add(struct device *consumer,
 {
 	struct device_link *link;
 
-	if (!consumer || !supplier || flags & ~DL_ADD_VALID_FLAGS ||
+	if (!consumer || !supplier || consumer == supplier ||
+	    flags & ~DL_ADD_VALID_FLAGS ||
 	    (flags & DL_FLAG_STATELESS && flags & DL_MANAGED_LINK_FLAGS) ||
 	    (flags & DL_FLAG_SYNC_STATE_ONLY &&
 	     (flags & ~DL_FLAG_INFERRED) != DL_FLAG_SYNC_STATE_ONLY) ||
-- 
2.33.0


