Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC79197950
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 12:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgC3KcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 06:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728933AbgC3KcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 06:32:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB862072E;
        Mon, 30 Mar 2020 10:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585564343;
        bh=X+kV83oKUjzAfOr8z9Zmf6sdQQrj/6wjmxq5fSRieQs=;
        h=Subject:To:From:Date:From;
        b=ruZiSifrVu/znmCpp0zGOje4kn7KpPXsa7C5kiamWi8cgaUx6i95BPrZX4UGh0D98
         gOwpLyK08vLiN7tVGZ8R9e31nUfp8vXKBBCFm8TkS47M3S1uAw7S7Kpx2dq4U3r874
         HFNoXqBeEd6RcuyPGoHHEQ0DCQgDvCCjRLsJPiO8=
Subject: patch "coresight: do not use the BIT() macro in the UAPI header" added to char-misc-next
To:     esyr@redhat.com, gregkh@linuxfoundation.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 12:32:11 +0200
Message-ID: <1585564331110184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    coresight: do not use the BIT() macro in the UAPI header

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 9b6eaaf3db5e5888df7bca7fed7752a90f7fd871 Mon Sep 17 00:00:00 2001
From: Eugene Syromiatnikov <esyr@redhat.com>
Date: Tue, 24 Mar 2020 05:22:13 +0100
Subject: coresight: do not use the BIT() macro in the UAPI header

The BIT() macro definition is not available for the UAPI headers
(moreover, it can be defined differently in the user space); replace
its usage with the _BITUL() macro that is defined in <linux/const.h>.

Fixes: 237483aa5cf4 ("coresight: stm: adding driver for CoreSight STM component")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200324042213.GA10452@asgard.redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/coresight-stm.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/coresight-stm.h b/include/uapi/linux/coresight-stm.h
index aac550a52f80..8847dbf24151 100644
--- a/include/uapi/linux/coresight-stm.h
+++ b/include/uapi/linux/coresight-stm.h
@@ -2,8 +2,10 @@
 #ifndef __UAPI_CORESIGHT_STM_H_
 #define __UAPI_CORESIGHT_STM_H_
 
-#define STM_FLAG_TIMESTAMPED   BIT(3)
-#define STM_FLAG_GUARANTEED    BIT(7)
+#include <linux/const.h>
+
+#define STM_FLAG_TIMESTAMPED   _BITUL(3)
+#define STM_FLAG_GUARANTEED    _BITUL(7)
 
 /*
  * The CoreSight STM supports guaranteed and invariant timing
-- 
2.26.0


