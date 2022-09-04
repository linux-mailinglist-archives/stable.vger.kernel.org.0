Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D76A5AC470
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiIDNTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 09:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiIDNTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 09:19:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA71356EF;
        Sun,  4 Sep 2022 06:19:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77ED760F7F;
        Sun,  4 Sep 2022 13:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77BDC433C1;
        Sun,  4 Sep 2022 13:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662297545;
        bh=HOeYYQFTqRy9UEVoiNDAkUxmeiuv3da38DD9yxIHKVk=;
        h=From:To:Cc:Subject:Date:From;
        b=AECXyq1hQ2RzfEzzDGpiAN//gpvE1XYFYpGwAwTxZ+aiGDhy9EM/nDKaCk4s+dGMh
         ds3ocg77ac/BBr+7Iccyq3qmhzPeZ+wpipk1P71yldsHca++YPx30Ayo/t89fpG+t9
         JkVVoOm5hu+El+QO3ha2qIP+KRnIrjE1WSiC27yRyBcgt7iRZhroTUYg6z/o6MK72i
         xUpJoRrL+ouZHAoYgAALPhB5b/wKMzE+1m3swKOCe6Hu/GdjLsajke9Fi//qyAXc+j
         6aRSRsY13ENnTlhWBLW28nKEmIWXh3VR2A5nknyQB72apR1erUpbMxnInwpXTWqtqR
         bxwczWF2/Mp8Q==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH stable 5.15 0/2] kbuild: Fix compilation for latest pahole release
Date:   Sun,  4 Sep 2022 15:18:59 +0200
Message-Id: <20220904131901.13025-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hi,
new version of pahole (1.24) is causing compilation fail for 5.15
stable kernel, discussed in here [1][2]. Sending fix for that plus
one dependency patch.

Note for patch 1:
there was one extra line change in scripts/pahole-flags.sh file in
its linux tree merge commit:

  fc02cb2b37fe Merge tag 'net-next-for-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next

not sure how/if to track that, I squashed the change in.

thanks,
jirka


[1] https://lore.kernel.org/bpf/20220825163538.vajnsv3xcpbhl47v@altlinux.org/
[2] https://lore.kernel.org/bpf/YwQRKkmWqsf%2FDu6A@kernel.org/
---
Jiri Olsa (1):
      kbuild: Unify options for BTF generation for vmlinux and modules

Martin Rodriguez Reboredo (1):
      kbuild: Add skip_encoding_btf_enum64 option to pahole

 Makefile                  |  3 +++
 scripts/Makefile.modfinal |  2 +-
 scripts/link-vmlinux.sh   | 11 +----------
 scripts/pahole-flags.sh   | 24 ++++++++++++++++++++++++
 4 files changed, 29 insertions(+), 11 deletions(-)
 create mode 100755 scripts/pahole-flags.sh
