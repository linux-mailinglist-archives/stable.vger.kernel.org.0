Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CAF366BCC
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240750AbhDUNHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:07:09 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:20495 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239051AbhDUNGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010349; x=1650546349;
  h=to:cc:from:subject:message-id:date:mime-version:
   content-transfer-encoding;
  bh=G54VHrIVXqISdhGhnadHmQGqdXpbcT/YXnRlmQtowA0=;
  b=Qu7/cpCFJrIqHd5vtBC3bntYabYkY3ox4/MBXkjUib3nuRcvU+SjyePz
   VSo4Ew+AyUT79kwTj9qnFOLown0oLZL/vntro8Aoq8AnHpjQI3rK8OF1K
   VE0pGMvI1jhlHK7iKtNuTXMpUBixAK2S0Pv4iF2BTUpvm5MqiUZSzm949
   g=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="120448982"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Apr 2021 13:05:42 +0000
Received: from EX13D01EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 8E205A1DD9;
        Wed, 21 Apr 2021 13:05:40 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.161.102) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:05:37 +0000
To:     <stable@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
Subject: [PATCH 0/8] Fix bpf: fix userspace access for bpf_probe_read{,str}()
Message-ID: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Date:   Wed, 21 Apr 2021 16:05:32 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D32UWA001.ant.amazon.com (10.43.160.4) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In arm64, kernelspace address accessors cannot be used to access
userspace addresses, which means bpf_probe_read{,str}() cannot access
userspace addresses. That causes e.g. command-line parameters to not
appear when snooping execve using bpf.

This patch series takes the upstream solution. This solution also
changes user API in the following ways:
* Add probe_read_{user, kernel}{,_str} bpf helpers
* Add skb_output helper to the enum only (calling it not supported)
* Add support for %pks, %pus specifiers

An alternative fix only takes the required logic to existing API without
adding new API, was suggested here:
https://www.spinics.net/lists/stable/msg454945.html

Another option is to only take patches [1-4] of this patchset, and add
on top of them commit 8d92db5c04d1 ("bpf: rework the compat kernel probe
handling"). In that case, the last patch would require function renames
and conflict resolutions that were avoided in this patchset by pulling
patches [5-7].

Christoph Hellwig (3):
  maccess: rename strncpy_from_unsafe_user to strncpy_from_user_nofault
  maccess: rename strncpy_from_unsafe_strict to
    strncpy_from_kernel_nofault
  bpf: rework the compat kernel probe handling

Daniel Borkmann (4):
  uaccess: Add strict non-pagefault kernel-space read function
  bpf: Add probe_read_{user, kernel} and probe_read_{user, kernel}_str
    helpers
  bpf: Restrict bpf_probe_read{, str}() only to archs where they work
  bpf: Restrict bpf_trace_printk()'s %s usage and add %pks, %pus
    specifier

Petr Mladek (1):
  powerpc/bpf: Enable bpf_probe_read{, str}() on powerpc again

 Documentation/core-api/printk-formats.rst |  14 +
 arch/arm/Kconfig                          |   1 +
 arch/arm64/Kconfig                        |   1 +
 arch/powerpc/Kconfig                      |   1 +
 arch/x86/Kconfig                          |   1 +
 arch/x86/mm/Makefile                      |   2 +-
 arch/x86/mm/maccess.c                     |  43 +++
 include/linux/uaccess.h                   |   8 +-
 include/uapi/linux/bpf.h                  | 123 ++++++---
 init/Kconfig                              |   3 +
 kernel/trace/bpf_trace.c                  | 302 ++++++++++++++++------
 kernel/trace/trace_kprobe.c               |   2 +-
 lib/vsprintf.c                            |  12 +
 mm/maccess.c                              |  48 +++-
 tools/include/uapi/linux/bpf.h            | 116 ++++++---
 15 files changed, 512 insertions(+), 165 deletions(-)
 create mode 100644 arch/x86/mm/maccess.c

-- 
2.25.1


