Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21F712E93F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 18:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgABRYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 12:24:19 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36733 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgABRYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 12:24:19 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so39988152wru.3;
        Thu, 02 Jan 2020 09:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oT3hhuKEy1N1K2d4A4PsoHJRo9+URBufhVuCLWM6bzw=;
        b=QuSqXTEXIxeUMLl8R+laSW67tiLhNbeohp3pNJA75mf96ttImwA6EK8syRQn/+i3Ad
         Ajw/QLQtYlDgxkCDwQ7+Dz7Zs/RYi7MrTd4mLwT7twNeLC9P4jIny42HKJSxj6AULbr1
         G3aa0HXV6cV4fVQM2OjOZ/fypkhO+ij4bEEujivVh6ltuQA1ngzbC6wxKg0HJL3q3Bwj
         N0j2e+r/zR65NeII2z+ECQ09gFsMJHVpQGxF9Mio4QjuhwyANw0sqvnSZzHMGizTv56I
         hYckUJZxCC7yGPFpjvnLpgcFfPhqLCt5VsUnFEwG+vXbKevPtukC3j7l1ilJi4oc+sNt
         OCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oT3hhuKEy1N1K2d4A4PsoHJRo9+URBufhVuCLWM6bzw=;
        b=NhQhYKCSc9ziGmIIDW0oHBPGKEeEOxzabSpcrnG0RRfw+QpD80UK/vIKO0MYqrY05P
         FasVblX0vvnK3DHJ3hKtsuMB5AD3uIJ32RZ2oXV5HCFMnDZHlmR6FT1fvnU9tlqZWL/M
         SS/K2jTmXWkKB6+YFBkyhbVlWpNdLBCFD9hfUx1XLlVcoOQA87kqZsWSDPnm6lUvG+O3
         k1p7W51Dt+QnzF7nxriSQYaHiq9gmeQoZByL+fhNd8po9FuMaHbJTIFr5bWRiErWPzMK
         yZ2eB9Og3R0J4u3y/buZQ5Cw78j86bk6xY02saiEfegXtVKDu0vdn2en40voqLSaSy5x
         GeYw==
X-Gm-Message-State: APjAAAWyZNPWCvQMuI3bGD+PpODJwKg0xhX/13xvn4VnQfFrJ8JcdZgE
        6DrMvmcfOZUTaMJSZgHB4yvcHN33xmHZyA==
X-Google-Smtp-Source: APXvYqxYc0JThE1koPwI21OmnUi0PS6X/0fzwxo7hEIxk9sQ65279fNq++1prhUC8qwnvJZ8+bpFjA==
X-Received: by 2002:a5d:610a:: with SMTP id v10mr85459799wrt.267.1577985856338;
        Thu, 02 Jan 2020 09:24:16 -0800 (PST)
Received: from amanieu-laptop.home ([2a01:cb19:8051:6200:3fe7:84:7f3:e713])
        by smtp.gmail.com with ESMTPSA id z21sm9480328wml.5.2020.01.02.09.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 09:24:15 -0800 (PST)
From:   Amanieu d'Antras <amanieu@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>, stable@vger.kernel.org,
        Amanieu d'Antras <amanieu@gmail.com>
Subject: [PATCH 0/7] Fix CLONE_SETTLS with clone3
Date:   Thu,  2 Jan 2020 18:24:06 +0100
Message-Id: <20200102172413.654385-1-amanieu@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The clone3 syscall is currently broken when used with CLONE_SETTLS on all
architectures that don't have an implementation of copy_thread_tls. The old
copy_thread function handles CLONE_SETTLS by reading the new TLS value from
pt_regs containing the clone syscall parameters. Since clone3 passes the TLS
value in clone_args, this results in the TLS register being initialized to a
garbage value.

This patch series implements copy_thread_tls on all architectures that currently
define __ARCH_WANT_SYS_CLONE3 and adds a compile-time check to ensure that any
architecture that enables clone3 in the future also implements copy_thread_tls.

I have also included a minor fix for the arm64 uapi headers which caused
__NR_clone3 to be missing from the exported user headers.

I have only tested this on arm64, but the copy_thread_tls implementations for
the various architectures are fairly straightforward.

Amanieu d'Antras (7):
  arm64: Move __ARCH_WANT_SYS_CLONE3 definition to uapi headers
  arm64: Implement copy_thread_tls
  arm: Implement copy_thread_tls
  parisc: Implement copy_thread_tls
  riscv: Implement copy_thread_tls
  xtensa: Implement copy_thread_tls
  clone3: ensure copy_thread_tls is implemented

 arch/arm/Kconfig                     |  1 +
 arch/arm/kernel/process.c            |  6 +++---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/unistd.h      |  1 -
 arch/arm64/include/uapi/asm/unistd.h |  1 +
 arch/arm64/kernel/process.c          | 10 +++++-----
 arch/parisc/Kconfig                  |  1 +
 arch/parisc/kernel/process.c         |  8 ++++----
 arch/riscv/Kconfig                   |  1 +
 arch/riscv/kernel/process.c          |  6 +++---
 arch/xtensa/Kconfig                  |  1 +
 arch/xtensa/kernel/process.c         |  8 ++++----
 kernel/fork.c                        | 10 ++++++++++
 13 files changed, 35 insertions(+), 20 deletions(-)

-- 
2.24.1

