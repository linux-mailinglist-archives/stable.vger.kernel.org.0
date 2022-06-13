Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19EA54861A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352198AbiFMLQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352404AbiFMLNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:13:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83A435A82;
        Mon, 13 Jun 2022 03:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62FE1B80E5C;
        Mon, 13 Jun 2022 10:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB7CC34114;
        Mon, 13 Jun 2022 10:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116569;
        bh=C4kDou8I29eIE8rVKxtjEVm2kxixY73bhMzluB54pbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMgT0x+vb8cORx7VFsWCpcc1B2Q8QSz9faDqdxJTq1EbNTlUhw4/8YGmf+d6WhXM4
         29rluDgoApOr50bCf4IPREGL9g4FP4RcRRASXfboOvVKjuKaxd48oJ1O05Qil+G6kx
         VF7yOUH+p5XZ2aczhmVnWqn5EMUdsRUdFJa4Y4/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/411] x86/speculation: Add missing prototype for unpriv_ebpf_notify()
Date:   Mon, 13 Jun 2022 12:06:23 +0200
Message-Id: <20220613094931.972349336@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index a73ca7c9c7d0..5705cda3c4c4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -929,6 +929,8 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 				       struct net_device *netdev);
 bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
 
+void unpriv_ebpf_notify(int new_state);
+
 #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
 int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
 
-- 
2.35.1



