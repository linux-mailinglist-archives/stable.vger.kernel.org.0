Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676866C3B7
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 02:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfGRACZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 20:02:25 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:56616 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbfGRACZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 20:02:25 -0400
Received: by mail-pl1-f202.google.com with SMTP id o6so12881949plk.23
        for <stable@vger.kernel.org>; Wed, 17 Jul 2019 17:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=F4BwMGynHNNojraJ7LjreMR6L3I2Kny/UtiBEd/49jg=;
        b=K9hevwQMFXcVZY0TVfn6Ud/SV2/bHQesWc9wE618szqhc73WC4OW/bMO8wMFXc5LHT
         hBJsqQkPoYSzk0WIBzNs3qSkuRNk+q8717TU4h0P6ksPRJedS3kWLecav/KjMXIH7Mi5
         M/N9JoDiIr7xGzxxHzypHZTYjT5LP3c+lfUD2KPWSKXNoC4hlhUwAwd1OY9ZdIq7Pp97
         oqjPKHwwgQADwKO5BxCEdut3RWlfmF/gkW39Ja3geKDPXAnuszI+ynX67Pv0EtyrmlUl
         QuA6JPstUx1rlEZhmP65fPWS7RZ0ir8cg1pbk4fTrlHO/ilY/HIn9ObcMp7MViu9ngEE
         zIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=F4BwMGynHNNojraJ7LjreMR6L3I2Kny/UtiBEd/49jg=;
        b=EkDClaj8ySct11E1cR8RQ72X/wUb2eDz1HSICDsl4l0ztHLav+bJA5sLstKYscGiC1
         8HIIO54cDnF5cJW+Hgb9nl4vOpUpQ+fevzqPeBtRS4FlVaD3GAuWUMR6MK6zWsNdTTGZ
         8NrLvPCkFkm3gCSWhGalPccuSYiTaGWBXLlpsrQog6vaij3+Ts00osQsvCLMwHGgJ1/3
         Dsroojm8JN1k+2vU8BcJo4Q7JvyHanaEvWGYgBmySnqQGnVgTA6dvNZvQCXAL6+iqc0J
         TVufc/4xYf9UZouIJaDsQpTtwheZLoJgM7nV0uZ2/Q/myAJhfQMa8MWI02JBxxjBOEzJ
         a8EA==
X-Gm-Message-State: APjAAAW+zq3AwQbTZuj0VwqRch4pHOUxXD3bxeAf3im7GwnWw0J6Ru3T
        NcXLeHm9zTB+toA0Fp7Q5TxFsxoXsQJJN1A2pOtn/Q==
X-Google-Smtp-Source: APXvYqwbaNEq2cmulN5Pfzy8ARhvkLv7MBCDx+b2D8ZSCoaObYtbmood/GQ5VD54MA7JAkzuFbKme7G/xBzZ4Lv3lK4edg==
X-Received: by 2002:a63:5765:: with SMTP id h37mr12364689pgm.183.1563408143830;
 Wed, 17 Jul 2019 17:02:23 -0700 (PDT)
Date:   Wed, 17 Jul 2019 17:02:04 -0700
Message-Id: <20190718000206.121392-1-vaibhavrustagi@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
Subject: [PATCH 0/2] Support kexec/kdump for clang built kernel
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series includes the following:

1. Adding compiler options to not use XMM registers in the purgatory code.
2. Reuse the implementation of memcpy and memset instead of relying on
__builtin_memcpy and __builtin_memset as it causes infinite recursion
in clang.

Nick Desaulniers (1):
  x86/purgatory: do not use __builtin_memcpy and __builtin_memset.

Vaibhav Rustagi (1):
  x86/purgatory: add -mno-sse, -mno-mmx, -mno-sse2 to Makefile

 arch/x86/purgatory/Makefile    |  4 ++++
 arch/x86/purgatory/purgatory.c |  6 ++++++
 arch/x86/purgatory/string.c    | 23 -----------------------
 3 files changed, 10 insertions(+), 23 deletions(-)
 delete mode 100644 arch/x86/purgatory/string.c

-- 
2.22.0.510.g264f2c817a-goog

