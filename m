Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBBE53CF16
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345416AbiFCRwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345872AbiFCRua (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201F65933F;
        Fri,  3 Jun 2022 10:46:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70EFC60A57;
        Fri,  3 Jun 2022 17:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E796C385A9;
        Fri,  3 Jun 2022 17:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278388;
        bh=zaNu4u8ZaPQGvMyvHFFFYGlt7YAl54KciriYinCwh/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqVVgDKRRraO8zsEVzG0d+ctJW6Z9gqqo9vlmU2UYNSKItrgHap7/Nr/J3VnGNNBv
         LayCk0rQlVksZ2jiCfxZBpfqgPBh8Lg40eseOGjOTvkQzqHPNXfD1dxD+ST8W9DNJi
         Ho701F1SUeC5ynvsNC6u4kUU5lc5GTt8lOXrxsXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 17/53] xfs: show the proper user quota options
Date:   Fri,  3 Jun 2022 19:43:02 +0200
Message-Id: <20220603173819.223798717@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
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

From: Kaixu Xia <kaixuxia@tencent.com>

commit 237d7887ae723af7d978e8b9a385fdff416f357b upstream.

The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
seems wrong, Fix it and show proper options.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -199,10 +199,12 @@ xfs_fs_show_options(
 		seq_printf(m, ",swidth=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
-	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, ",usrquota");
-	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, ",uqnoenforce");
+	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_UQUOTA_ENFD)
+			seq_puts(m, ",usrquota");
+		else
+			seq_puts(m, ",uqnoenforce");
+	}
 
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_PQUOTA_ENFD)


