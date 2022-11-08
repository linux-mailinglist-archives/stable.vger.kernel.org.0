Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D962135B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiKHNtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbiKHNte (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:49:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83646348
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:49:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 969E6B81AEC
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E378AC433C1;
        Tue,  8 Nov 2022 13:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915371;
        bh=AOfRDHTtxtUFx0oy2V2GBgeSiERTNmLzFu70QqgIkp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A77ZWmHRJRVGxCwHhnT2AVGJw+u1Rb0JyXRgFxgBbPs+GDJLf6NUWnVjd55uBzSaA
         57schI3LLzwQQBluPGNmYADHKEw2Exmgeq3DgiRYzp1KUWqUq6vyRdrdHi5eJ9HK0R
         AIKVhg9HHhSmgdwK5/BwGWRKCnSEF+bNHvYIH6po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 41/74] xfs: dont fail unwritten extent conversion on writeback due to edquot
Date:   Tue,  8 Nov 2022 14:39:09 +0100
Message-Id: <20221108133335.414613955@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1edd2c055dff9710b1e29d4df01902abb0a55f1f upstream.

During writeback, it's possible for the quota block reservation in
xfs_iomap_write_unwritten to fail with EDQUOT because we hit the quota
limit.  This causes writeback errors for data that was already written
to disk, when it's not even guaranteed that the bmbt will expand to
exceed the quota limit.  Irritatingly, this condition is reported to
userspace as EIO by fsync, which is confusing.

We wrote the data, so allow the reservation.  That might put us slightly
above the hard limit, but it's better than losing data after a write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -789,7 +789,7 @@ xfs_iomap_write_unwritten(
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS);
+				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
 		if (error)
 			goto error_on_bmapi_transaction;
 


