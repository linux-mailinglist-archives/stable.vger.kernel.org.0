Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141966354D8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbiKWJLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbiKWJLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:11:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2555587
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A19B6185C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CA9C433D7;
        Wed, 23 Nov 2022 09:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194677;
        bh=n0NW3gTG2p2nOkbjrhCJuQx4QvPExat8Ld2yX9bAP+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+i1Y9lq1zcL5VCnhzhBOmK6G6+AhpfwOSC3LKK2yGL39MKXtTrzUx4aq5i3xm5oe
         4/4bEYofMra3HB9O8B9OlXhvduU1JlAmQ3IXTpguiW8w275uULPkvamWNU7A5qv5I5
         cI7bMGdisCJD4Cw7W0iLl7MTLRL9NFgCfWbf5skg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 005/156] xfs: preserve inode versioning across remounts
Date:   Wed, 23 Nov 2022 09:49:22 +0100
Message-Id: <20221123084558.041330504@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

commit 4750a171c3290f9bbebca16c6372db723a4cfa3b upstream.

[ For 5.4.y, SB_I_VERSION should be set in xfs_fs_remount() ]

The MS_I_VERSION mount flag is exposed via the VFS, as documented
in the mount manpages etc; see the iversion and noiversion mount
options in mount(8).

As a result, mount -o remount looks for this option in /proc/mounts
and will only send the I_VERSION flag back in during remount it it
is present.  Since it's not there, a remount will /remove/ the
I_VERSION flag at the vfs level, and iversion functionality is lost.

xfs v5 superblocks intend to always have i_version enabled; it is
set as a default at mount time, but is lost during remount for the
reasons above.

The generic fix would be to expose this documented option in
/proc/mounts, but since that was rejected, fix it up again in the
xfs remount path instead, so that at least xfs won't suffer from
this misbehavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1228,6 +1228,10 @@ xfs_fs_remount(
 	char			*p;
 	int			error;
 
+	/* version 5 superblocks always support version counters. */
+	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+		*flags |= SB_I_VERSION;
+
 	/* First, check for complete junk; i.e. invalid options */
 	error = xfs_test_remount_options(sb, options);
 	if (error)


