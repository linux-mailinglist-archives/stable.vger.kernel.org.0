Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118DC157BBD
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgBJNcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:32:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgBJMfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:54 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF49208C4;
        Mon, 10 Feb 2020 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338152;
        bh=i+t3QrlUoPcMh4vJRJFjTNhFtpxkNZIJKUzJBi8sdwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yqt0vuUIbbVB059xksPgz1ipzKbBhljVbKKozX3nCH3qdedI8r6nIwct5am8lGp4W
         AHaFTu2k4q4hdlIA6TRFSSInovNN/cwhkkjxQxQEoIB8r+6HtsUh70Zi1mIjBLS3UZ
         uzayKLX17uvldEejG65MU6HbrADRgEb0asrBN8+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 117/195] tools/kvm_stat: Fix kvm_exit filter name
Date:   Mon, 10 Feb 2020 04:32:55 -0800
Message-Id: <20200210122316.831588276@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
@@ -271,6 +271,7 @@ class ArchX86(Arch):
     def __init__(self, exit_reasons):
         self.sc_perf_evt_open = 298
         self.ioctl_numbers = IOCTL_NUMBERS
+        self.exit_reason_field = 'exit_reason'
         self.exit_reasons = exit_reasons
 
     def debugfs_is_child(self, field):
@@ -290,6 +291,7 @@ class ArchPPC(Arch):
         # numbers depend on the wordsize.
         char_ptr_size = ctypes.sizeof(ctypes.c_char_p)
         self.ioctl_numbers['SET_FILTER'] = 0x80002406 | char_ptr_size << 16
+        self.exit_reason_field = 'exit_nr'
         self.exit_reasons = {}
 
     def debugfs_is_child(self, field):
@@ -301,6 +303,7 @@ class ArchA64(Arch):
     def __init__(self):
         self.sc_perf_evt_open = 241
         self.ioctl_numbers = IOCTL_NUMBERS
+        self.exit_reason_field = 'esr_ec'
         self.exit_reasons = AARCH64_EXIT_REASONS
 
     def debugfs_is_child(self, field):
@@ -312,6 +315,7 @@ class ArchS390(Arch):
     def __init__(self):
         self.sc_perf_evt_open = 331
         self.ioctl_numbers = IOCTL_NUMBERS
+        self.exit_reason_field = None
         self.exit_reasons = None
 
     def debugfs_is_child(self, field):
@@ -542,8 +546,8 @@ class TracepointProvider(Provider):
         """
         filters = {}
         filters['kvm_userspace_exit'] = ('reason', USERSPACE_EXIT_REASONS)
-        if ARCH.exit_reasons:
-            filters['kvm_exit'] = ('exit_reason', ARCH.exit_reasons)
+        if ARCH.exit_reason_field and ARCH.exit_reasons:
+            filters['kvm_exit'] = (ARCH.exit_reason_field, ARCH.exit_reasons)
         return filters
 
     def _get_available_fields(self):


