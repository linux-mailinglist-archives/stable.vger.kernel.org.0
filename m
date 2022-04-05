Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9B44F39DF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378821AbiDELjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354039AbiDEKLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:11:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D294EA1A;
        Tue,  5 Apr 2022 02:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 35FB9CE1BE5;
        Tue,  5 Apr 2022 09:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566ABC385A1;
        Tue,  5 Apr 2022 09:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152608;
        bh=PbV5wxgMko22JDT+Md8rh80dJkT2IJIkzQU8ns9NEAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+nlfqOURw07MsspDdouYQgF1x1jZSlcHvNSJIK1Mxcx7V6A8VZCQH+ch7uAxNQ3i
         7elKeL4ksaW/OF2ZBxLg20RsbKx5w5/AEGrwlyyelBN2P7m7Jbm1G0jJn+ECyDVqWS
         zcSO7xj7vtRkcbGHZXZ7iEIYBlidg+lGLs6tbwSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Price <anprice@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.15 839/913] gfs2: Make sure FITRIM minlen is rounded up to fs block size
Date:   Tue,  5 Apr 2022 09:31:41 +0200
Message-Id: <20220405070404.979661211@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Price <anprice@redhat.com>

commit 27ca8273fda398638ca994a207323a85b6d81190 upstream.

Per fstrim(8) we must round up the minlen argument to the fs block size.
The current calculation doesn't take into account devices that have a
discard granularity and requested minlen less than 1 fs block, so the
value can get shifted away to zero in the translation to fs blocks.

The zero minlen passed to gfs2_rgrp_send_discards() then allows
sb_issue_discard() to be called with nr_sects == 0 which returns -EINVAL
and results in gfs2_rgrp_send_discards() returning -EIO.

Make sure minlen is never < 1 fs block by taking the max of the
requested minlen and the fs block size before comparing to the device's
discard granularity and shifting to fs blocks.

Fixes: 076f0faa764ab ("GFS2: Fix FITRIM argument handling")
Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/rgrp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1428,7 +1428,8 @@ int gfs2_fitrim(struct file *filp, void
 
 	start = r.start >> bs_shift;
 	end = start + (r.len >> bs_shift);
-	minlen = max_t(u64, r.minlen,
+	minlen = max_t(u64, r.minlen, sdp->sd_sb.sb_bsize);
+	minlen = max_t(u64, minlen,
 		       q->limits.discard_granularity) >> bs_shift;
 
 	if (end <= start || minlen > sdp->sd_max_rg_data)


