Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AE453CF9C
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345802AbiFCRzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346589AbiFCRvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:51:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B1A5713A;
        Fri,  3 Jun 2022 10:48:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A90B960F4E;
        Fri,  3 Jun 2022 17:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B257FC385A9;
        Fri,  3 Jun 2022 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278526;
        bh=Lht8QSy6hA4TSjRiwmuGl45bCsuNlAPJMnkNYDOgl4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwYyg7s9S9Kfs5oLQvNc+RPngBKYkNXqdz4iOBRi51f5b/dV8rIsrXcM66j5Hlqk2
         eGf5ZYBHXyDVhRmPvJLzXM5v7UTftVxZN4q2tz3fjxeJ1kHvJUUvyk35Y8wibw0Ilk
         dbHKq1gxqDG+bZ/qpWNSyiKM3/G+oQ/66W0I6Dps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zlang@redhat.com,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 18/53] xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
Date:   Fri,  3 Jun 2022 19:43:03 +0200
Message-Id: <20220603173819.252657254@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5336d6bb2d02d0e9d4d3c8be04b80b8b68d56c8 upstream.

In commit 27c14b5daa82 we started tracking the last inode seen during an
inode walk to avoid infinite loops if a corrupt inobt record happens to
have a lower ir_startino than the record preceeding it.  Unfortunately,
the assertion trips over the case where there are completely empty inobt
records (which can happen quite easily on 64k page filesystems) because
we advance the tracking cursor without actually putting the empty record
into the processing buffer.  Fix the assert to allow for this case.

Reported-by: zlang@redhat.com
Fixes: 27c14b5daa82 ("xfs: ensure inobt record walks always make forward progress")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iwalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -363,7 +363,7 @@ xfs_iwalk_run_callbacks(
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
+	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)


