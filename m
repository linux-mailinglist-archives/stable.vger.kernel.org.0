Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE559F150
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 19:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfH0RQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 13:16:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37392 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfH0RQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 13:16:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id d1so13041891pgp.4
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 10:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=FvlSwNCpILSy9LzNY5cXC5PFGeMyZeL9cyw5Vf4CBXE=;
        b=B27i3c6P/2hBBW7ZPQ+uq1RHWLqieaLLTe19Sw3FhlKDmrA9ObWJwD5oPqFwwctW7n
         20yNMHXCbTCr2SVHgoKe6YtcPFeSgrdToVZjxKJ+HZslBoRCjyM4ooT/RCLIghGxpaZZ
         pzWkOghGmDHujyvHjEWWf/SEwpHI1CQTKH6m+cSiOkLBnzBRA1op/vk13bEGCEw8DLIJ
         6P6Y8C8WbNMqxPKIIPGaEAuSlBpVbcQDY8djkmtMPIQNsvj3ZRDhGY94enLXFdPUmFyi
         f9oIl5RyS3JXb0YZyjpiVugrIPaEbaOK7D56JE1mhEQswW53ASC89EYnOcRFfABf8jek
         /5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=FvlSwNCpILSy9LzNY5cXC5PFGeMyZeL9cyw5Vf4CBXE=;
        b=Pl/KHi9umJ3kI/Juxc9L28z6PpYpeza9MO8cVLNXmt6bxRVhq4HcX5FwngaUDOJFsf
         +CVgAHHiwvMjlo0Xoj0ezsA4RSw8VorWbuvtjQvL5QJUQ6tYgcbxkUD+iUR2cdr5geTF
         wdVhQUS9fpVRgD3rDqnbACIzRtMJ5LlmEqY6RG7owQZ0YUYoCROyLZbmaOePTMEHNRhu
         OZRzkv4CSEZYhoVEzT/BF1Dwt+lw4Kulymvt+/rENEn9ymcz/mJXzO9UEWJAY29dwnSt
         f/ullBTRlN1zncjGj0ENuegdFejKVhwc0efAd/mu4wTR739hSfSvXtMaNS31/vA+TCrt
         /WAQ==
X-Gm-Message-State: APjAAAXSADTbObos5ypn+0iD8E8KVa027++CxmkEiGtDD1dlsmOVjuaA
        oCIbohVBjD2eXTf2rJ+8gQSnF6cH
X-Google-Smtp-Source: APXvYqxDfwonLAGdUqA83LnEzChv7WWNg2Pl5BqmScv8Z55Fae8O9iSotB0ngKon/kUA/uZYUVZLXg==
X-Received: by 2002:a63:2c8:: with SMTP id 191mr21841771pgc.139.1566926184110;
        Tue, 27 Aug 2019 10:16:24 -0700 (PDT)
Received: from localhost (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id f205sm20738801pfa.161.2019.08.27.10.16.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 10:16:23 -0700 (PDT)
Date:   Tue, 27 Aug 2019 10:16:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Patches potentially missing from stable releases
Message-ID: <20190827171621.GA30360@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I recently wrote a script which identifies patches potentially missing
in downstream kernel branches. The idea is to identify patches backported/
applied to a downstream branch for which patches tagged with Fixes: are
available in the upstream kernel, but those fixes are missing from the
downstream branch. The script workflow is something like:

- Identify locally applied patches in downstream branch
- For each patch, identify the matching upstream SHA
- Search the upstream kernel for Fixes: tags with this SHA
- If one or more patches with matching Fixes: tags are found, check
  if the patch was applied to the downstream branch. 
- If the patch was not applied to the downstream branch, report

Running this script on chromeos-4.19 identified, not surprisingly, a number
of such patches. However, and more surprisingly, it also identified several
patches applied to v4.19.y for which fixes are available in the upstream
kernel, but those fixes have not been applied to v4.19.y. Some of those
are on the cosmetic side, but several seem to be relevant. I didn't
cross-check all of them, but the ones I tried did apply to linux-4.19.y.
The complete list is attached below.

Question: Do Sasha's automated scripts identify such patches ? If not,
would it make sense to do it ? Or is there some reason why the patches
have not been applied to v4.19.y ?

Thanks,
Guenter

---
SHA ce081fc137c8 [ce49d8436cff] ('perf strbuf: Match va_{add,copy} with va_end')
  fixed by upstream commit 099be748865e
  Fix is missing from chromeos-4.19 and applies cleanly
SHA c21099be0233 [ae61cf5b9913] ('uio: ensure class is registered before devices')
  fixed by upstream commit 6011002c1584
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 3252b60cf810 [578bdaabd015] ('crypto: speck - remove Speck')
  fixed by upstream commit 733ac4f9935c
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 0858d74e8845 [bcc71cc3cde1] ('scsi: qla2xxx: Fix for double free of SRB structure')
  fixed by upstream commit ef801f07e7b3
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 3d8c2945fcbf [8985167ecf57] ('clk: s2mps11: Fix matching when built as module and DT node contains compatible')
  fixed by upstream commit 9c940bbe2bb4
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 67a19f87a02b [ac5b2c18911f] ('mm: thp: relax __GFP_THISNODE for MADV_HUGEPAGE mappings')
  fixed by upstream commit 2f0799a0ffc0
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA f55e301ec4d5 [a74cfffb03b7] ('x86/speculation: Rework SMT state change')
  fixed by upstream commit 34d66caf251d
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 84d2023c14ea [e949b6db51dc] ('riscv/function_graph: Simplify with function_graph_enter()')
  fixed by upstream commit 397182e0db56
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 0e79e30e6121 [4cff280a5fcc] ('nvme-fc: resolve io failures during connect')
  fixed by upstream commit 8730c1ddb69b
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 52da87f0e2e8 [ae3b7361dc0e] ('afs: Fix validation/callback interaction')
  fixed by upstream commit 61c347ba5511
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA cd50eeeb6646 [3e9efc3299dd] ('i2c: aspeed: fix build warning')
  fixed by upstream commit 2be6b47211e1
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 2658687568cd [7aa54be29765] ('locking/qspinlock, x86: Provide liveness guarantee')
  fixed by upstream commit b987ffc18fb3
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 6ffd9f25c0e9 [c3494801cd17] ('bpf: check pending signals while verifying programs')
  fixed by upstream commit 86edaed37963
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 53471f0d893d [04f05230c5c1] ('bnx2x: Remove configured vlans as part of unload sequence.')
  fixed by upstream commit 4a4d2d372fb9
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 341b8840435a [308c6cafde01] ('net: hns: All ports can not work when insmod hns ko after rmmod.')
  fixed by upstream commit c77804be5336
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA ba1fe90be68f [6977f95e63b9] ('powerpc: avoid -mno-sched-epilog on GCC 4.9 and newer')
  fixed by upstream commit 1a49b2fd8f58
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 7398668b3110 [4be9bd10e22d] ('drm/fb_helper: Allow leaking fbdev smem_start')
  fixed by upstream commit b31a3ca745a4
  Fix is missing from chromeos-4.19 and applies cleanly
SHA ad7013cd6d6a [8cc4ccf58379] ('netfilter: ipset: Allow matching on destination MAC address for mac and ipmac sets')
  fixed by upstream commit b89d15480d0c
  Fix is missing from chromeos-4.19 and applies cleanly
SHA ad7013cd6d6a [8cc4ccf58379] ('netfilter: ipset: Allow matching on destination MAC address for mac and ipmac sets')
  fixed by upstream commit 1b4a75108d5b
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 38b17eee7074 [d189dd70e255] ('btrfs: fix use-after-free due to race between replace start and cancel')
  fixed by upstream commit 669e859b5ea7
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 9d51378a6893 [5a86d68bcf02] ('netfilter: ipt_CLUSTERIP: fix deadlock in netns exit routine')
  fixed by upstream commit dddaf89e2fbc
  Fix is missing from chromeos-4.19 and applies cleanly
SHA b18931c5fe0d [11189c1089da] ('acpi/nfit: Fix command-supported detection')
  fixed by upstream commit 0171b6b78131
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 91e46947d02f [ca95f802ef51] ('IB/hfi1: Unreserve a reserved request when it is completed')
  fixed by upstream commit 2b74c878b0ea
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 4cd197bfa6e1 [36d65be9a880] ('bnxt_en: Disable MSIX before re-reserving NQs/CMPL rings.')
  fixed by upstream commit 0b815023a1d4
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA c709eeb02c04 [0d640732dbeb] ('arm64: KVM: Skip MMIO insn after emulation')
  fixed by upstream commit 2113c5f62b74
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 7371994d6cfa [2a418cf3f5f1] ('x86/uaccess: Don't leak the AC flag into __put_user() value evaluation')
  fixed by upstream commit 6ae865615fc4
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 8ce41db0dcfc [dd9ee3444014] ('vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel')
  fixed by upstream commit 01ce31c57b3f
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 3355d641269f [2035f3ff8eaa] ('netfilter: ebtables: compat: un-break 32bit setsockopt when no rules are present')
  fixed by upstream commit 3b48300d5cc7
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 33e83ea302c0 [2c2ade81741c] ('mm: page_alloc: fix ref bias in page_frag_alloc() for 1-byte allocs')
  fixed by upstream commit 8644772637de
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 4ab78f4d75c6 [500e0b28ecd3] ('f2fs: fix to check inline_xattr_size boundary correctly')
  fixed by upstream commit 70db5b04cbe1
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 54fb5c9da6cd [272e5326c783] ('btrfs: prop: fix vanished compression property after failed set')
  fixed by upstream commit aa53e3bfac72
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA c963475972f6 [ef05bcb60c1a] ('arm64: dts: rockchip: fix vcc_host1_5v pin assign on rk3328-rock64')
  fixed by upstream commit 26e2d7b03ea7
  Fix is missing from chromeos-4.19 and applies cleanly
SHA e434fbf4f049 [8ac51bbc4cfe] ('ALSA: hda: fix front speakers on Huawei MBXP')
  fixed by upstream commit 0fbf21c3b36a
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA a1da981f6643 [131ac62253db] ('staging: most: core: use device description as name')
  fixed by upstream commit 3970d0d81816
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 6ff17bc5936e [04f5866e41fb] ('coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping')
  fixed by upstream commit 46d0b24c5ee1
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA f7ab4818f74e [c01908a14bf7] ('HID: input: add mapping for "Toggle Display" key')
  fixed by upstream commit 1c703b53e5bf
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 7b115755fb9d [3c79107631db] ('netfilter: ctnetlink: don't use conntrack/expect object addresses as id')
  fixed by upstream commit 656c8e9cc1ba
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 8b13bb911f0c [c2d1b3aae336] ('btrfs: Honour FITRIM range constraints during free space trim')
  fixed by upstream commit 8103d10b7161
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 0388d45afc50 [03628cdbc64d] ('Btrfs: do not start a transaction during fiemap')
  fixed by upstream commit a6d155d2e363
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 2d2017675b1a [b5b5a27bee58] ('media: stm32-dcmi: return appropriate error codes during probe')
  fixed by upstream commit dbb9fcc8c2d8
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 8715ce033eb3 [f2c65fb3221a] ('x86/modules: Avoid breaking W^X while loading modules')
  fixed by upstream commit 2eef1399a866
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 8034a6b89990 [95f18c9d1310] ('bcache: avoid potential memleak of list of journal_replay(s) in the CACHE_SYNC branch of run_cache_set')
  fixed by upstream commit cdca22bcbc64
  Fix is missing from chromeos-4.19 and applies cleanly
SHA cd83c78897d5 [631207314d88] ('bcache: fix failure in journal relplay')
  fixed by upstream commit 2d5abb9a1e8e
  Fix is missing from chromeos-4.19 and applies cleanly
SHA fec8a09f79ec [56c46bba9bbf] ('powerpc/64: Fix booting large kernels with STRICT_KERNEL_RWX')
  fixed by upstream commit 9c4e4c90ec24
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 5d5652b51c87 [09f11b6c99fe] ('thunderbolt: Take domain lock in switch sysfs attribute callbacks')
  fixed by upstream commit 4f7c2e0d8765
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 9d57cfd4e9d8 [5cec2d2e5839] ('binder: fix race between munmap() and direct reclaim')
  fixed by upstream commit 60d488571083
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 6fa953c94882 [d2a68c4effd8] ('x86/ftrace: Do not call function graph from dynamic trampolines')
  fixed by upstream commit 745cfeaac09c
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 25511676362d [54c7a8916a88] ('initramfs: free initrd memory if opening /initrd.image fails')
  fixed by upstream commit 5d59aa8f9ce9
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 525b5265fd75 [fbc2a15e3433] ('blk-mq: move cancel of requeue_work into blk_mq_release')
  fixed by upstream commit e26cc08265dd
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 3e1d7417b4d6 [fc82d93e57e3] ('selftests: fib_rule_tests: fix local IPv4 address typo')
  fixed by upstream commit 34632975cafd
  Fix is missing from chromeos-4.19 and applies cleanly
SHA ca4c34037bb9 [e3ff9c3678b4] ('timekeeping: Repair ktime_get_coarse*() granularity')
  fixed by upstream commit 0354c1a3cdf3
  Fix is missing from chromeos-4.19 and applies cleanly
SHA ccf6a155844b [33d915d9e8ce] ('{nl,mac}80211: allow 4addr AP operation on crypto controlled devices')
  fixed by upstream commit e6f4051123fd
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 027e043f9c78 [652b8b086538] ('drm: panel-orientation-quirks: Add quirk for GPD MicroPC')
  fixed by upstream commit dae1ccee012e
  Fix is missing from chromeos-4.19 and applies cleanly
SHA c854d9b6ef8d [d5b844a2cf50] ('ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()')
  fixed by upstream commit 074376ac0e1d
  Fix is missing from chromeos-4.19 and applies cleanly
SHA c854d9b6ef8d [d5b844a2cf50] ('ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()')
  fixed by upstream commit f1c6ece23729
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 3ae98dc2db1e [a3fb01ba5af0] ('blk-iolatency: only account submitted bios')
  fixed by upstream commit c9b3007feca0
  Fix may be missing from chromeos-4.19; trying to apply it results in conflicts/errors
SHA 025eb12bb4b0 [bd293d071ffe] ('dm bufio: fix deadlock with loop device')
  fixed by upstream commit cf3591ef8329
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 9d3586bcdae3 [a9eeb998c28d] ('hv_sock: Add support for delayed close')
  fixed by upstream commit 685703b497ba
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 9e441c7844a6 [c7944ebb9ce9] ('NFSv4: Fix lookup revalidate of regular files')
  fixed by upstream commit 42f72cf368c5
  Fix is missing from chromeos-4.19 and applies cleanly
SHA 3d180fe5cd76 [883a2a80f79c] ('Input: elantech - enable SMBus on new (2018+) systems')
  fixed by upstream commit f3b5720cabaf
  Fix is missing from chromeos-4.19 and applies cleanly

