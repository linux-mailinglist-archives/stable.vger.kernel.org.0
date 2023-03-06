Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7C16AD223
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 23:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCFW6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 17:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCFW6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 17:58:22 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EFE2B282;
        Mon,  6 Mar 2023 14:58:19 -0800 (PST)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4PVvBF497Wz9swL;
        Mon,  6 Mar 2023 23:58:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1678143493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=u2Gi+zIBBx3EwQ5U8SSGElwnTAsXc+kwYEwilJbCjyA=;
        b=ppRp6Ikx3RbPxXeSX1G6IdNunR8qlLxTWgxVPFkPCPtIC17132g1ux8QJ/vxWHLletn23t
        KDH0cby5khbO4OtwovtJPZ/n7nWZXSN/Oqh2cHzkZwQQVhtZ4g41d4o9l19AhPCd4hD+ut
        Hlp5bj2nrozFFRMQ2sxQTha46Tt6AkGU98OJL2rQ/OCc9SSqESad4GV7YyKaHM/GIzWuwT
        ISyhUl8PKL3gko6/rOmEP4XlmO72MvAy4EpMtc1sG1s5JN2FtBw6p/S23jWP7V72oZHkiw
        aYQ+SHZu5ow15H47vVkXeuxxVQTeDy5s9yDzzboopF7GeVVcdEf7U4KU0ribyw==
Message-ID: <e6e2df31-6327-f2ad-3049-0cbfa214ae5c@hauke-m.de>
Date:   Mon, 6 Mar 2023 23:58:12 +0100
MIME-Version: 1.0
Content-Language: en-US
To:     stable <stable@vger.kernel.org>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Andres Freund <andres@anarazel.de>,
        Quentin Monnet <quentin@isovalent.com>, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: stable backport of patches fixing perf, libbpf and bpftools
 compilation with binutils 2.40
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

The following patches are fixing the compilation of perf, bpf_jit_disasm 
and bpftools with binutils 2.40.

commit cfd59ca91467056bb2c36907b2fa67b8e1af9952
Subject: tools build: Add feature test for init_disassemble_info API changes

commit a45b3d6926231c3d024ea0de4f7bd967f83709ee
Subject: tools include: add dis-asm-compat.h to handle version differences

commit 83aa0120487e8bc3f231e72c460add783f71f17c
Subject: tools perf: Fix compilation error with new binutils

commit 96ed066054abf11c7d3e106e3011a51f3f1227a3
Subject: tools bpf_jit_disasm: Fix compilation error with new binutils

commit 600b7b26c07a070d0153daa76b3806c1e52c9e00
Subject: tools bpftool: Fix compilation error with new binutils


Please backport these patches to kernel 5.15. Backporting them to 5.10 
resulted in more merge conflicts for me so I did not continue if it.


The patches are applying cleanly on top of 5.15.98 expect for a trivial 
merge conflict in the last one:
-----
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@@ -76,7 -93,7 +76,7 @@@ INSTALL ?= instal
   RM ?= rm -f

   FEATURE_USER = .bpftool
- FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib libcap \
  -FEATURE_TESTS = libbfd disassembler-four-args 
disassembler-init-styled zlib libcap \
++FEATURE_TESTS = libbfd disassembler-four-args disassembler-init-styled 
reallocarray zlib libcap \
         clang-bpf-co-re
   FEATURE_DISPLAY = libbfd disassembler-four-args zlib libcap \
         clang-bpf-co-re
-------

Hauke
