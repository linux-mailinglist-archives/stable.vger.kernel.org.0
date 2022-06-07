Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C64E54147E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358813AbiFGUS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376473AbiFGUQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:16:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0551CE7B6;
        Tue,  7 Jun 2022 11:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59282CE2452;
        Tue,  7 Jun 2022 18:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676CCC385A2;
        Tue,  7 Jun 2022 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626248;
        bh=IZMxjjab0MeqFDPuBR/inMNlodIgWB0ahUKVDgWxLpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g3F0FPIbrJPvDVgndqB1EPlJrRBzTDOObzM2q4Da7CWhyRwndUKBYQeJwxaRoYrbV
         2tjlICaTOCvhFq5kojKwtyH8pvhVxYrzb063K60I9vm8x+/75Hg89SWYICUsjmJGDd
         GpHS2diTeDxFdLLiddi9G9jmjFT8pIeoCihUdVd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 311/772] x86/speculation: Add missing prototype for unpriv_ebpf_notify()
Date:   Tue,  7 Jun 2022 18:58:23 +0200
Message-Id: <20220607164958.191727742@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 2147c438fde135d6c145a96e373d9348e7076f7f ]

Fix the following warnings seen with "make W=1":

  kernel/sysctl.c:183:13: warning: no previous prototype for ‘unpriv_ebpf_notify’ [-Wmissing-prototypes]
    183 | void __weak unpriv_ebpf_notify(int new_state)
        |             ^~~~~~~~~~~~~~~~~~

  arch/x86/kernel/cpu/bugs.c:659:6: warning: no previous prototype for ‘unpriv_ebpf_notify’ [-Wmissing-prototypes]
    659 | void unpriv_ebpf_notify(int new_state)
        |      ^~~~~~~~~~~~~~~~~~

Fixes: 44a3918c8245 ("x86/speculation: Include unprivileged eBPF status in Spectre v2 mitigation reporting")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/5689d065f739602ececaee1e05e68b8644009608.1650930000.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2f7e00e7af37..e78113f25b71 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2064,6 +2064,8 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 				       struct net_device *netdev);
 bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
 
+void unpriv_ebpf_notify(int new_state);
+
 #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
 int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
 
-- 
2.35.1



