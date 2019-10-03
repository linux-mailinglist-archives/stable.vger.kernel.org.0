Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3822ECACB4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388656AbfJCQOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbfJCQOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:14:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F1152054F;
        Thu,  3 Oct 2019 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119276;
        bh=Cq9/10KQj+NH/Bx5YWM63Er78hKvm6bwpuORR7T5TSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5ndArMpc9/kczkA81osY65pfO1eEQNNz/KxpP74ofOzr5b+91+wC4NgH//x1b7Mi
         L/jwkywkInMq0vFSSuMgkQzHSiVosAb/bjVnkO7xbSthWexrghhfYtIShccAEMIA5W
         XFPWCgndl44ekkvZAx2bMRvEInoVRlCfvAFjqvZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.com>,
        Song Liu <songliubraving@fb.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4.14 172/185] md: only call set_in_sync() when it is expected to succeed.
Date:   Thu,  3 Oct 2019 17:54:10 +0200
Message-Id: <20191003154519.575402106@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.com>

commit 480523feae581ab714ba6610388a3b4619a2f695 upstream.

Since commit 4ad23a976413 ("MD: use per-cpu counter for
writes_pending"), set_in_sync() is substantially more expensive: it
can wait for a full RCU grace period which can be 10s of milliseconds.

So we should only call it when the cost is justified.

md_check_recovery() currently calls set_in_sync() every time it finds
anything to do (on non-external active arrays).  For an array
performing resync or recovery, this will be quite often.
Each call will introduce a delay to the md thread, which can noticeable
affect IO submission latency.

In md_check_recovery() we only need to call set_in_sync() if
'safemode' was non-zero at entry, meaning that there has been not
recent IO.  So we save this "safemode was nonzero" state, and only
call set_in_sync() if it was non-zero.

This measurably reduces mean and maximum IO submission latency during
resync/recovery.

Reported-and-tested-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Fixes: 4ad23a976413 ("MD: use per-cpu counter for writes_pending")
Cc: stable@vger.kernel.org (v4.12+)
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8765,6 +8765,7 @@ void md_check_recovery(struct mddev *mdd
 
 	if (mddev_trylock(mddev)) {
 		int spares = 0;
+		bool try_set_sync = mddev->safemode != 0;
 
 		if (!mddev->external && mddev->safemode == 1)
 			mddev->safemode = 0;
@@ -8810,7 +8811,7 @@ void md_check_recovery(struct mddev *mdd
 			}
 		}
 
-		if (!mddev->external && !mddev->in_sync) {
+		if (try_set_sync && !mddev->external && !mddev->in_sync) {
 			spin_lock(&mddev->lock);
 			set_in_sync(mddev);
 			spin_unlock(&mddev->lock);


