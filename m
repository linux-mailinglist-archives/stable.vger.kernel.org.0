Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C378513F41
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 01:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353425AbiD2ACb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 20:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiD2AC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 20:02:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D0BA146B
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b12-20020a056902030c00b0061d720e274aso5998213ybs.20
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zAY11kRcY66zSxhpVQX/q9oPTivyh5TfNYxMuCdOw+k=;
        b=LPn0801gU0l3ZtqyVjEyXPWhPJF3MqjgaxOWKY5cCYlPIkiOFownoMVm2h93n2ix8O
         Tb00mRnMGKnu9s2tOsxc/Ahpa2/ZmvZTG53zoYbx/8U6Mw6GBz+cqZi/V8TSV797+cRv
         xaAcrq9tEpk7rzFjNbZMyHCGJVNN7JqpUJy0HyC7tL3Ab2OO1qhEMSKGcrQk0aULXU7U
         LvZhxG9bKPe7sRjl6r51dgbrTzFTKAo6qN6eDx/8sz0QC4dxssyEkBWTGbSUqUJmb6U8
         S6dSm9d63WSG9kVGM/HWgXSkVEwXo5OgQlgFGYkCusXs2hXO83BBzbu8kjoLBJ+moB6P
         vTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zAY11kRcY66zSxhpVQX/q9oPTivyh5TfNYxMuCdOw+k=;
        b=l+c4KqiIdfZLiaAUBQRgwX4lJHq8YtM9Q3S8RU/9mrIMsOPX49jqFlVh9K8uiOWgrh
         x9nyRkw9aDAZ6qIVKpYpnHFexZvpPvgjrrlrJ8ZI3rD+lSLgk0lqQ7iURUrhd3uotKAm
         qhHntprJU8xAV6dMsMPNFOL0hD9WbIHlHJLuZOOg7dAePEyCZn2MUrcs85SX6iUalNHC
         vPIfS8026Qmt2b/N1MWkqypogk9fGZSNXP3F6OSowZWG8vn4mrqU9smqyvUnE4hCsE+f
         dBY1fjXs6T9RLuODgcJro9RHlPDZNFJUzjGHwwTnlS3GsYYx/MPUi6Fk4/O63E/psrnL
         YSlA==
X-Gm-Message-State: AOAM531Xbjiux0NcaCsxcuxt5BN41+GTRsdQ1dLzH3zzlKtt7YueQ4o8
        muXnmxn/PJ+9fyRmhvUvXTS3+N17GTE=
X-Google-Smtp-Source: ABdhPJwFt31ODXzGu5O3Zg+N0JxAyhDzZjZv00HzQz88MxXDfAGUVXiWhklpBO888Gnz4zfMWXtJJK3s4C4=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:25cd:1665:36bc:f38e])
 (user=haoluo job=sendgmr) by 2002:a5b:483:0:b0:634:dd7:9569 with SMTP id
 n3-20020a5b0483000000b006340dd79569mr33282868ybp.214.1651190352237; Thu, 28
 Apr 2022 16:59:12 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:57:41 -0700
Message-Id: <20220428235751.103203-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH stable linux-5.15.y 00/10] Fix bpf mem read/write vulnerability.
From:   Hao Luo <haoluo@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please cherry-pick this patch series into 5.15.y stable. It
includes a feature that fixes CVE-2022-0500 which allows a user with
cap_bpf privileges to get root privileges. The patch that fixes
the bug is

 patch 7/10: bpf: Make per_cpu_ptr return rdonly

The rest are the depedences required by the fix patch. Note that v5.10 and
below are not affected by this bug.

This patchset has been merged in mainline v5.17 and backported to v5.16[1],
except patch 10/10 ("bpf: Fix crash due to out of bounds access into reg2btf_ids."),
which fixes an out-of-bound access in the main feature in this series and
hasn't been backported to v5.16 yet. If it's convenient, could you
apply patch 10/10 to 5.16? I can send a separate patch for v5.16, if you
prefer.

Tested by compile, build and run through the bpf selftest test_progs.

[1] https://www.spinics.net/lists/stable/msg535877.html

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

Kumar Kartikeya Dwivedi (1):
  bpf: Fix crash due to out of bounds access into reg2btf_ids.

 include/linux/bpf.h                           | 101 +++-
 include/linux/bpf_verifier.h                  |  18 +
 kernel/bpf/btf.c                              |  16 +-
 kernel/bpf/cgroup.c                           |   2 +-
 kernel/bpf/helpers.c                          |  12 +-
 kernel/bpf/map_iter.c                         |   4 +-
 kernel/bpf/ringbuf.c                          |   2 +-
 kernel/bpf/syscall.c                          |   2 +-
 kernel/bpf/verifier.c                         | 488 +++++++++---------
 kernel/trace/bpf_trace.c                      |  22 +-
 net/core/bpf_sk_storage.c                     |   2 +-
 net/core/filter.c                             |  64 +--
 net/core/sock_map.c                           |   2 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |  14 +
 .../bpf/progs/test_ksyms_btf_write_check.c    |  29 ++
 15 files changed, 445 insertions(+), 333 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c

-- 
2.36.0.464.gb9c8b46e94-goog

