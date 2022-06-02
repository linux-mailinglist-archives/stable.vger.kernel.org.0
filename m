Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755AD53BCDF
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 18:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbiFBQxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 12:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbiFBQxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 12:53:08 -0400
Received: from mailout.rz.uni-frankfurt.de (mailout.rz.uni-frankfurt.de [141.2.22.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5942C280B0D
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 09:53:07 -0700 (PDT)
Received: from smtpauth1.cluster.uni-frankfurt.de ([10.1.1.45])
        by mailout.rz.uni-frankfurt.de with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nwnT9-0003CR-VS; Thu, 02 Jun 2022 18:14:43 +0200
Received: from p57bcf53e.dip0.t-ipconnect.de ([87.188.245.62] helo=[192.168.2.17])
        by smtpauth1.cluster.uni-frankfurt.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nwnT9-0001EX-Th; Thu, 02 Jun 2022 18:14:43 +0200
Message-ID: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
Date:   Thu, 2 Jun 2022 18:14:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   Thomas Sattler <sattler@med.uni-frankfurt.de>
Subject: boot loop since 5.17.6
Cc:     regressions@lists.linux.dev
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi there ...

summary: boot loop after upgrading from 5.17.5 to 5.17.6

I have a Gentoo Desktop where I was successfully running a self
compiled vanilla 5.17.5 kernel. After upgrading to 5.17.12 the
machine was unable to boot: lilo loads the kernel and the intel
microcode 20220510_p20220508 (/boot/intel-uc.img) as an initrd.
Then the monitor turns black and a few moments later the BIOS
logo is shown, followed by lilo.


As there was a recent microcode upgrade I first tried to boot
without it. But that didn't help.

Then I tried to boot other already compiled but not yet booted
kernels 5.17.9 and 5.17.6 without any success. Booting the old
5.17.5 still worked. So I compiled 5.18.1 but that also was
unable to boot.


Then I tried to do a "manual bisecting" with patch-5.17.5-6
and found that the machine is still booting with 197 of 209
diffs applied.

After applying "patch-5.17.5-6.part198.patch" compilation is
broken. Still after applying "patch-5.17.5-6.part199.patch".
After applying "patch-5.17.5-6.part200.patch", compilation
works again but the resulting kernel now fails to boot.


It is an (up to date) Gentoo System, installed ~15 years
ago, running a 64Bit kernel with a 32Bit userland. The
hardware is newer then the installation (i5-7400).

I have to mention that the machine is in a remote location.
With lilo allowing a "default kernel" as well as a kernel
to be booted "just once", I was able to try the above from
remote.

Thomas
