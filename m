Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E5B34CE55
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 12:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhC2K5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 06:57:38 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:61734 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbhC2K5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 06:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617015427; x=1648551427;
  h=to:from:subject:message-id:date:mime-version:
   content-transfer-encoding;
  bh=P+r2Mb1/HJtVakDj5nqmeYZ59hfgztruDDNgTJqiRJ4=;
  b=ovh0/O7icKxUjTer0VTyTDrXUhoeiiEGTP8OK9rpP3OYtKWnSNq/PFBB
   KfKIuC9qcVEKrNVhMmKtJI3WddSw4M/a16jfRNPCEK5Fegd/ax9EFGPli
   lEOxBrcHtK5jKCjejKNk5wARrfeeUjwo4hURmWp2Yz+o7x3OfCrtANy2g
   E=;
X-IronPort-AV: E=Sophos;i="5.81,287,1610409600"; 
   d="scan'208";a="123729725"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 29 Mar 2021 10:57:01 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id D11A0A0761
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 10:56:59 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.160.209) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 29 Mar 2021 10:56:57 +0000
To:     <stable@vger.kernel.org>
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
Subject: [PATCH 0/2] fix userspace access on arm64 for linux 5.4
Message-ID: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
Date:   Mon, 29 Mar 2021 13:56:53 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.160.209]
X-ClientProxiedBy: EX13D32UWB002.ant.amazon.com (10.43.161.139) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


arm64 access to userspace addresses in bpf and kprobes is broken,
because kernelspace address accessors are always used, and won't work
for userspace.

The fix in upstream relies on new kernel BPF API which does not exist in
v5.4. The patches here deviate from their upstream sources.

I am not 100% clear on the best way to post a patch series to stable,
that's not a direct cherry-pick from upstream. Please let me know if
corrections are needed.

Thank you!

Tsahi Zidenberg (2):
  bpf: fix userspace access for bpf_probe_read{, str}()
  tracing/kprobes: handle userspace access on unified probes.

 arch/arm/Kconfig            |  1 +
 arch/arm64/Kconfig          |  1 +
 arch/powerpc/Kconfig        |  1 +
 arch/x86/Kconfig            |  1 +
 init/Kconfig                |  3 +++
 kernel/trace/bpf_trace.c    | 18 ++++++++++++++++++
 kernel/trace/trace_kprobe.c | 15 +++++++++++++++
 7 files changed, 40 insertions(+)

-- 
2.25.1


