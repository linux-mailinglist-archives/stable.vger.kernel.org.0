Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433CC28A32
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387840AbfEWTKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387856AbfEWTKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:10:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9EBE217F9;
        Thu, 23 May 2019 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638632;
        bh=0D88UvO96Hn6AhyrU3yhZb7Dg41+V1T3SbFwfnb7Or8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/6ssMCmGUtqMYE8Iny2HTwHvzXCuGfOTSycBKDAuHKCSvjL+b44r9MY0VqHmhZMr
         FCX9tEYZgGyxf/b30K9zxqyrL3kgrj/+LvmHc6BE51IHjWDTmZdF7EY4x5hwDz48g5
         kjFal7gu+tOG3TsSuJ6l4YQ6jW8j/HY6clrNOU20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Nigel Croxon <ncroxon@redhat.com>, Xiao Ni <xni@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.9 51/53] Revert "Dont jump to compute_result state from check_result state"
Date:   Thu, 23 May 2019 21:06:15 +0200
Message-Id: <20190523181719.050494805@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

commit a25d8c327bb41742dbd59f8c545f59f3b9c39983 upstream.

This reverts commit 4f4fd7c5798bbdd5a03a60f6269cf1177fbd11ef.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Nigel Croxon <ncroxon@redhat.com>
Cc: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3914,15 +3914,26 @@ static void handle_parity_checks6(struct
 	case check_state_check_result:
 		sh->check_state = check_state_idle;
 
-		if (s->failed > 1)
-			break;
 		/* handle a successful check operation, if parity is correct
 		 * we are done.  Otherwise update the mismatch count and repair
 		 * parity if !MD_RECOVERY_CHECK
 		 */
 		if (sh->ops.zero_sum_result == 0) {
-			/* Any parity checked was correct */
-			set_bit(STRIPE_INSYNC, &sh->state);
+			/* both parities are correct */
+			if (!s->failed)
+				set_bit(STRIPE_INSYNC, &sh->state);
+			else {
+				/* in contrast to the raid5 case we can validate
+				 * parity, but still have a failure to write
+				 * back
+				 */
+				sh->check_state = check_state_compute_result;
+				/* Returning at this point means that we may go
+				 * off and bring p and/or q uptodate again so
+				 * we make sure to check zero_sum_result again
+				 * to verify if p or q need writeback
+				 */
+			}
 		} else {
 			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))


