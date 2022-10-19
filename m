Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCBF604862
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiJSN4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbiJSNyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF6D1C25C0;
        Wed, 19 Oct 2022 06:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42E9CB823DE;
        Wed, 19 Oct 2022 08:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C69C433B5;
        Wed, 19 Oct 2022 08:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666169771;
        bh=ng76K4N2fuUGk4I1JMwOArtnth+j1G2paRsYl7PIp8Y=;
        h=From:To:Cc:Subject:Date:From;
        b=cSSCa0JrVjez2ZxUnZ1hi2RPgW+o44fYVvnvWPsP8t1bdEzKTlujLkO5dB5m+3FE1
         oSTHpODME4seO7J7E9sP0lsRM5Df53M3EF6oEaN4eUvBAT+/KOon8LGwa95ektRYfV
         1yyhNoRmWD04Pe54Kewpb/u3tiNjxMPXwDpT+wgaIF/I55M6iVoLbstsM66VyEmQD2
         6EIaYed9QkWA6cNGe8whxWId5+0hc1ulAukmhyLib92ta90m3DTHes57qY1iZ7Oawj
         ZL3cSCkSHpcbN81URyxheDLe/nNELLyqiBTiwE0jUkfLJiFA1wSas0I6OfHWZpAE6d
         xDK88CyHekuIA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>
Subject: [PATCH stable 5.10 0/5] kbuild: Fix compilation for latest pahole release
Date:   Wed, 19 Oct 2022 10:55:59 +0200
Message-Id: <20221019085604.1017583-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hi,
new version of pahole (1.24) is causing compilation fail for 5.10
stable kernel, discussed in here [1][2]. Sending fix for that plus
dependency patches.

thanks,
jirka


[1] https://lore.kernel.org/bpf/20220825163538.vajnsv3xcpbhl47v@altlinux.org/
[2] https://lore.kernel.org/bpf/YwQRKkmWqsf%2FDu6A@kernel.org/
---
Andrii Nakryiko (1):
      kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21

Ilya Leoshkevich (1):
      bpf: Generate BTF_KIND_FLOAT when linking vmlinux

Javier Martinez Canillas (1):
      kbuild: Quote OBJCOPY var to avoid a pahole call break the build

Jiri Olsa (1):
      kbuild: Unify options for BTF generation for vmlinux and modules

Martin Rodriguez Reboredo (1):
      kbuild: Add skip_encoding_btf_enum64 option to pahole

 Makefile                |  3 +++
 scripts/link-vmlinux.sh |  2 +-
 scripts/pahole-flags.sh | 21 +++++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)
 create mode 100755 scripts/pahole-flags.sh
