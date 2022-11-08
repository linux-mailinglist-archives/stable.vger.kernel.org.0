Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C975562135A
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbiKHNtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiKHNtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:49:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82303F3A
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B119B81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FBFC433D6;
        Tue,  8 Nov 2022 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915367;
        bh=6N6aeMUQDpdIMBfKrN4ecT38Mmkyk64BTYq1vWwE6fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLPUO/DqvqAgJSVkOdKEmUCYGDyk5eTujUmH+uZ3IDyd8PldKKeyfpZUXA59FG3EU
         /67FRdetmTl4z0VeVqukAFwfPZ6Sh9KGMA2QQTVjZrLjPAeYEFk6xMXG/ShD63LXOT
         Y9h3p2igxYQrnGb7SeCNeUHWEPivM/UEbYIjvlN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 40/74] xfs: group quota should return EDQUOT when prj quota enabled
Date:   Tue,  8 Nov 2022 14:39:08 +0100
Message-Id: <20221108133335.375782856@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit c8d329f311c4d3d8f8e6dc5897ec235e37f48ae8 upstream.

Long ago, group & project quota were mutually exclusive, and so
when we turned on XFS_QMOPT_ENOSPC ("return ENOSPC if project quota
is exceeded") when project quota was enabled, we only needed to
disable it again for user quota.

When group & project quota got separated, this got missed, and as a
result if project quota is enabled and group quota is exceeded, the
error code returned is incorrectly returned as ENOSPC not EDQUOT.

Fix this by stripping XFS_QMOPT_ENOSPC out of flags for group
quota when we try to reserve the space.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans_dquot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -756,7 +756,8 @@ xfs_trans_reserve_quota_bydquots(
 	}
 
 	if (gdqp) {
-		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
+		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
+					(flags & ~XFS_QMOPT_ENOSPC));
 		if (error)
 			goto unwind_usr;
 	}


