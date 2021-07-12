Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050083C5113
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243681AbhGLHgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347187AbhGLHeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A83461427;
        Mon, 12 Jul 2021 07:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075081;
        bh=Moj7XFDKb+kqWN293CWhL1akLMoTR6+9lH8NtmXU3fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYUP41iX9SzYmv7xyxYi0HNDdBWbFz3odSlpTB15VsyQYZtlmriBlv1lj7sNGsGkT
         L124338EDsmvh9HJQ+7IUuL06ZHuv0vT28GTQ29oTs17qbWi0/mOFe8fDT6hi+1Thj
         U0/af7fYNepsD2aDXWyRuHBVEcmsoOM87H6QgvAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.13 081/800] s390/cio: dont call css_wait_for_slow_path() inside a lock
Date:   Mon, 12 Jul 2021 08:01:44 +0200
Message-Id: <20210712060924.526818429@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Vijayan <vneethv@linux.ibm.com>

commit c749d8c018daf5fba6dfac7b6c5c78b27efd7d65 upstream.

Currently css_wait_for_slow_path() gets called inside the chp->lock.
The path-verification-loop of slowpath inside this lock could lead to
deadlock as reported by the lockdep validator.

The ccw_device_get_chp_desc() during the instance of a device-set-online
would try to acquire the same 'chp->lock' to read the chp->desc.
The instance of this function can get called from multiple scenario,
like probing or setting-device online manually. This could, in some
corner-cases lead to the deadlock.

lockdep validator reported this as,

        CPU0                    CPU1
        ----                    ----
   lock(&chp->lock);
                                lock(kn->active#43);
                                lock(&chp->lock);
   lock((wq_completion)cio);

The chp->lock was introduced to serialize the access of struct
channel_path. This lock is not needed for the css_wait_for_slow_path()
function, so invoke the slow-path function outside this lock.

Fixes: b730f3a93395 ("[S390] cio: add lock to struct channel_path")
Cc: <stable@vger.kernel.org>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/cio/chp.c  |    3 +++
 drivers/s390/cio/chsc.c |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -255,6 +255,9 @@ static ssize_t chp_status_write(struct d
 	if (!num_args)
 		return count;
 
+	/* Wait until previous actions have settled. */
+	css_wait_for_slow_path();
+
 	if (!strncasecmp(cmd, "on", 2) || !strcmp(cmd, "1")) {
 		mutex_lock(&cp->lock);
 		error = s390_vary_chpid(cp->chpid, 1);
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -801,8 +801,6 @@ int chsc_chp_vary(struct chp_id chpid, i
 {
 	struct channel_path *chp = chpid_to_chp(chpid);
 
-	/* Wait until previous actions have settled. */
-	css_wait_for_slow_path();
 	/*
 	 * Redo PathVerification on the devices the chpid connects to
 	 */


