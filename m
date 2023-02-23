Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567316A0CBE
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 16:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBWPUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 10:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjBWPUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 10:20:53 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36012570A6;
        Thu, 23 Feb 2023 07:20:52 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m25-20020a7bcb99000000b003e7842b75f2so6708762wmi.3;
        Thu, 23 Feb 2023 07:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JzZjy1clNiLNf9VI8jvQcHFW+lmCWTyvYELzQDef+bM=;
        b=e8Vna5dBYtpUNDXEjm54j/z21HPqUZ5RYPWKCZz0ARWh5RWZx0jlhtfFHGsWff5Dg9
         NlLP2N00dybVzYGYoCLU7xXexIi9edZwfjspCWzLztv1NTNkBZ4aBTrB2t5PjSWgVgnt
         rp/I9eRcqB2+KPkAb0gOtVcg56IQgih2zFfv3HfkWjzuEdlEkkQqSegXf5PJ8/fe3pZN
         QtTKfkuacIJYOppNBM8roa7vvTGDbhtGKSSO8s5v8hoto8slsIOsx/uCn/dcL/q+gXCA
         s+H2MjxqYBWZmU5li75isBpqh4d7wqSvKqBAZ6ZtnOc2Wo1cFgO3CuV6NkDTgQFfU0HP
         N8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JzZjy1clNiLNf9VI8jvQcHFW+lmCWTyvYELzQDef+bM=;
        b=qf39IVvAhmrQV1zrhXkU6qVOLAYkCY5D1oVvNK62bdzLU5wOJT1t8Cha0t8qwfvaU6
         m+C279MqQOcXOhxln+cwvL4t0lspXh0YnN7blEJq0zYWKbx16UDvQBqqN+nry50GBh4H
         cKSIomsvJHX/ixRnsSFondg+IfoX/y9c1Bponsevi3pIRsY/GSoKAOdb3ao9uil0Q5TS
         OOtnjCWq4PTXYZ544DRrOcSWMeK2w4W7ZUQAT06xmrcRJs8fza4W4vQk4O3yb5skxssb
         gQvZVyYKqkhh0kMH0Av/wwuXoKxQMr5bQbUwbRfQ04KlxVg5/OgfoIPpwiWD9HjHj1V1
         eDSw==
X-Gm-Message-State: AO0yUKXGiRqr/W9m9q1T8HrwZQmUuxZg1/MB7U+BKaxxQjb3I7zQoauH
        YJg6E47EPg3Dvlbs2wUFLJs=
X-Google-Smtp-Source: AK7set8/LSOx+u6y+RnZhh/skJpEhg6eYOXklJZGkNyxj+mTI6162El46H36SyyQYA+Vt0sJFAXz2Q==
X-Received: by 2002:a05:600c:3d95:b0:3e8:35a2:6abf with SMTP id bi21-20020a05600c3d9500b003e835a26abfmr6702708wmb.23.1677165650593;
        Thu, 23 Feb 2023 07:20:50 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d6289000000b002c56af32e8csm9372590wru.35.2023.02.23.07.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 07:20:50 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 6.1 0/5] Backport v6.2 SGID fixes to LTS 6.1
Date:   Thu, 23 Feb 2023 17:20:39 +0200
Message-Id: <20230223152044.1064909-1-amir73il@gmail.com>
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

Following are backports of Christian's SGID fixes that were merged to
v6.2-rc1.

Note that Christain's PR [1] contains also two ovl patches (from me).
Those two are independent fixes that have already been AUTOSELected
to 6.1.y.

Christain's fixes also contain a user observable change of behavior
to fix inconsistencies of behavior between chmod/chown and write.
This change is best described in Christain's commit to fix the expected
behavior in xfstests [2].

It is hoped that no applications rely on this minor behavioral
difference, and if we are wrong, we may need to party revert the
change, but in any case, we prefer the behavior of LTS kernels to be
consitent with that of upstream.

I ran the relevant fstests test groups on xfs and on overlayfs over xfs.

I also have backports that I prepared for 5.15 and 5.10, but those
backports include also xfs SGID fixes, so those need to go through the
xfs stable review process.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20221212112053.99208-1-brauner@kernel.org/
[2] https://lore.kernel.org/linux-fsdevel/20230103-fstests-setgid-v6-2-v3-1-5950c139bfcc@kernel.org/

Christian Brauner (5):
  attr: add in_group_or_capable()
  fs: move should_remove_suid()
  attr: add setattr_should_drop_sgid()
  attr: use consistent sgid stripping checks
  fs: use consistent setgid checks in is_sxid()

 Documentation/trace/ftrace.rst |  2 +-
 fs/attr.c                      | 74 +++++++++++++++++++++++++++++++---
 fs/fuse/file.c                 |  2 +-
 fs/inode.c                     | 64 +++++++++++++----------------
 fs/internal.h                  | 10 ++++-
 fs/ocfs2/file.c                |  4 +-
 fs/open.c                      |  8 ++--
 include/linux/fs.h             |  4 +-
 8 files changed, 115 insertions(+), 53 deletions(-)

-- 
2.34.1

