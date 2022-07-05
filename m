Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30411566BE4
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiGEMJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiGEMIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C695F18E2B;
        Tue,  5 Jul 2022 05:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6376661967;
        Tue,  5 Jul 2022 12:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2F0C341C7;
        Tue,  5 Jul 2022 12:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022879;
        bh=SJn9ehuval0y4TO7dS5awgimnWcbV+wKvBvAH46Ndvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oySB1icD7AVcBZrJR8nBgEAVTJuEfM+q5x/XZEsTApo/fGasLoDyl7qVYxmBif71Y
         Ihyt/yOUqNcIiJJCpuksyctLTi26HfpvXdzq9UXfh36DlshTHQHMdqPAK56iz/uoY5
         UD/UC/O8JiRB+osBJHKOfN3C0mqk72daF38nok3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 44/84] xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX
Date:   Tue,  5 Jul 2022 13:58:07 +0200
Message-Id: <20220705115616.609865501@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit b2c2974b8cdf1eb3ef90ff845eb27b19e2187b7e upstream.

Add the BUILD_BUG_ON to xfs_errortag_add() in order to make sure that
the length of xfs_errortag_random_default matches XFS_ERRTAG_MAX when
building.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_error.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -293,6 +293,8 @@ xfs_errortag_add(
 	struct xfs_mount	*mp,
 	unsigned int		error_tag)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
+
 	if (error_tag >= XFS_ERRTAG_MAX)
 		return -EINVAL;
 


