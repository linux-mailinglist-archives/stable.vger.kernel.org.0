Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2449ACA840
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390668AbfJCQYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390666AbfJCQYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:24:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3381E2054F;
        Thu,  3 Oct 2019 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119839;
        bh=+rMBaEag7aAOupdKm7Bl3aOSwArtbmDVv/fbkQoEaok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYCr+e1N3HpnTHdFMTe0ZToaWI5V2Nq8tDOTj9jTWCWohsLTA/aq8pWcJUZz9Blh9
         MDx+B65cWB9DUF2rzR3+r5M4Z7k/f9nBE3ZLyLJbIEvMw7yMotDoLdPRJ2XKpuhgXU
         yACV+XPjNl8hTsh4S60GXHzNdd6qd5++o24Qp59E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.19 196/211] md/raid6: Set R5_ReadError when there is read failure on parity disk
Date:   Thu,  3 Oct 2019 17:54:22 +0200
Message-Id: <20191003154529.214835592@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit 143f6e733b73051cd22dcb80951c6c929da413ce upstream.

7471fb77ce4d ("md/raid6: Fix anomily when recovering a single device in
RAID6.") avoids rereading P when it can be computed from other members.
However, this misses the chance to re-write the right data to P. This
patch sets R5_ReadError if the re-read fails.

Also, when re-read is skipped, we also missed the chance to reset
rdev->read_errors to 0. It can fail the disk when there are many read
errors on P member disk (other disks don't have read error)

V2: upper layer read request don't read parity/Q data. So there is no
need to consider such situation.

This is Reported-by: kbuild test robot <lkp@intel.com>

Fixes: 7471fb77ce4d ("md/raid6: Fix anomily when recovering a single device in RAID6.")
Cc: <stable@vger.kernel.org> #4.4+
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2573,7 +2573,9 @@ static void raid5_end_read_request(struc
 		    && !test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 			retry = 1;
 		if (retry)
-			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
+			if (sh->qd_idx >= 0 && sh->pd_idx == i)
+				set_bit(R5_ReadError, &sh->dev[i].flags);
+			else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
 				set_bit(R5_ReadError, &sh->dev[i].flags);
 				clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
 			} else


