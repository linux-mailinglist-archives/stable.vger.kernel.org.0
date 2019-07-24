Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084C274626
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391117AbfGYFny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391107AbfGYFnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EB9721850;
        Thu, 25 Jul 2019 05:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033432;
        bh=11E7e5E99LqGGNJmqynG3uIbu/ENqOYwEjK/1K0oJ5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTPlkx9lzcGxH1FrR7FnT62phLq0m5q1wLlUr7zL3juua4YdFtA69T17ldIFFhy0r
         8m7vYiBd6du9A4Ma4yx6vt/BLNAJjsPx4/pJGbve1kL5PYCBHck+EPxUQgR4RZI7x1
         aK3o0lVpbYVv3ymApxqGrsv4jDTCM9OFbS5wWf9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Soltys <soltys@ziu.info>,
        Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 205/271] raid5-cache: Need to do start() part job after adding journal device
Date:   Wed, 24 Jul 2019 21:21:14 +0200
Message-Id: <20190724191712.656388776@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit d9771f5ec46c282d518b453c793635dbdc3a2a94 upstream.

commit d5d885fd514f ("md: introduce new personality funciton start()")
splits the init job to two parts. The first part run() does the jobs that
do not require the md threads. The second part start() does the jobs that
require the md threads.

Now it just does run() in adding new journal device. It needs to do the
second part start() too.

Fixes: d5d885fd514f ("md: introduce new personality funciton start()")
Cc: stable@vger.kernel.org #v4.9+
Reported-by: Michal Soltys <soltys@ziu.info>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7670,7 +7670,7 @@ abort:
 static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
-	int err = -EEXIST;
+	int ret, err = -EEXIST;
 	int disk;
 	struct disk_info *p;
 	int first = 0;
@@ -7685,7 +7685,14 @@ static int raid5_add_disk(struct mddev *
 		 * The array is in readonly mode if journal is missing, so no
 		 * write requests running. We should be safe
 		 */
-		log_init(conf, rdev, false);
+		ret = log_init(conf, rdev, false);
+		if (ret)
+			return ret;
+
+		ret = r5l_start(conf->log);
+		if (ret)
+			return ret;
+
 		return 0;
 	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)


