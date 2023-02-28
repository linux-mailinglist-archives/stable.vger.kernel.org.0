Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895CF6A5CEF
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 17:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjB1QRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 11:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjB1QRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 11:17:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E902B613;
        Tue, 28 Feb 2023 08:17:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D4F96115D;
        Tue, 28 Feb 2023 16:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5051BC433EF;
        Tue, 28 Feb 2023 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677601038;
        bh=SdiaPWkoz1Wlu+wvf5yCwuvk9Us7VxrRsrTMSHhg2Vo=;
        h=Date:From:To:Cc:Subject:From;
        b=cJrT2mSLpkUuf+5idWfdfRNffhCFS5HyC0kpAiD+NZZFe8OG/az9+G3msDTmqgraj
         XO3A4SWM2vcw/usBwX3zWf+Ce9wriiKv+1kbgLiolGwF7VA683i+KjQ+Mi7mhQXuQs
         NzuDRXEm+YzAdQvEoTcLKg0j35ZQ96xVYuO/adlhd797IV/n3j/V8Wpwc5k188S3oc
         Etdlpo9+2H8JhiOcQOwqqRZsxEd/KR0QBleq9j6VijgOmtMCe52fGBT10bDSbZGCYY
         9GGZnAHF+iBBUSMaBn7M+x7VJI/eGuCcNgOkVOLOSdIVqVZQiee62m/mh09qqhwm1n
         3OQku2HugiR0w==
Date:   Tue, 28 Feb 2023 09:17:16 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Please apply 4e4a08868f15897ca236528771c3733fded42c62 to linux-6.2.y
Message-ID: <Y/4pDMRFfQLyijQq@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

Please apply commit 4e4a08868f15 ("crypto: arm64/sm4-gcm - Fix possible crash
in GCM cryption") to 6.2, as it fixes a crash that I see when booting Arch
Linux ARM's aarch64 configuration [1] in QEMU:

[    1.512110] Unable to handle kernel paging request at virtual address fffffe000024d588
[    1.512357] Mem abort info:
[    1.512542]   ESR = 0x0000000097c38004
[    1.512695]   EC = 0x25: DABT (current EL), IL = 32 bits
[    1.512863]   SET = 0, FnV = 0
[    1.512967]   EA = 0, S1PTW = 0
[    1.513075]   FSC = 0x04: level 0 translation fault
[    1.513236] Data abort info:
[    1.513343]   Access size = 8 byte(s)
[    1.513618]   SSE = 0, SRT = 3
[    1.513721]   SF = 1, AR = 0
[    1.513824]   CM = 0, WnR = 0
[    1.513964] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000041ef8000
[    1.514162] [fffffe000024d588] pgd=0000000000000000, p4d=0000000000000000
[    1.514932] Internal error: Oops: 0000000097c38004 [#1] PREEMPT SMP
[    1.515206] Modules linked in:
[    1.515477] CPU: 0 PID: 113 Comm: cryptomgr_test Not tainted 6.2.1-ARCH #1
[    1.515755] Hardware name: linux,dummy-virt (DT)
[    1.516029] pstate: a1400009 (NzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[    1.516277] pc : kfree+0x30/0xb0
[    1.516766] lr : skcipher_walk_done+0x198/0x2b0
[    1.516934] sp : ffff80000ace3820
[    1.517042] x29: ffff80000ace3820 x28: 0000000000000000 x27: 0000000000000400
[    1.517316] x26: ffff80000937d880 x25: ffff0000034d0400 x24: ffff0000036efe00
[    1.517557] x23: ffff800008088730 x22: ffff0000036efd00 x21: ffff80000ace3998
[    1.517791] x20: 0000000000000000 x19: ffff80000ace3900 x18: ffffffffffffffff
[    1.518022] x17: 0000000000000000 x16: 0000000000000000 x15: ffffffffffffffff
[    1.518263] x14: ffff80008ace3ce7 x13: 0000000000000000 x12: 0000000000000000
[    1.518510] x11: ffff80000ace38c8 x10: ffff80000ace38d0 x9 : 0000000000000001
[    1.518757] x8 : 0000000000000000 x7 : ffff80000ace38a8 x6 : 0000000000000001
[    1.518993] x5 : ffff80000ace3998 x4 : fffffc0000000000 x3 : ffff80000ace3b00
[    1.519242] x2 : 000002000024d580 x1 : ffff800009356218 x0 : fffffe000024d580
[    1.519549] Call trace:
[    1.519654]  kfree+0x30/0xb0
[    1.519785]  skcipher_walk_done+0x198/0x2b0
[    1.519931]  gcm_crypt+0xd8/0x170
[    1.520047]  gcm_encrypt+0x90/0xbc
[    1.520153]  crypto_aead_encrypt+0x24/0x40
[    1.520285]  test_aead_vec_cfg+0x21c/0x770
[    1.520422]  test_aead+0xb4/0x140
[    1.520538]  alg_test_aead+0x94/0x190
[    1.520662]  alg_test+0x34c/0x520
[    1.520770]  cryptomgr_test+0x24/0x44
[    1.520889]  kthread+0xe4/0xf0
[    1.520993]  ret_from_fork+0x10/0x20
[    1.521300] Code: b25657e4 d34cfc42 d37ae442 8b040040 (f9400403)
[    1.521691] ---[ end trace 0000000000000000 ]---

[1]: https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/linux-aarch64/config

Cheers,
Nathan
