Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0135407D2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347429AbiFGRw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349131AbiFGRud (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:50:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4FA13AF13;
        Tue,  7 Jun 2022 10:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C15BEB820C3;
        Tue,  7 Jun 2022 17:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290CBC34119;
        Tue,  7 Jun 2022 17:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623469;
        bh=OqZ1fM3XT7xiCBk1pwig0hnNmi/cqv4tqNiVLsVyCeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imLsQ7q6b/R+FiHpbDkJpe3RObs7lMMBOcLXmWRc1egr3d4QXfky/ZNsJQb4GInR3
         ZdFC3o154oWIgwmMUGycHCQnPdePPOYxsQfxBUiFZYQkYiqkaZ0DnfLM7I5U3q+qYp
         x673Og6/80RYJbc77UOPJ1EOizN6huHkZYlMgQFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeffrey Mitchell <jeffrey.mitchell@starlab.io>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 430/452] xfs: set inode size after creating symlink
Date:   Tue,  7 Jun 2022 19:04:47 +0200
Message-Id: <20220607164921.367417409@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>

commit 8aa921a95335d0a8c8e2be35a44467e7c91ec3e4 upstream.

When XFS creates a new symlink, it writes its size to disk but not to the
VFS inode. This causes i_size_read() to return 0 for that symlink until
it is re-read from disk, for example when the system is rebooted.

I found this inconsistency while protecting directories with eCryptFS.
The command "stat path/to/symlink/in/ecryptfs" will report "Size: 0" if
the symlink was created after the last reboot on an XFS root.

Call i_size_write() in xfs_symlink()

Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_symlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -300,6 +300,7 @@ xfs_symlink(
 		}
 		ASSERT(pathlen == 0);
 	}
+	i_size_write(VFS_I(ip), ip->i_d.di_size);
 
 	/*
 	 * Create the directory entry for the symlink.


