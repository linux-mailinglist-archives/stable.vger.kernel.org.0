Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA23585B53
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 19:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiG3REU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 13:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiG3RES (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 13:04:18 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC60C13F13
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:16 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id uj29so261347ejc.0
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=B31yp5HrqQfF3VRGD5Wrcmr67pfl+9rfFAgsGACrSZQ=;
        b=m2Qa/ikj+3Pcvf323EkxUsYIHZ3k8ne/fk4JWJ+OJyKGnb/5jbO/UPVFDZMr6K92af
         bgaLl0zMktgWPOcB+CGaQlGzkbuiGFoH66JGFoUgtrbC8t5JCQi5Q/v6q5/3hffRT7X8
         xmFQCqjo/whdBDRDLk0ceJ9xWAtAS+mLQhAoDlZR9baZ8LiAtu4yG1Yu1qOYNZjtTbYF
         hg9F4Q9SborNKEkX/HrWfTeiAD4RlMeH0/GhvmcDLKCdw2hOH+Z9jysb9m7heyuD63GL
         ws2h5v9w1hTTl7RVtT6JhITlyYE2QeM9qQtLVUJc/MVHag84QX2g/j57oUlrA+wWZPXQ
         jP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=B31yp5HrqQfF3VRGD5Wrcmr67pfl+9rfFAgsGACrSZQ=;
        b=X0MLHxqWdUbZuNJ6LGctuK8qtZxuF3MQV51rySaMIBKPnqN8+wrJ1PYtA/KIpuErlH
         VNKBkCbhmgpMZM3vJcU/PW6hByVR9p4MRicCL9zynF7tNI8VwInhYtKzVDF2mTdUPmVF
         NtGQihy0o73Kjxibq6nRCgvSrVOyoijNzku2y+qOMjLitg3FjGWnzaIKWXO00rHILpLm
         bsXRq1Iqr8Viu1KlxHy5inl5BdqWDR/YlJ0+BUs+tkJWrBw3MHHWxFkNEOKDb5Tfo4E0
         74I1quO10er7XAnosLTod+YTKMq8kBcCvA/RDUII/1a7OVhIzRGl+a7fnWMz5llYbsfB
         cr3A==
X-Gm-Message-State: AJIora9l6Av+eecyZt9nvGntbTkQ+mAslwNcKzFg6nXnVV9IiWuQSNLE
        I+DeEtSL9TY9M+CPsQEOYgssL771rcy7Og==
X-Google-Smtp-Source: AGRyM1tYxknpiE0TTD90Xk4t3NsZkhshfd8Yce9bG+mVJJOzgwDLQv0GR3fwuZp9/WwS92TvxawKZQ==
X-Received: by 2002:a17:906:9b14:b0:72b:7c6f:2e87 with SMTP id eo20-20020a1709069b1400b0072b7c6f2e87mr6651890ejc.643.1659200655534;
        Sat, 30 Jul 2022 10:04:15 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af2fc300f82d90934ef08f18.dip0.t-ipconnect.de. [2003:f6:af2f:c300:f82d:9093:4ef0:8f18])
        by smtp.googlemail.com with ESMTPSA id b8-20020aa7c908000000b0043af8007e7fsm4101868edt.3.2022.07.30.10.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 10:04:14 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 0/6] Convert isec->lock into a spinlock fixing deadlock on GFS2
Date:   Sat, 30 Jul 2022 19:03:37 +0200
Message-Id: <20220730170343.11477-1-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patchset backports basically upstream commit 9287aed2
(selinux: Convert isec->lock into a spinlock). This
"fixes a deadlock between selinux and GFS2 when GFS2 invalidates a security label",
see the original discussion at
https://lore.kernel.org/all/1478812710-17190-2-git-send-email-agruenba@redhat.com/T/
It also contains the follow-up fixes to make this correct.

The first 3 commits (by Andreas) are valuable on their own too as
they fix a documentation bug, avoid partially initialized structs
and (slightly) improve performance while making the code cleaner.

Andreas Gruenbacher (4):
  selinux: Minor cleanups
  proc: Pass file mode to proc_pid_make_inode
  selinux: Clean up initialization of isec->sclass
  selinux: Convert isec->lock into a spinlock

Paul Moore (1):
  selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling

Tianyue Ren (1):
  selinux: fix error initialization in inode_doinit_with_dentry()

 fs/proc/base.c                    |  23 +++---
 fs/proc/fd.c                      |   6 +-
 fs/proc/internal.h                |   2 +-
 fs/proc/namespaces.c              |   3 +-
 security/selinux/hooks.c          | 123 +++++++++++++++++++-----------
 security/selinux/include/objsec.h |   5 +-
 security/selinux/selinuxfs.c      |   4 +-
 7 files changed, 96 insertions(+), 70 deletions(-)

-- 
2.25.1

