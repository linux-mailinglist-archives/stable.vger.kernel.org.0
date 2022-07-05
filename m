Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B23566BE7
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbiGEMJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbiGEMIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFD118345;
        Tue,  5 Jul 2022 05:08:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1994CE1B87;
        Tue,  5 Jul 2022 12:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16D5C341CB;
        Tue,  5 Jul 2022 12:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022888;
        bh=hoLSOmY0encCMcz8kriaTtmJ2l5lUCnPyPwV9DNXjwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EO3WomPOx4r2bh3AqJRzJWADdoZMQfntWhEfoM6owW3/2cNRoEzy4E3dSGb4zNpr2
         p8azuwiLB4t3qHyqyOdrJLFQY3PtyasnuiaW3U2jk64m80gKXrY+drGBsS4ykAqiPb
         /bmE1xqNz/v0nGDVjfpNx4ftL63fhlyqPiHE0Dy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 47/84] xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range
Date:   Tue,  5 Jul 2022 13:58:10 +0200
Message-Id: <20220705115616.699746148@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit d4f74e162d238ce00a640af5f0611c3f51dad70e upstream.

The final parameter of filemap_write_and_wait_range is the end of the
range to flush, not the length of the range to flush.

Fixes: 46afb0628b86 ("xfs: only flush the unshared range in xfs_reflink_unshare")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_reflink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1503,7 +1503,8 @@ xfs_reflink_unshare(
 	if (error)
 		goto out;
 
-	error = filemap_write_and_wait_range(inode->i_mapping, offset, len);
+	error = filemap_write_and_wait_range(inode->i_mapping, offset,
+			offset + len - 1);
 	if (error)
 		goto out;
 


