Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B03D283A2B
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgJEPb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgJEPbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B801206DD;
        Mon,  5 Oct 2020 15:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911912;
        bh=51VCRjyA9wpgOyDphxsbcYBhUYW6TmtVkcP7n7u9yEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUFeHljj7Pmy+KcMWSExO1coARoFF/yQE0dCGpdLEk3EB8V/XrdtdQSmMoUv6VCr4
         jrbPtdNdXlUP71cwIQMddmc65goBumsUli2yxwdDS0rmlWHa+nMZuxTh1x/roA6A0N
         xDrKolmMK/IqSFCGnYWmVwfL1208XWeHoy7jEcB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 27/85] libbpf: Remove arch-specific include path in Makefile
Date:   Mon,  5 Oct 2020 17:26:23 +0200
Message-Id: <20201005142116.041332188@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 21e9ba5373fc2cec608fd68301a1dbfd14df3172 ]

Ubuntu mainline builds for ppc64le are failing with the below error (*):
    CALL    /home/kernel/COD/linux/scripts/atomic/check-atomics.sh
    DESCEND  bpf/resolve_btfids

  Auto-detecting system features:
  ...                        libelf: [ [32mon[m  ]
  ...                          zlib: [ [32mon[m  ]
  ...                           bpf: [ [31mOFF[m ]

  BPF API too old
  make[6]: *** [Makefile:295: bpfdep] Error 1
  make[5]: *** [Makefile:54: /home/kernel/COD/linux/debian/build/build-generic/tools/bpf/resolve_btfids//libbpf.a] Error 2
  make[4]: *** [Makefile:71: bpf/resolve_btfids] Error 2
  make[3]: *** [/home/kernel/COD/linux/Makefile:1890: tools/bpf/resolve_btfids] Error 2
  make[2]: *** [/home/kernel/COD/linux/Makefile:335: __build_one_by_one] Error 2
  make[2]: Leaving directory '/home/kernel/COD/linux/debian/build/build-generic'
  make[1]: *** [Makefile:185: __sub-make] Error 2
  make[1]: Leaving directory '/home/kernel/COD/linux'

resolve_btfids needs to be build as a host binary and it needs libbpf.
However, libbpf Makefile hardcodes an include path utilizing $(ARCH).
This results in mixing of cross-architecture headers resulting in a
build failure.

The specific header include path doesn't seem necessary for a libbpf
build. Hence, remove the same.

(*) https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9-rc3/ppc64el/log

Reported-by: Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200902084246.1513055-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index c820b0be9d637..9ae8f4ef0aac2 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -59,7 +59,7 @@ FEATURE_USER = .libbpf
 FEATURE_TESTS = libelf libelf-mmap zlib bpf reallocarray
 FEATURE_DISPLAY = libelf zlib bpf
 
-INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(ARCH)/include/uapi -I$(srctree)/tools/include/uapi
+INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi
 FEATURE_CHECK_CFLAGS-bpf = $(INCLUDES)
 
 check_feat := 1
-- 
2.25.1



