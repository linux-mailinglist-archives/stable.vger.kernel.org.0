Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6253DCA5F4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392306AbfJCQiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392144AbfJCQiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3ACC20830;
        Thu,  3 Oct 2019 16:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120702;
        bh=apEfD4q9zyhxqB3xsHAa2NQ+UoWoYJIDYz+hdQ4OCN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dj3ZYgT4JvZBA69e3qoZv+2DV15m5ZWNui8pG1Ap3563UvmotZscqQxyfTKbKyPEc
         Fdb7U3fj5TiE6xOJBTq36beRLSSmEvkPFbrXm5vfB8RWVdthKtyHY+ZcxbuJdvewte
         gSEH6GySlVVUPtQ2vU4DvGokHoTCNJifTZ6//2Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.2 292/313] md/raid6: Set R5_ReadError when there is read failure on parity disk
Date:   Thu,  3 Oct 2019 17:54:30 +0200
Message-Id: <20191003154601.901780807@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
@@ -2559,7 +2559,9 @@ static void raid5_end_read_request(struc
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


