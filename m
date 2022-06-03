Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F1553CFF0
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346065AbiFCR6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345966AbiFCR6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:58:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FA527152;
        Fri,  3 Jun 2022 10:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9006B823B0;
        Fri,  3 Jun 2022 17:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14ECC385B8;
        Fri,  3 Jun 2022 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278874;
        bh=EPBHgmukQQ2kavRRx6NFY8j/vcnjOWl5lgESjAPm9W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inUrWPpSPYFZEpZgCPwgLbwP6QP3dUj+OdRyiGVsWfxyMaDbYfAS8VAGyOaCgIbx3
         DkSCkGDpiFCy1fh3LTCr2CX1tA5NTAeoB6eMnLULcDGrCA9RcAxxF1XQNHVu+pFBDg
         33oYrJlIOdRLNytnAPiBYWGxp3Z5M2zULEDGoLgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        syzbot+1631f09646bc214d2e76@syzkaller.appspotmail.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kari Argillander <kari.argillander@stargateuniverse.net>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.17 54/75] fs/ntfs3: validate BOOT sectors_per_clusters
Date:   Fri,  3 Jun 2022 19:43:38 +0200
Message-Id: <20220603173823.273872316@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit a3b774342fa752a5290c0de36375289dfcf4a260 upstream.

When the NTFS BOOT sectors_per_clusters field is > 0x80, it represents a
shift value.  Make sure that the shift value is not too large before using
it (NTFS max cluster size is 2MB).  Return -EVINVAL if it too large.

This prevents negative shift values and shift values that are larger than
the field size.

Prevents this UBSAN error:

 UBSAN: shift-out-of-bounds in ../fs/ntfs3/super.c:673:16
 shift exponent -192 is negative

Link: https://lkml.kernel.org/r/20220502175342.20296-1-rdunlap@infradead.org
Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: syzbot+1631f09646bc214d2e76@syzkaller.appspotmail.com
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kari Argillander <kari.argillander@stargateuniverse.net>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/super.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -668,9 +668,11 @@ static u32 format_size_gb(const u64 byte
 
 static u32 true_sectors_per_clst(const struct NTFS_BOOT *boot)
 {
-	return boot->sectors_per_clusters <= 0x80
-		       ? boot->sectors_per_clusters
-		       : (1u << (0 - boot->sectors_per_clusters));
+	if (boot->sectors_per_clusters <= 0x80)
+		return boot->sectors_per_clusters;
+	if (boot->sectors_per_clusters >= 0xf4) /* limit shift to 2MB max */
+		return 1U << (0 - boot->sectors_per_clusters);
+	return -EINVAL;
 }
 
 /*
@@ -713,6 +715,8 @@ static int ntfs_init_from_boot(struct su
 
 	/* cluster size: 512, 1K, 2K, 4K, ... 2M */
 	sct_per_clst = true_sectors_per_clst(boot);
+	if ((int)sct_per_clst < 0)
+		goto out;
 	if (!is_power_of_2(sct_per_clst))
 		goto out;
 


