Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54662F9F4B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390900AbhARMRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390890AbhARLqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D5022CAD;
        Mon, 18 Jan 2021 11:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970361;
        bh=eh37vBK/QoU/gRomYdWbpLwpjD66ZvEc13ytn5+JEPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU1mGYauSosXs85CCm1XP+vFXD49XKa6O8H9XFBMz/m9swUtz2KQzPBNv7OEXVBW3
         y3CO9X0apVWnA806Z3v62hPTpFX5KalU4yAZGf0nlE7275vYkfniMr6IuQ2K6LkskW
         b9jUu3BxNwhc21SATXcTZdYxwOgPPehBPTFTi01s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nir Soffer <nsoffer@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 148/152] dm: eliminate potential source of excessive kernel log noise
Date:   Mon, 18 Jan 2021 12:35:23 +0100
Message-Id: <20210118113359.819697529@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
@@ -562,7 +562,7 @@ static int dm_blk_ioctl(struct block_dev
 		 * subset of the parent bdev; require extra privileges.
 		 */
 		if (!capable(CAP_SYS_RAWIO)) {
-			DMWARN_LIMIT(
+			DMDEBUG_LIMIT(
 	"%s: sending ioctl %x to DM device without required privilege.",
 				current->comm, cmd);
 			r = -ENOIOCTLCMD;


