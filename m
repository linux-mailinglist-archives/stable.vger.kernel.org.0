Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D216085E2
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiJVHke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiJVHjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:39:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46C92BE883;
        Sat, 22 Oct 2022 00:37:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21F6FB82D9F;
        Sat, 22 Oct 2022 07:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74775C433D6;
        Sat, 22 Oct 2022 07:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424222;
        bh=armA+utm4/fRQ9XPab00JtG4j1S4Qjzm6rdXp+Ft1Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrnuaAKwKnmFiXEGjzDI7hlIBBON1kEW1LAUHickutdSRUhdavq2ZHXw038g8jvgc
         5ve65IAOtR0Q/7NyBLwFm7u3R6PJfr4lv4DpSgRFvHnlEprCbd9uJz5Ry0Dz2qygEL
         Bskp/frFfa4EjnUspUcnCwKEZwAfAqOsR/9YikVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 5.19 037/717] fs: dlm: handle -EBUSY first in lock arg validation
Date:   Sat, 22 Oct 2022 09:18:36 +0200
Message-Id: <20221022072421.703068835@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 44637ca41d551d409a481117b07fa209b330fca9 upstream.

During lock arg validation, first check for -EBUSY cases, then for
-EINVAL cases. The -EINVAL checks look at lkb state variables
which are not stable when an lkb is busy and would cause an
-EBUSY result, e.g. lkb->lkb_grmode.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2920,17 +2920,9 @@ static int set_unlock_args(uint32_t flag
 static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 			      struct dlm_args *args)
 {
-	int rv = -EINVAL;
+	int rv = -EBUSY;
 
 	if (args->flags & DLM_LKF_CONVERT) {
-		if (lkb->lkb_flags & DLM_IFL_MSTCPY)
-			goto out;
-
-		if (args->flags & DLM_LKF_QUECVT &&
-		    !__quecvt_compat_matrix[lkb->lkb_grmode+1][args->mode+1])
-			goto out;
-
-		rv = -EBUSY;
 		if (lkb->lkb_status != DLM_LKSTS_GRANTED)
 			goto out;
 
@@ -2940,6 +2932,14 @@ static int validate_lock_args(struct dlm
 
 		if (is_overlap(lkb))
 			goto out;
+
+		rv = -EINVAL;
+		if (lkb->lkb_flags & DLM_IFL_MSTCPY)
+			goto out;
+
+		if (args->flags & DLM_LKF_QUECVT &&
+		    !__quecvt_compat_matrix[lkb->lkb_grmode+1][args->mode+1])
+			goto out;
 	}
 
 	lkb->lkb_exflags = args->flags;


