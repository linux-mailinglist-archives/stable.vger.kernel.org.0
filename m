Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F395E6184
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 13:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiIVLna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 07:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiIVLnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 07:43:08 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2995FCA7B;
        Thu, 22 Sep 2022 04:42:51 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id ECD2961EA192A;
        Thu, 22 Sep 2022 13:42:48 +0200 (CEST)
Message-ID: <ae96779e-e3a7-b4b5-78fc-e5b53d456ece@molgen.mpg.de>
Date:   Thu, 22 Sep 2022 13:42:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: nfs_scan_commit: BUG: unable to handle page fault for address:
 000000001d473c07
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org,
        stable@vger.kernel.org, it+linux-nfs@molgen.mpg.de
References: <c5d8485b-0dbc-5192-4dc6-10ef2b86b520@molgen.mpg.de>
 <e845f65cb78d31aa1982da4bc752ee2e5191f10f.camel@hammerspace.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <e845f65cb78d31aa1982da4bc752ee2e5191f10f.camel@hammerspace.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Trond,


Thank you for the quick reply.

Am 21.09.22 um 14:44 schrieb Trond Myklebust:

> On Wed, 2022-09-21 at 13:42 +0200, Paul Menzel wrote:

>> Moving from Linux 5.10.113 to 5.15.69, starting Mozilla Thunderbird or
>> Mozilla Firefox with the home on NFS, both programs get killed, and
>> Linux 5.15.69 logs:
>>
>> ```
>> [ 3827.604396] BUG: unable to handle page fault for address: 000000001d473c07
>> [ 3827.611297] #PF: supervisor read access in kernel mode
>> [ 3827.616452] #PF: error_code(0x0000) - not-present page
>> [ 3827.621604] PGD 0 P4D 0
>> [ 3827.624152] Oops: 0000 [#1] SMP PTI
>> [ 3827.627657] CPU: 0 PID: 2378 Comm: firefox Not tainted 5.15.69.mx64.435 #1
>> [ 3827.634551] Hardware name: Dell Inc. Precision Tower 3620/0MWYPT, BIOS 2.20.0 12/09/2021

[…]

>> [ 3827.743328] Call Trace:
>> [ 3827.745779]  <TASK>
>> [ 3827.747883]  nfs_scan_commit+0x76/0xb0 [nfs]
>> [ 3827.752167]  __nfs_commit_inode+0x108/0x180 [nfs]
>> [ 3827.756886]  nfs_wb_all+0x59/0x110 [nfs]
>> [ 3827.760822]  nfs4_inode_return_delegation+0x58/0x90 [nfsv4]
>> [ 3827.766413]  nfs4_proc_remove+0x101/0x110 [nfsv4]
>> [ 3827.771130]  nfs_unlink+0xf5/0x2d0 [nfs]
>> [ 3827.775065]  vfs_unlink+0x10b/0x280
>> [ 3827.778563]  do_unlinkat+0x19e/0x2c0
>> [ 3827.782158]  __x64_sys_unlink+0x3e/0x60
>> [ 3827.786002]  ? __x64_sys_readlink+0x1b/0x30
>> [ 3827.790192]  do_syscall_64+0x40/0x90
>> [ 3827.793779]  entry_SYSCALL_64_after_hwframe+0x61/0xcb

[…]

>> ```
>>
> 
> Does cherry-picking commit 6e176d47160c ("NFSv4: Fixes for
> nfs4_inode_return_delegation()") into 5.15.69 from the upstream kernel
> tree fix the problem?
> 
> 8<---------------------------------------------------
> From 6e176d47160cec8bcaa28d9aa06926d72d54237c Mon Sep 17 00:00:00 2001
> From: Trond Myklebust <trond.myklebust@hammerspace.com>
> Date: Sun, 10 Oct 2021 10:58:12 +0200
> Subject: [PATCH] NFSv4: Fixes for nfs4_inode_return_delegation()

[…]

Indeed with that commit, present since v5.16-rc1, we are unable to 
reproduce the issue, so it seems to be the fix. It looks like there are 
not a lot of 5.15 NFS users out there. ;-)


Kind regards,

Paul
