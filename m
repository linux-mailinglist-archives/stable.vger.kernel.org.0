Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4337C69FC27
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 20:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbjBVT3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 14:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjBVT3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 14:29:39 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14EB2BF1D
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 11:29:35 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id mi5-20020a17090b4b4500b0022bef1f49c9so1261686pjb.0
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 11:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tb0ueiuCZhmbeIOxA4XRuKzb5t2VG1idqa+l+pQwN8Q=;
        b=hCXHaAtr3aCglfF51Fdf5bTd3Izd+PFay0PDuNAXSeiP3c3nzdi2a/oTXUXeG8I7ty
         9yuc7XMU0UvzaX124nO9sfcVzax5ZXDW4i5eOa8g4qd1Kp3e84Iqobp4LUnfWVtJAbhV
         qmagSviujnICXGaUN01KC4aobYqSOuyhNHQs8xpOkTFG4jCI6uwcm7arcqe9jud3lgrJ
         e/z9zqmk2c/Vymds650NCASa/1JugdE2ELc4D1DqVz/2/Y2a9xCvgtscH74dZaUfpHbC
         5RyoZPC3JcvB2ARmWaJnYd5J9ZxOYMtRfg2DMR7/mZ+eTgZQ1/Y1RvMJyf4JGCqvvr5M
         Gbog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tb0ueiuCZhmbeIOxA4XRuKzb5t2VG1idqa+l+pQwN8Q=;
        b=yl0BpqCpELxzOzMixKkbhwJisgnZfkUZW72lnZugYszgc9oikIVRYh2LTxLwfftijP
         wwDkaJYZIrG+P3ct3pufOBwBnKU+iisL4T7j81Yid9Z/ZD8vVZlzzB6ZFo5xjsr0agTy
         m5M7GB9TJACikKNamuCMDoP/+JkabKXGgM1dRHhfzVoZtIHILnSaJBax1A9j1dMmiCLx
         4h2TCPmx9TD08/mNBpnMk5iChvDrZ2SUPUl0YVC/qUe6G6/Mz9Lgtj7RXxhYrDjxsW5/
         C0jJ/8UxWVDnPsI33yxzBUAzKGQ0o2CcsDjZp84RGb501lXwW0zpEuSZoswRDsFsRKnD
         GPpg==
X-Gm-Message-State: AO0yUKVdpKSFLqoB7XEqw2SsmrxeQThYlLu52Es7QkL4N2xJG2eYkibj
        wSpZkIyk7vyHAB5JKddRfcc7rIUN/hy6iQRMtpEgNy0bUSWNU/10ApJHxoeEfnpvLu+bbfn1Thm
        hdZOjZ9rCKMmwDB3Xtigo5nO+aoUmA6rxmc5QI7bZlONoc9LqXD2TfIizLxwkKg==
X-Google-Smtp-Source: AK7set/qJFvMavfu7Z5LZSmlEP+qoTmKVUvFTRdSkd+SHrV73tgsU/72cKj6c88wK/v7iGUr/yaHYmqPAHs=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a17:90b:3d89:b0:233:de9a:43a4 with SMTP id
 pq9-20020a17090b3d8900b00233de9a43a4mr3265329pjb.136.1677094175117; Wed, 22
 Feb 2023 11:29:35 -0800 (PST)
Date:   Wed, 22 Feb 2023 19:29:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230222192925.1778183-1-edliaw@google.com>
Subject: [PATCH 4.14 v2 0/4] BPF fixes for CVE-2021-3444 and CVE-2021-3600
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

