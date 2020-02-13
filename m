Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF07715C612
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387459AbgBMP4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:56:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbgBMPZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:25 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B32442469A;
        Thu, 13 Feb 2020 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607524;
        bh=CRBIkMmtK6DbX7OWOAvW7vuWCkdRO+6B/HqySGWO/fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYI7kzh06h4DVf4UDs2iHsb+FFzCALTRNAgK9F0V0E3+v0Cv5FuL4JFM7t3AkJKCn
         5j1X5y38ze4NarBbm/3x8a2Pcwl9cmyXeDyqqBORZqk5agWRvzHUzw1X4wCkoB1lpi
         q5hM5MG64ujuoCQs4PMba93LEJJFH5DifZDiVAFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 076/173] tools/kvm_stat: Fix kvm_exit filter name
Date:   Thu, 13 Feb 2020 07:19:39 -0800
Message-Id: <20200213151952.689740853@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

commit 5fcf3a55a62afb0760ccb6f391d62f20bce4a42f upstream.

The filter name is fixed to "exit_reason" for some kvm_exit events, no
matter what architect we have. Actually, the filter name ("exit_reason")
is only applicable to x86, meaning it's broken on other architects
including aarch64.

This fixes the issue by providing various kvm_exit filter names, depending
on architect we're on. Afterwards, the variable filter name is picked and
applied through ioctl(fd, SET_FILTER).

Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/kvm/kvm_stat/kvm_stat |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -261,6 +261,7 @@ class ArchX86(Arch):
     def __init__(self, exit_reasons):
         self.sc_perf_evt_open = 298
         self.ioctl_numbers = IOCTL_NUMBERS
+        self.exit_reason_field = 'exit_reason'
         self.exit_reasons = exit_reasons
 
 
@@ -276,6 +277,7 @@ class ArchPPC(Arch):
         # numbers depend on the wordsize.
         char_ptr_size = ctypes.sizeof(ctypes.c_char_p)
         self.ioctl_numbers['SET_FILTER'] = 0x80002406 | char_ptr_size << 16
+        self.exit_reason_field = 'exit_nr'
         self.exit_reasons = {}
 
 
@@ -283,6 +285,7 @@ class ArchA64(Arch):
     def __init__(self):
         self.sc_perf_evt_open = 241
         self.ioctl_numbers = IOCTL_NUMBERS
+        self.exit_reason_field = 'esr_ec'
         self.exit_reasons = AARCH64_EXIT_REASONS
 
 
@@ -290,6 +293,7 @@ class ArchS390(Arch):
     def __init__(self):
         self.sc_perf_evt_open = 331
         self.ioctl_numbers = IOCTL_NUMBERS
+        self.exit_reason_field = None
         self.exit_reasons = None
 
 ARCH = Arch.get_arch()
@@ -513,8 +517,8 @@ class TracepointProvider(Provider):
         """
         filters = {}
         filters['kvm_userspace_exit'] = ('reason', USERSPACE_EXIT_REASONS)
-        if ARCH.exit_reasons:
-            filters['kvm_exit'] = ('exit_reason', ARCH.exit_reasons)
+        if ARCH.exit_reason_field and ARCH.exit_reasons:
+            filters['kvm_exit'] = (ARCH.exit_reason_field, ARCH.exit_reasons)
         return filters
 
     def get_available_fields(self):


