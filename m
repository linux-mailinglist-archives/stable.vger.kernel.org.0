Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADC02F7A2F
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbhAOMqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:46:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388078AbhAOMhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3782D22473;
        Fri, 15 Jan 2021 12:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714259;
        bh=+MOftX0eh6Va4502EDqSaY5br9ihD+GXizoor8nYNCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WekirRlh/DEROwN05g/ZdXmobMHYgTbD1vOj5wMNTJ49Q036AADx9eNqydwO1b/ld
         ygRQ1uiljx/FkXVhfamNfkOLQIc+JfDBMbOOhFk5yQT8gG/8u6JZslPQXBAktH8sW+
         S93hlrGDrTIKTUzGAO4X3aitVISNPeOtZTFgocRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Mostafa <kamal@canonical.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.10 055/103] selftests/bpf: Clarify build error if no vmlinux
Date:   Fri, 15 Jan 2021 13:27:48 +0100
Message-Id: <20210115122008.713997976@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Mostafa <kamal@canonical.com>

commit 1a3449c19407a28f7019a887cdf0d6ba2444751a upstream.

If Makefile cannot find any of the vmlinux's in its VMLINUX_BTF_PATHS list,
it tries to run btftool incorrectly, with VMLINUX_BTF unset:

    bpftool btf dump file $(VMLINUX_BTF) format c

Such that the keyword 'format' is misinterpreted as the path to vmlinux.
The resulting build error message is fairly cryptic:

      GEN      vmlinux.h
    Error: failed to load BTF from format: No such file or directory

This patch makes the failure reason clearer by yielding this instead:

    Makefile:...: *** Cannot find a vmlinux for VMLINUX_BTF at any of
    "{paths}".  Stop.

Fixes: acbd06206bbb ("selftests/bpf: Add vmlinux.h selftest exercising tracing of syscalls")
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20201215182011.15755-1-kamal@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -146,6 +146,9 @@ VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmli
 		     /sys/kernel/btf/vmlinux				\
 		     /boot/vmlinux-$(shell uname -r)
 VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+ifeq ($(VMLINUX_BTF),)
+$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
 
 DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
 


