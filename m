Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8396113C072
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 13:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbgAOMMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 07:12:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730712AbgAOMMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7F03222C3;
        Wed, 15 Jan 2020 12:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579090363;
        bh=kypzZpemdJKRFn2CnBNOdJSHZf4jA8Wnruk8nPQ8AHI=;
        h=Subject:To:From:Date:From;
        b=eYetI6YQ05RjYeSt41Ax5GXsQJsCa65XzbEljD1Fs9Q82xzCQMrj4TA1IhmRrW/ex
         TeJH8oEjFR+voirg9Y6Axow4JO6oHhzlcQZD51tQ+z/Jq1/Tie5h4VhKnElrGYB1n+
         IIO3v0kqidGrld0XJDhN4q8yjhst1aGeKUcO6hKE=
Subject: patch "staging: wlan-ng: ensure error return is actually returned" added to staging-testing
To:     colin.king@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Jan 2020 13:12:40 +0100
Message-ID: <1579090360237144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: wlan-ng: ensure error return is actually returned

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 4cc41cbce536876678b35e03c4a8a7bb72c78fa9 Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Tue, 14 Jan 2020 18:16:04 +0000
Subject: staging: wlan-ng: ensure error return is actually returned

Currently when the call to prism2sta_ifst fails a netdev_err error
is reported, error return variable result is set to -1 but the
function always returns 0 for success.  Fix this by returning
the error value in variable result rather than 0.

Addresses-Coverity: ("Unused value")
Fixes: 00b3ed168508 ("Staging: add wlan-ng prism2 usb driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200114181604.390235-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wlan-ng/prism2mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 7350fe5d96a3..a8860d2aee68 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -959,7 +959,7 @@ int prism2mgmt_flashdl_state(struct wlandevice *wlandev, void *msgp)
 		}
 	}
 
-	return 0;
+	return result;
 }
 
 /*----------------------------------------------------------------
-- 
2.24.1


