Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E4A28916
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391902AbfEWTan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391044AbfEWTam (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCDA2206BA;
        Thu, 23 May 2019 19:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639842;
        bh=0+FMZ+ewi22YLZs+nmDi4kl7PdV+y8/QWHfucQQnit0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpPtoR3Gj6ZA310ta6sZpVr0DtXq38PjBAK7W66pN4RYpi3LjddJSdmrH7PzQ9AnW
         1X03ib5BYFiqcIOrNd8dMqoaeEhdaKanX9a1uyCMZtfTplKGI3DsuZzbBpGPwZ7zL5
         Spm1/oZzjpKOJ4mV+h9L/To3VWZXCUWPmiNbacNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Nigel Croxon <ncroxon@redhat.com>, Xiao Ni <xni@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.1 112/122] Revert "Dont jump to compute_result state from check_result state"
Date:   Thu, 23 May 2019 21:07:14 +0200
Message-Id: <20190523181720.293820308@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
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
@@ -4223,15 +4223,26 @@ static void handle_parity_checks6(struct
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
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {


