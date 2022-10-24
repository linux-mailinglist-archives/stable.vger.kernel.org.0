Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BDB60A543
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbiJXMWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbiJXMUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:20:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C136583236;
        Mon, 24 Oct 2022 04:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 683FE612BB;
        Mon, 24 Oct 2022 11:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A895C433C1;
        Mon, 24 Oct 2022 11:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612592;
        bh=7zRqFiuFdqs1g1fTMewFg4NAJ0rlLykQuJxkC+KCfFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFz0445FVYz7U9AzR/vpK7so8OjXaqNUjSW3m8Vc18gCnvWjRbMFC4wEa9dd/6FUO
         PFJrvxF/1UeWGo1IzIIiOgFDfujYMjcbjd3Ui27jQuteg+Fl5ufW8ehBmCHNm/ijKp
         zmww03ZhSftMBIBucEf/QoIOHDILKgDM9Ic1C2uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 4.19 045/229] fs: dlm: handle -EBUSY first in lock arg validation
Date:   Mon, 24 Oct 2022 13:29:24 +0200
Message-Id: <20221024113000.552249834@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 fs/dlm/lock.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2890,24 +2890,24 @@ static int set_unlock_args(uint32_t flag
 static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 			      struct dlm_args *args)
 {
-	int rv = -EINVAL;
+	int rv = -EBUSY;
 
 	if (args->flags & DLM_LKF_CONVERT) {
-		if (lkb->lkb_flags & DLM_IFL_MSTCPY)
+		if (lkb->lkb_status != DLM_LKSTS_GRANTED)
 			goto out;
 
-		if (args->flags & DLM_LKF_QUECVT &&
-		    !__quecvt_compat_matrix[lkb->lkb_grmode+1][args->mode+1])
+		if (lkb->lkb_wait_type)
 			goto out;
 
-		rv = -EBUSY;
-		if (lkb->lkb_status != DLM_LKSTS_GRANTED)
+		if (is_overlap(lkb))
 			goto out;
 
-		if (lkb->lkb_wait_type)
+		rv = -EINVAL;
+		if (lkb->lkb_flags & DLM_IFL_MSTCPY)
 			goto out;
 
-		if (is_overlap(lkb))
+		if (args->flags & DLM_LKF_QUECVT &&
+		    !__quecvt_compat_matrix[lkb->lkb_grmode+1][args->mode+1])
 			goto out;
 	}
 


