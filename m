Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8912719B38A
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388621AbgDAQg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388828AbgDAQgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:36:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB6E3214DB;
        Wed,  1 Apr 2020 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758974;
        bh=0N+pkXtrzINXlBCXI3xKrfyPFVkEbV8bMiRWKBm2uaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1HitwYaJezDkpEP2do2oqtqnB95iD0WGsarM30NmN6Gx7DiekVMydvH1x1olWfiG
         tI5CGfltcuNO+R4SbHt6dtsXstnP6iTOuTTjkDrekASnc+JilXGauULQZHL2t04mCb
         oiLYxMEzRjLD+johDKpaLlro+DqvXSHpA+rQ4dFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 035/102] staging: greybus: loopback_test: fix potential path truncation
Date:   Wed,  1 Apr 2020 18:17:38 +0200
Message-Id: <20200401161539.367115980@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit f16023834863932f95dfad13fac3fc47f77d2f29 upstream.

Newer GCC warns about a possible truncation of a generated sysfs path
name as we're concatenating a directory path with a file name and
placing the result in a buffer that is half the size of the maximum
length of the directory path (which is user controlled).

loopback_test.c: In function 'open_poll_files':
loopback_test.c:651:31: warning: '%s' directive output may be truncated writing up to 511 bytes into a region of size 255 [-Wformat-truncation=]
  651 |   snprintf(buf, sizeof(buf), "%s%s", dev->sysfs_entry, "iteration_count");
      |                               ^~
loopback_test.c:651:3: note: 'snprintf' output between 16 and 527 bytes into a destination of size 255
  651 |   snprintf(buf, sizeof(buf), "%s%s", dev->sysfs_entry, "iteration_count");
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by making sure the buffer is large enough the concatenated
strings.

Fixes: 6b0658f68786 ("greybus: tools: Add tools directory to greybus repo and add loopback")
Fixes: 9250c0ee2626 ("greybus: Loopback_test: use poll instead of inotify")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20200312110151.22028-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/greybus/tools/loopback_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/greybus/tools/loopback_test.c
+++ b/drivers/staging/greybus/tools/loopback_test.c
@@ -646,7 +646,7 @@ baddir:
 static int open_poll_files(struct loopback_test *t)
 {
 	struct loopback_device *dev;
-	char buf[MAX_STR_LEN];
+	char buf[MAX_SYSFS_PATH + MAX_STR_LEN];
 	char dummy;
 	int fds_idx = 0;
 	int i;


