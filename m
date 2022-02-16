Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4814B9412
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 23:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiBPWw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 17:52:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbiBPWw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 17:52:28 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2846966C84
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:15 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i4-20020a25a0c4000000b00623ab738437so4715377ybm.0
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=11bmoLi3lBaCSEzOUSaR6rpCNb6z63oXPLO4+ECDNmw=;
        b=nqw6tmJ3xqc7YoT+o9cGsoA6hyJEy4SiphS86qCzFTJII+5fn5MBeRSDxe2zJavLR3
         4EMeAVF5MJQJyhVb+5+4i5UyCDogtyJ/DU//CvZVA9uYP/xH9C4PusYoGp0PcssghYv+
         45kqWo7LGh2iS4seyveoUyYggRZmON3sEfWZzN/t83Ksp0/CWUWxohAIK5RGigeL/fMj
         kl8kIO7uFcwZWOF+gxOnoXYC0Fnp+LgzGwUld83EnKthe4aL6wB9JH0aDk0iJ51wrkoi
         t6AHvuap2qsbimQQg59ZgPVKjZD0tWUAu7I2M60e22staokS5uBi5YhSMwP5GNmx7b0A
         gbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=11bmoLi3lBaCSEzOUSaR6rpCNb6z63oXPLO4+ECDNmw=;
        b=hwzPth/mpHXFLhgg/+IRIx4x9euU9fmXSayRChKCqyW5o7fZsWB9Quw/I8kxDMQhA0
         UgJ42+HZQhCPvor6o8p5tERwAcS6H3iy6zFptF42i4qfTYoAW+cO5AuHPhFsE/F9FrsH
         GypN/xvyUxOXViczV3ibKj0VxgCwKTQFfJsCRvcZlOzWUn7StAZ96JQQ7j/4KA4Im8e1
         tbwlJV7jVRIcNVFWvQrXsmGhuL31M2q0Cluqf0BsDSVtQFxpSJpZkmZukxEhAZurbQRh
         Nb4znnBFAxkuNcpxodwDctOQAh0aC7Da6AclKNVkcj2UCbWuK2N7iAex0E+uh04o1utz
         rC4Q==
X-Gm-Message-State: AOAM533i6uPGYQFwIuBaqniuPgVfDBKh1RkQuipsd/ZhzVTugRWacElD
        0CdsIMVNInJthR4Dbl+67oQPJ0MtRuc=
X-Google-Smtp-Source: ABdhPJwM/5hiUw1iNmw0M8PMbY5Mi+I7D+pnCCDEtituZyFh6QwRhItYykubaFFzwhHHI8l9vh3P5zXaXxg=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:6674:61c7:b01a:7f98])
 (user=haoluo job=sendgmr) by 2002:a25:3d87:0:b0:61e:170c:aa9 with SMTP id
 k129-20020a253d87000000b0061e170c0aa9mr107900yba.89.1645051934411; Wed, 16
 Feb 2022 14:52:14 -0800 (PST)
Date:   Wed, 16 Feb 2022 14:52:00 -0800
Message-Id: <20220216225209.2196865-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH stable linux-5.16.y 0/9] Fix bpf mem read/write vulnerability.
From:   Hao Luo <haoluo@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please consider cherry-pick this patch series into 5.16.x stable. It
includes a fix to a bug in 5.16 stable which allows a user with cap_bpf
privileges to get root privileges. The patch that fixes the bug is

 patch 7/9: bpf: Make per_cpu_ptr return rdonly

The rest are the depedences required by the fix patch. This patchset has
been merged in mainline v5.17. The patches were not planned to backport
because of its complex dependences.

Tested by compile, build and run through a subset of bpf test_progs.

Hao Luo (9):
  bpf: Introduce composable reg, ret and arg types.
  bpf: Replace ARG_XXX_OR_NULL with ARG_XXX | PTR_MAYBE_NULL
  bpf: Replace RET_XXX_OR_NULL with RET_XXX | PTR_MAYBE_NULL
  bpf: Replace PTR_TO_XXX_OR_NULL with PTR_TO_XXX | PTR_MAYBE_NULL
  bpf: Introduce MEM_RDONLY flag
  bpf: Convert PTR_TO_MEM_OR_NULL to composable types.
  bpf: Make per_cpu_ptr return rdonly PTR_TO_MEM.
  bpf: Add MEM_RDONLY for helper args that are pointers to rdonly mem.
  bpf/selftests: Test PTR_TO_RDONLY_MEM

 include/linux/bpf.h                           | 101 +++-
 include/linux/bpf_verifier.h                  |  17 +
 kernel/bpf/btf.c                              |  12 +-
 kernel/bpf/cgroup.c                           |   2 +-
 kernel/bpf/helpers.c                          |  12 +-
 kernel/bpf/map_iter.c                         |   4 +-
 kernel/bpf/ringbuf.c                          |   2 +-
 kernel/bpf/syscall.c                          |   2 +-
 kernel/bpf/verifier.c                         | 488 +++++++++---------
 kernel/trace/bpf_trace.c                      |  26 +-
 net/core/bpf_sk_storage.c                     |   2 +-
 net/core/filter.c                             |  64 +--
 net/core/sock_map.c                           |   2 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |  14 +
 .../bpf/progs/test_ksyms_btf_write_check.c    |  29 ++
 15 files changed, 444 insertions(+), 333 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c

-- 
2.35.1.265.g69c8d7142f-goog

