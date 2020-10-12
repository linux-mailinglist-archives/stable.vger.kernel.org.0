Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CA128B7E0
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731639AbgJLNr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389782AbgJLNp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F11522365;
        Mon, 12 Oct 2020 13:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510327;
        bh=PNJvWSmSQbBEj8dbQ1RCRg2EII/CqiUPwkmNlcOvIEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FhW7Y7rHFshaxYS56oWmy2DHIkzZpoR5SiLV+ZfMtoUuebZIjB4yEs5JuzpmgyrJa
         cAsM+PxMligsKfEQn0AGyDYSeOdKeebHs7ZttaYA91W+dd+DGA0Webrof7cVYYqw2o
         +wwhS6js1kLBGc2ZuZMrfGI3x5UMCiGLcHNhEymM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <Tony.Ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.8 021/124] bpf: Fix sysfs export of empty BTF section
Date:   Mon, 12 Oct 2020 15:30:25 +0200
Message-Id: <20201012133147.870538972@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Ambardar <tony.ambardar@gmail.com>

commit e23bb04b0c938588eae41b7f4712b722290ed2b8 upstream.

If BTF data is missing or removed from the ELF section it is still exported
via sysfs as a zero-length file:

  root@OpenWrt:/# ls -l /sys/kernel/btf/vmlinux
  -r--r--r--    1 root    root    0 Jul 18 02:59 /sys/kernel/btf/vmlinux

Moreover, reads from this file succeed and leak kernel data:

  root@OpenWrt:/# hexdump -C /sys/kernel/btf/vmlinux|head -10
  000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
  *
  000cc0 00 00 00 00 00 00 00 00 00 00 00 00 80 83 b0 80 |................|
  000cd0 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
  000ce0 00 00 00 00 00 00 00 00 00 00 00 00 57 ac 6e 9d |............W.n.|
  000cf0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
  *
  002650 00 00 00 00 00 00 00 10 00 00 00 01 00 00 00 01 |................|
  002660 80 82 9a c4 80 85 97 80 81 a9 51 68 00 00 00 02 |..........Qh....|
  002670 80 25 44 dc 80 85 97 80 81 a9 50 24 81 ab c4 60 |.%D.......P$...`|

This situation was first observed with kernel 5.4.x, cross-compiled for a
MIPS target system. Fix by adding a sanity-check for export of zero-length
data sections.

Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/b38db205a66238f70823039a8c531535864eaac5.1600417359.git.Tony.Ambardar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/sysfs_btf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/bpf/sysfs_btf.c
+++ b/kernel/bpf/sysfs_btf.c
@@ -30,15 +30,15 @@ static struct kobject *btf_kobj;
 
 static int __init btf_vmlinux_init(void)
 {
-	if (!__start_BTF)
+	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
+
+	if (!__start_BTF || bin_attr_btf_vmlinux.size == 0)
 		return 0;
 
 	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
 	if (!btf_kobj)
 		return -ENOMEM;
 
-	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
-
 	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
 }
 


