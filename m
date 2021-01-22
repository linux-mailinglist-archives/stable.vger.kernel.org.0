Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F284300CA9
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbhAVSju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:39:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbhAVOSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:18:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4F9923A9C;
        Fri, 22 Jan 2021 14:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324849;
        bh=hRAZ9Q1bgx6FxIEL4fNMouM/bfBMQ1+VsNYdzbkgriM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQUkFKeptoIIQoA7dEWz7UKR8P83Xz6XmXczQr8ZaxpsEP3qX5+w1V9yJZ17KFd+w
         iEofooVoflwLb6Jm5cOrf+irzH0F7NglwTwY02EhaS+a+/3wCShXjK9Nv65SLbbw6K
         CHI3zBqwzpm965+i72AsUAyPPASGJ1QWOMsNSL8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nir Soffer <nsoffer@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 29/50] dm: eliminate potential source of excessive kernel log noise
Date:   Fri, 22 Jan 2021 15:12:10 +0100
Message-Id: <20210122135736.367237868@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 0378c625afe80eb3f212adae42cc33c9f6f31abf upstream.

There wasn't ever a real need to log an error in the kernel log for
ioctls issued with insufficient permissions. Simply return an error
and if an admin/user is sufficiently motivated they can enable DM's
dynamic debugging to see an explanation for why the ioctls were
disallowed.

Reported-by: Nir Soffer <nsoffer@redhat.com>
Fixes: e980f62353c6 ("dm: don't allow ioctls to targets that don't map to whole devices")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -472,7 +472,7 @@ static int dm_blk_ioctl(struct block_dev
 		 * subset of the parent bdev; require extra privileges.
 		 */
 		if (!capable(CAP_SYS_RAWIO)) {
-			DMWARN_LIMIT(
+			DMDEBUG_LIMIT(
 	"%s: sending ioctl %x to DM device without required privilege.",
 				current->comm, cmd);
 			r = -ENOIOCTLCMD;


