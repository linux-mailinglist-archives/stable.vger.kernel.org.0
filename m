Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E4464EBA5
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 13:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiLPM4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 07:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLPM4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 07:56:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDC55214F;
        Fri, 16 Dec 2022 04:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 747CDB81D68;
        Fri, 16 Dec 2022 12:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A75C433D2;
        Fri, 16 Dec 2022 12:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671195392;
        bh=Kfk+UEFE+ijLIP41HA1GWCB8AUCuf4+FnPJwzOyV3To=;
        h=From:To:Cc:Subject:Date:From;
        b=S2ZGmRq9qGE+iQT51n0AAdkLJUatim4QW8zE5B2Y5OcFY5f1KnUivL0GWZrBc8tjC
         64/dd+Klb960/xCMP6tIx+wzfqBip2fH7C5gBCeGc6bCbl/urRCIK/H3W7McgT8Yc4
         WMmG0+w96raTZ5xy0YEdMjKrt7sxdyl8EgeSGqfNkcDxRa8Qntp2VJN+6Pwy0Ojen/
         DD6RYoCcSXWx7mFHaNXP0LWVyMJAYFA3K8a+zqwdj1a/717hZIVORk858otbnWyEAB
         w+P0NeXuKVlOcN87HsDTs97nCrplV6DbSuSKx/45mUWNiV7yGwS/Yvdu/fwlI0AcBQ
         /b2DMQydGoW/g==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Martynas Pumputis <m@lambda.lt>
Subject: [PATCH stable 6.0 0/8] bpf: Fix kprobe_multi link attachment to kernel modules
Date:   Fri, 16 Dec 2022 13:56:20 +0100
Message-Id: <20221216125628.1622505-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hi,
sending fixes for attaching bpf kprobe_multi link to kernel
modules for stable 6.0. It all applies cleanly. 

thanks,
jirka


---
Jiri Olsa (8):
      kallsyms: Make module_kallsyms_on_each_symbol generally available
      ftrace: Add support to resolve module symbols in ftrace_lookup_symbols
      bpf: Rename __bpf_kprobe_multi_cookie_cmp to bpf_kprobe_multi_addrs_cmp
      bpf: Take module reference on kprobe_multi link
      selftests/bpf: Add load_kallsyms_refresh function
      selftests/bpf: Add bpf_testmod_fentry_* functions
      selftests/bpf: Add kprobe_multi check to module attach test
      selftests/bpf: Add kprobe_multi kmod attach api tests

 include/linux/module.h                                             |  9 ++++++++
 kernel/module/kallsyms.c                                           |  2 --
 kernel/trace/bpf_trace.c                                           | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/trace/ftrace.c                                              | 16 +++++++++-----
 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c              | 24 +++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_testmod_test.c | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/module_attach.c             |  7 +++++++
 tools/testing/selftests/bpf/progs/kprobe_multi.c                   | 50 +++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_module_attach.c             |  6 ++++++
 tools/testing/selftests/bpf/trace_helpers.c                        | 20 +++++++++++-------
 tools/testing/selftests/bpf/trace_helpers.h                        |  2 ++
 11 files changed, 306 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_testmod_test.c
