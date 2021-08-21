Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239083F3C6B
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 22:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhHUUcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Aug 2021 16:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhHUUcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Aug 2021 16:32:04 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E359C061575
        for <stable@vger.kernel.org>; Sat, 21 Aug 2021 13:31:24 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 14so14774939qkc.4
        for <stable@vger.kernel.org>; Sat, 21 Aug 2021 13:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dC7iZ3XQNCXWUSOMZeB+F9Z0H7djlXOiTOUpRfzJVOA=;
        b=VrC6YnkFu4JpGmB/3Uj2kvbdPdPFLTlwdexawamhAnKVcX7w1KVSh4NT3ZB3mrUExO
         VLwzw2b5kQ4n+GO6Vrlbt0M2MI/R/7dMH/soISn60RbDVfefNcTaGWOuNGa21AaExafm
         gJ7DzfHEWUqxdDTfbD6SbnlA5vRg97Cq3wd3N+LFOl0Hwsjxrnm/rw+JZz5sgALFOxpa
         IZMuanY644K0NwibITnxTq/Z7zDuCqjOo98AqM6yUkCtTLVVlH7wfz9i/+AzRxqvtMXb
         A3R0zDpQvFJjCWqKG5XX67rAw33mA/7nUD6jL3EPFqL5SPQ8xeRhoQA4ELUSwTkuzAd1
         nIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dC7iZ3XQNCXWUSOMZeB+F9Z0H7djlXOiTOUpRfzJVOA=;
        b=YbJFgexZCpe4Jf3YvtGePhwqbSNY8+av3L/dGb2lm9dvBOUjxUqGQBPszvLmXVmAut
         YXfeTBZnUExqANyTLcKSU/30LO5AR0w3f4TgHQTsuRF4S60QUfrvEpDM+DgclrWJEGwQ
         rBzLlX5ZQfQcfSauEbikMQg5Xp6d7S2g6jDxBA9k07EJbcphw88ajkZd1SKL4zjWLsHD
         lHdRZefdQKGgzpsdS8JUC7a+gsfpTYVpUQWMG37qH2yST0ehgx19DN7FapwceVxX2QBX
         pBUdtLlbFMXhv5aXFXQJ93FBgS06M2CBk89N16nuOoJgyJK+gzkJobQDrXJVQqa516ZT
         2rEQ==
X-Gm-Message-State: AOAM533jFHEy6Ib4mSJrZeyK8yYcy6I3PI0MmAtHjNvHrNyv4Q+/Qt62
        vMd5d+2dYnpU6+/yuFIsyCEy3Ht8m1Pfyfs=
X-Google-Smtp-Source: ABdhPJxrw4PsMhjkUxgnLqIKXOlUuDk0fKOAnmsMZFp0GYPrPlkXx/29NmASLBE90/OAEYHXZ+I5UQ==
X-Received: by 2002:a05:620a:1aaa:: with SMTP id bl42mr13084935qkb.469.1629577883178;
        Sat, 21 Aug 2021 13:31:23 -0700 (PDT)
Received: from fujitsu.celeiro.cu ([191.177.175.120])
        by smtp.gmail.com with ESMTPSA id u189sm5348996qkh.14.2021.08.21.13.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 13:31:22 -0700 (PDT)
From:   Rafael David Tinoco <rafaeldtinoco@gmail.com>
To:     stable@vger.kernel.org
Cc:     rafaeldtinoco@gmail.com, andriin@fb.com, daniel@iogearbox.net,
        yanivagman@gmail.com
Subject: [PATCH] bpf: Track contents of read-only maps as scalars
Date:   Sat, 21 Aug 2021 17:31:07 -0300
Message-Id: <20210821203108.215937-1-rafaeldtinoco@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During tracee-ebpf regression tests, it was discovered that a CO-RE capable
eBPF program, that relied on a kconfig BTF extern, could not be loaded with
the following error:

libbpf: prog 'tracepoint__raw_syscalls__sys_enter': failed to attach to raw
 tracepoint 'sys_enter': Invalid argument

That happened because the CONFIG_ARCH_HAS_SYSCALL_WRAPPER variable had the
wrong value, despite kconfig map existing, misleading the eBPF program
execution (which would then have different pointers, not accepted by the
verifier during load time).

I got the patch proposed here by bisecting upstream tree with the testcase
just described. I kindly ask you to include this patch in the LTS v5.4.x
series so CO-RE (Compile Once - Run Everywhere) eBPF programs, relying in
kconfig settings, can be correctly loaded in kernel series v5.4.

Link: https://github.com/aquasecurity/tracee/issues/851#issuecomment-903074596

I have tested latest 5.4 stable tree with this patch and it fixes the issue.

-rafaeldtinoco


