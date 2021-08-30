Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF613FBC75
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 20:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238822AbhH3Sdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 14:33:32 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:35872
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238250AbhH3Sdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 14:33:31 -0400
Received: from mussarela.. (201-69-234-220.dial-up.telesp.net.br [201.69.234.220])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 6CBED3F109;
        Mon, 30 Aug 2021 18:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630348351;
        bh=0J6hFeRkXyHR9OferU36F/qgV5W29XtBL5moT2YFh34=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=QlJcGBQsQ1+UBWskj2M0Ztxsx4Il5Ez6T+4hYsmNZslzBQqcqgaYjM9rmgFdGYNlA
         qXuGgEQb5zEjSfKRWih+U9I4Y5QKiQ9BJHK0drLiNriIGCEtOeY/QRkJnyBhMdBJ9v
         B24c/yIXq5f0AqQ32w0XYqoM63btrdCQUBx/yq89+uCTfubb70g5D1vf4bHwChyaBM
         AxaaZCbFOV5SBCYpIWfGsYJhjYehCO6gLaBVQAbNKZAqHgLNtozr6J0ApSeD4W5TJk
         iiXFza4pC1Zv1HUXKX2F004DPoUkdipjS7llJZ/RRc98vksWy+5seGYrGmD/xfF4Bt
         EXGLhHQ/QCeHw==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Pavel Machek <pavel@denx.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 0/4] BPF fixes for CVE-2021-3444 and CVE-2021-3600
Date:   Mon, 30 Aug 2021 15:32:07 -0300
Message-Id: <20210830183211.339054-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
 kernel/bpf/core.c      | 40 +++++++++++++++-------------------------
 kernel/bpf/verifier.c  | 39 +++++++++++++++++++++++++++++++--------
 net/core/filter.c      |  9 ++++++++-
 4 files changed, 78 insertions(+), 34 deletions(-)

-- 
2.30.2

