Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51856BF949
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCRKPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjCRKPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:39 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D539234CE;
        Sat, 18 Mar 2023 03:15:37 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so4726302wmq.1;
        Sat, 18 Mar 2023 03:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=auw9Bjm4gCLE/eVanEdZ+kImILmnXZOboNPQLAKXOn4=;
        b=RsZGDmiXqai4Xx0+iewRMdWV6WVMW7qu4pfnE422sN8cnxyY/85LJbQt26iJW594FQ
         S1rMEO4jcgWrjhZoVyqi4mP5fUIU0VyPr51KnJKSIZVu9I3wddbb3N3Y3K6g8eDcZiyl
         bcQ7IbmvcLE8UL5ejJ5QNyyLMgrdOr0IEdI9HSwpUmsc/F5B0PyYAqU8dEunTb7vIidW
         tCHpCugXdL9B5Hdq/llrVC43KfRlzXDtbOC1LlbPPI4vSahFldk1Ysj6EZ9nSEspi6PB
         zG+JeQ7hoj0GZvH+1DoIq23dpX9ogLd3RP9P5QmVWdwPUC3cn7R9yjfvV4SW5/yBIJTf
         +GBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=auw9Bjm4gCLE/eVanEdZ+kImILmnXZOboNPQLAKXOn4=;
        b=36KoMVk2S4D8e0EcfPhSBjlKBQeqAmOslxlo7niTpJRgwc7o53XsE6OyrVuOjyKyKc
         HbGgDlxa3gR2z/+hc6lFvMPk8nPLG8ejQ8qrNZ7Hc7R+2SOF+mOuN7ADCANc/lsfz5C6
         KH+CWbjv3H7IQ4KryE1PtfZaPWtJ0fUVYX+4cyYN58ZdQGOzkzbluHoVV1awrHAkSs3h
         PV29JnK6dROHqLpf1aPSINN6PoXD8tNrRLd4kE04xCb/EDyCQEyvYbebc2fwtARj+4Nz
         CJKzZY2YWPAOmvUj9LZE2AokhmJWXaW8reAcDNBZjVUbz4SUzbbr4xK1sRT25gY3LYdj
         ksQQ==
X-Gm-Message-State: AO0yUKUTela/Mg219F4srO1hsibiicC6hbdjDNvPKB/Z5LY0dh8LktM3
        NoXEDPIdCrHQNSz79Wi+HVE=
X-Google-Smtp-Source: AK7set/HBHHQ9+doLuxTNYp7PrveT7wTG6L/IoeE4N0lHBGWKhAUoX4keWv6XUbHYQ9WaCrN4ksPGw==
X-Received: by 2002:a7b:c5d7:0:b0:3ed:5eed:5581 with SMTP id n23-20020a7bc5d7000000b003ed5eed5581mr4848466wmk.2.1679134535585;
        Sat, 18 Mar 2023 03:15:35 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:35 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 5.10 00/15] xfs backports for 5.10.y (from v5.15.103)
Date:   Sat, 18 Mar 2023 12:15:14 +0200
Message-Id: <20230318101529.1361673-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

Following backports catch up with recent 5.15.y xfs backports.

Patches 1-3 are the backports from the previous 5.15 xfs backports
round that Chandan requested for 5.4 [1].

Patches 4-14 are the SGID fixes that I collaborated with Leah [2].
Christian has reviewed the backports of his vfs patches to 5.10.

Patch 15 is a fix for a build warning caused by one of the SGID fixes
that you applied to 5.15.y.

This series has gone through the usual xfs test/review routine.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/874jrtzlgp.fsf@debian-BULLSEYE-live-builder-AMD64/
[2] https://lore.kernel.org/linux-xfs/20230307185922.125907-1-leah.rumancik@gmail.com/

Amir Goldstein (4):
  attr: add in_group_or_capable()
  fs: move should_remove_suid()
  attr: add setattr_should_drop_sgid()
  attr: use consistent sgid stripping checks

Christian Brauner (1):
  fs: use consistent setgid checks in is_sxid()

Darrick J. Wong (3):
  xfs: purge dquots after inode walk fails during quotacheck
  xfs: don't leak btree cursor when insrec fails after a split
  xfs: use setattr_copy to set vfs inode attributes

Dave Chinner (4):
  xfs: don't assert fail on perag references on teardown
  xfs: remove XFS_PREALLOC_SYNC
  xfs: fallocate() should call file_modified()
  xfs: set prealloc flag in xfs_alloc_file_space()

Gaosheng Cui (1):
  xfs: remove xfs_setattr_time() declaration

Yang Xu (2):
  fs: add mode_strip_sgid() helper
  fs: move S_ISGID stripping into the vfs_*() helpers

 Documentation/trace/ftrace.rst |  2 +-
 fs/attr.c                      | 70 ++++++++++++++++++++++++++---
 fs/inode.c                     | 80 +++++++++++++++++++---------------
 fs/internal.h                  |  6 +++
 fs/namei.c                     | 80 ++++++++++++++++++++++++++++------
 fs/ocfs2/file.c                |  4 +-
 fs/ocfs2/namei.c               |  1 +
 fs/open.c                      |  6 +--
 fs/xfs/libxfs/xfs_btree.c      |  8 ++--
 fs/xfs/xfs_bmap_util.c         |  9 ++--
 fs/xfs/xfs_file.c              | 24 +++++-----
 fs/xfs/xfs_iops.c              | 56 ++----------------------
 fs/xfs/xfs_iops.h              |  1 -
 fs/xfs/xfs_mount.c             |  3 +-
 fs/xfs/xfs_pnfs.c              |  9 ++--
 fs/xfs/xfs_qm.c                |  9 +++-
 include/linux/fs.h             |  5 ++-
 17 files changed, 229 insertions(+), 144 deletions(-)

-- 
2.34.1

