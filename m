Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46136EE1CA
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 15:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfKDOC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 09:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbfKDOC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 09:02:27 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 297DD218BA;
        Mon,  4 Nov 2019 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572876147;
        bh=kVbBYjLr2P0KyT8+3ZaubSdkgCRxufOnNRzH+ex4n0E=;
        h=Subject:To:From:Date:From;
        b=U7vMC2fzlf07UZ6E9zvboDfKWidc8XOM3uCTyczkU0d3eIKUo91nkwjI9UR7JWgmF
         6s/cO+RWIaq0XyQv+Bo8zhF9pcCdUkDq5h5MRoxrzDXOU4FEH8kkSpiqJKsaUMA6bc
         r05WqWW7mHHuSQRAKAhEH9tLbL3G5ePdMpRoW6GA=
Subject: patch "intel_th: gth: Fix the window switching sequence" added to char-misc-linus
To:     alexander.shishkin@linux.intel.com,
        andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 15:02:22 +0100
Message-ID: <1572876142164124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    intel_th: gth: Fix the window switching sequence

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 87c0b9c79ec136ea76a14a88d675a746bc6a87f9 Mon Sep 17 00:00:00 2001
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Date: Mon, 28 Oct 2019 09:06:45 +0200
Subject: intel_th: gth: Fix the window switching sequence

Commit 8116db57cf16 ("intel_th: Add switch triggering support") added
a trigger assertion of the CTS, but forgot to de-assert it at the end
of the sequence. This results in window switches randomly not happening.

Fix that by de-asserting the trigger at the end of the window switch
sequence.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 8116db57cf16 ("intel_th: Add switch triggering support")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191028070651.9770-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/gth.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwtracing/intel_th/gth.c b/drivers/hwtracing/intel_th/gth.c
index fa9d34af87ac..f72803a02391 100644
--- a/drivers/hwtracing/intel_th/gth.c
+++ b/drivers/hwtracing/intel_th/gth.c
@@ -626,6 +626,9 @@ static void intel_th_gth_switch(struct intel_th_device *thdev,
 	if (!count)
 		dev_dbg(&thdev->dev, "timeout waiting for CTS Trigger\n");
 
+	/* De-assert the trigger */
+	iowrite32(0, gth->base + REG_CTS_CTL);
+
 	intel_th_gth_stop(gth, output, false);
 	intel_th_gth_start(gth, output);
 }
-- 
2.23.0


