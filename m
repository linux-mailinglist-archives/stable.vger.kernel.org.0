Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC445693697
	for <lists+stable@lfdr.de>; Sun, 12 Feb 2023 10:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBLJCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Feb 2023 04:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBLJCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Feb 2023 04:02:18 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A881285B;
        Sun, 12 Feb 2023 01:02:16 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id u10so6715855wmj.3;
        Sun, 12 Feb 2023 01:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o054lJq7cNJLgChzGzCQ+WRE1bzNAT5cBcRzDdFJomI=;
        b=BGNtl4F66FtklWTIE4ne2svwaooZ7g3z1KjWYUI6vGy7oJlAgTskn4ZdT80NCp4t/Z
         t/Be3c6mDsYRSbFB7QhWskI6msrJf35wznQIPeL/bxOEvmmEBfA1bqznthEMtepzz3Sf
         B01wfhs376EI0qTdI+yQ91d3fwKwYHIf4P4p7ZmLnZ8DM3VqU5D1vmgRPa5Tens3TYAM
         mcCZcFow4LsUJM+MS+CiXx7yJ+d5sgar6ErWPEtzOyCIK7P7BTfnbbU4Yb8zEnAgABPf
         F9DZxjJI+ENSU2x/8KUCCxawlx0uyHfQ4wj7v8T0jUMViSSuogZyvWGe9xM554NvggtV
         FmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o054lJq7cNJLgChzGzCQ+WRE1bzNAT5cBcRzDdFJomI=;
        b=oopOD7oD4sUS/ZC3ixRmkqgxmFyljKS3LQofd3AY/zMvIrJNiUzZrBrYxRLxvY4FA6
         c5hOOJG96iumC3A8bqHdsKcLRKxZvO6zmuL5RB2JNqQ39/H3hZGJM64fTz9FSzgSOWJf
         xCPr9mIVRh8Qm5OpbUCRqCQX+e/1AurXGM3ESrGaeK/Y6E0zBtQaNOZvqE16L1B8dh95
         R15g3uxc9yHryD7uQZVChQjSIGNeJqCkMPBBuU/RDY/85eMUHsFOWMxjE1jhXfhXmr20
         OHt+ghQJxJi68JGU72fpAb0AzYl5ncFqRYaskTh2MZ9hiHzmR0ckG5//6YP2ARh271gD
         ja1A==
X-Gm-Message-State: AO0yUKVI4bDckPysEwss+KxjrZAwP02xhS/d+J6je9NFAcd+qLmOxUdN
        KQ4FirT9nWUZt5LGuA3EhuI=
X-Google-Smtp-Source: AK7set+0sdObphmL7tZ+fdK1yIO/BppQpXtS3/wTcInpWjWoOAd3ibt9p2OnYK//N2kEpJ77sQQ1qQ==
X-Received: by 2002:a05:600c:1694:b0:3dc:5deb:40a0 with SMTP id k20-20020a05600c169400b003dc5deb40a0mr16808150wmn.8.1676192535306;
        Sun, 12 Feb 2023 01:02:15 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c450700b003dc42d48defsm12017183wmo.6.2023.02.12.01.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 01:02:14 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 5.10 0/2] Backport two overlayfs fixed to 5.10.y
Date:   Sun, 12 Feb 2023 11:02:02 +0200
Message-Id: <20230212090204.339226-1-amir73il@gmail.com>
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

These two patches have been (correctly) auto selected to 5.15.y
along with the two dependency patches tagged with:
Stable-dep-of: b306e90ffabd ("ovl: remove privs in ovl_copyfile()")
9636e70ee2d3 ("ovl: use ovl_copy_{real,upper}attr() wrappers")
a54843833caf ("ovl: store lower path in ovl_inode")

It wasn't wrong to apply those patches with the two dependencies
to 5.15.y, but it is not as easy to do for 5.10.y, so here is a
very simple backport of the two fixes to 5.10.y, i.e.:
replaced ovl_copyattr(X) with ovl_copyattr(ovl_inode_real(X), X).

Note that the language "This fixes some failure in fstests..."
in commit message means that those fixes are not enough for the
tests to pass. Additional backports from v6.2 are needed for the
tests to pass and I am collaborating those backports with Leah,
so they will hit 5.15.y first before posting them for 5.10.y.

Never the less, these overlayfs fixes are important security
fixes, so they should be applied to LTS kernel even before
all the cases in the fstests are fixed.

Thanks,
Amir.

Amir Goldstein (2):
  ovl: remove privs in ovl_copyfile()
  ovl: remove privs in ovl_fallocate()

 fs/overlayfs/file.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

-- 
2.34.1

