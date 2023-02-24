Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A226C6A1579
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 04:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjBXDkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 22:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjBXDkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 22:40:41 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7107C16317
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 19:40:40 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z19-20020a056a001d9300b005d8fe305d8bso2704663pfw.22
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 19:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X4tBb8bFIpeX5wNEM8VVQkPrbGhips7ogPU5rW+jMmE=;
        b=MRTJ0iVZokAOELH2wGD4Oi7UywejhX/CilHcDTB/6HYDiXo3dIQUxbnDNUdL4G7IIp
         jG/052PI7+n5eKGoe3+BHuLhUtLwSjFMgn2W6xTimnEovL6iS4rwzfO6navKK+MkTWyW
         9e/KcHzyNuKhtKbxmGNcKFXj6vi0wD1eePpHG23i7UzWZu18G0kFVRniq+HxwRbNeako
         DPZ6GIgcW1IEWU87D6acm6OI8vMtH8ypeDrbVr0QEGYN1rq991YwLfvAQpjvO1sHOBob
         xKf6rH+GLgcqTple26jLbnRFZJ/vZI4JWNvV66nXb7ODN9l0F0ivDOMdxuqmb7zDvypE
         GKHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X4tBb8bFIpeX5wNEM8VVQkPrbGhips7ogPU5rW+jMmE=;
        b=NC9dzGMJoVkAxAo9Bo9vecawEcRKgg3rY7BiNzOiwVQT66n1ETuNsOssLuuRYTzt/W
         A+AWP8mG1pCfYzwVHtd7noo4BNqQ6hYvLRROLQkNPxQxCR2N/3ms3khY8Ek+TI2OlC9/
         8VtoBiz84OllK4+YYpbz+LjFkmrAwJfe2MZDnS6fxDJzzH/TO0fTdqPd9Txe+ATghaG1
         G5ztQVcoq2PqZQKAn2ZiI4lMjWicOxxG74kF/+S88hRrPBGLu6vg6RBXiIer+DqvwrNa
         MJSol51CvqSqTi65GS8iclVeSR4icRkvKP4+kUEoo/m+evn/8FC0VWmwNqp1ln/kKTZT
         53Ew==
X-Gm-Message-State: AO0yUKUT8minLNY28yqY9GniyKopWamBcuBWNeQbWAb1kvRpVVBRxEgR
        +XLl9uWNhhEvE48B5u56M0UMnvnzKooLuRBqmbsj4rwtz9Z9MX9EUT+aRLb54JZyGeZsgc4a0u1
        B7inlWDJcHSF1NZ+BMaCPL7nlowrTgfvWed2/VtadLatKTCrgFQJfVmPLLtiQPw==
X-Google-Smtp-Source: AK7set9XAI/mo39xNg6NePeiOfMl922pN62XpgME1pxNmgVyCAkxmREMhiC4U1b5Zed1XteERjxQnzW4SDw=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a17:902:f811:b0:19a:f153:b73e with SMTP id
 ix17-20020a170902f81100b0019af153b73emr2433664plb.4.1677210039493; Thu, 23
 Feb 2023 19:40:39 -0800 (PST)
Date:   Fri, 24 Feb 2023 03:40:15 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224034020.2080637-1-edliaw@google.com>
Subject: [PATCH 4.14 v3 0/4] BPF fixes for CVE-2021-3444 and CVE-2021-3600
From:   Edward Liaw <edliaw@google.com>
To:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bpf@vger.kernel.org, kernel-team@android.com,
        Edward Liaw <edliaw@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thadeu Lima de Souza Cascardo originally sent this patch but it failed to
merge because of a compilation error:

https://lore.kernel.org/bpf/20210830183211.339054-1-cascardo@canonical.com/T/

v3:
Added upstream commit hash from 4.19.y and added detail to changelog.

v2:
Removed redefinition of tmp to fix compilation with CONFIG_BPF_JIT_ALWAYS_ON
enabled.

-Edward
 
==

The upstream changes necessary to fix these CVEs rely on the presence of JMP32,
which is not a small backport and brings its own potential set of necessary
follow-ups.

Daniel Borkmann, John Fastabend and Alexei Starovoitov came up with a fix
involving the use of the AX register.

This has been tested against the test_verifier in 4.14.y tree and some tests
specific to the two referred CVEs. The test_bpf module was also tested.

Daniel Borkmann (4):
  bpf: Do not use ax register in interpreter on div/mod
  bpf: fix subprog verifier bypass by div/mod by 0 exception
  bpf: Fix 32 bit src register truncation on div/mod
  bpf: Fix truncation handling for mod32 dst reg wrt zero

 include/linux/filter.h | 24 ++++++++++++++++++++++++
 kernel/bpf/core.c      | 39 ++++++++++++++-------------------------
 kernel/bpf/verifier.c  | 39 +++++++++++++++++++++++++++++++--------
 net/core/filter.c      |  9 ++++++++-
 4 files changed, 77 insertions(+), 34 deletions(-)


base-commit: a8ad60f2af5884921167e8cede5784c7849884b2
-- 
2.39.2.637.g21b0678d19-goog

