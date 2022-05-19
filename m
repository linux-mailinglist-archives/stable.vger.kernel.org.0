Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329CE52C938
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 03:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiESB3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 21:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiESB3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 21:29:24 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF618CCE1;
        Wed, 18 May 2022 18:29:22 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24J1T6ph002793
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 21:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652923748; bh=OwjLTMn2PuGFeAIsLetixKvIq5c7/uD5XORSp3PLcxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=PhSf84hB76c30vwFs++nRxvshBAzCAOfTgpdj2TlminIgdxF1wxGVGwHd3GnRwDBD
         jB2gFvtfv5oy8ega6ruzfn8LPD2jRU00mjegcycBzMZqQiSgx40hBEllP65zpfB6+L
         83Nsi0kWkw+CmlHEcxWotqQfaRCabrqqn9hY477EYWoO0u9aCo3qJtX86uGxMkoeJ8
         QitxdpR088NPWOctu53JVa6JJZ8qzjJAJOQ0dN88MRSTLZEE/VWGf9JTYRvWiYA5Lw
         roaTuwAd0M6dr9wirqanNdefpe+3OKNTo5aHScke9fmIXIANMX9/rw0n5c51bNN8BC
         eLXTQakBd9STA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 38B7A15C3EC0; Wed, 18 May 2022 21:29:06 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Baokun Li <libaokun1@huawei.com>, linux-ext4@vger.kernel.org
Cc:     "Theodore Ts'o" <tytso@mit.edu>, yebin10@huawei.com,
        yukuai3@huawei.com, yi.zhang@huawei.com, jack@suse.cz,
        adilger.kernel@dilger.ca, Hulk Robot <hulkci@huawei.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: fix race condition between ext4_write and ext4_convert_inline_data
Date:   Wed, 18 May 2022 21:29:04 -0400
Message-Id: <165292370259.1197022.17166433087491869557.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220428134031.4153381-1-libaokun1@huawei.com>
References: <20220428134031.4153381-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 Apr 2022 21:40:31 +0800, Baokun Li wrote:
> Hulk Robot reported a BUG_ON:
>  ==================================================================
>  EXT4-fs error (device loop3): ext4_mb_generate_buddy:805: group 0,
>  block bitmap and bg descriptor inconsistent: 25 vs 31513 free clusters
>  kernel BUG at fs/ext4/ext4_jbd2.c:53!
>  invalid opcode: 0000 [#1] SMP KASAN PTI
>  CPU: 0 PID: 25371 Comm: syz-executor.3 Not tainted 5.10.0+ #1
>  RIP: 0010:ext4_put_nojournal fs/ext4/ext4_jbd2.c:53 [inline]
>  RIP: 0010:__ext4_journal_stop+0x10e/0x110 fs/ext4/ext4_jbd2.c:116
>  [...]
>  Call Trace:
>   ext4_write_inline_data_end+0x59a/0x730 fs/ext4/inline.c:795
>   generic_perform_write+0x279/0x3c0 mm/filemap.c:3344
>   ext4_buffered_write_iter+0x2e3/0x3d0 fs/ext4/file.c:270
>   ext4_file_write_iter+0x30a/0x11c0 fs/ext4/file.c:520
>   do_iter_readv_writev+0x339/0x3c0 fs/read_write.c:732
>   do_iter_write+0x107/0x430 fs/read_write.c:861
>   vfs_writev fs/read_write.c:934 [inline]
>   do_pwritev+0x1e5/0x380 fs/read_write.c:1031
>  [...]
>  ==================================================================
> 
> [...]

Applied, thanks!

[1/1] ext4: fix race condition between ext4_write and ext4_convert_inline_data
      commit: f87c7a4b084afc13190cbb263538e444cb2b392a

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
