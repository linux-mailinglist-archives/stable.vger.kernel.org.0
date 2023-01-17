Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFF666DD4D
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 13:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbjAQMPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 07:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbjAQMPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 07:15:24 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A092A173;
        Tue, 17 Jan 2023 04:15:22 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id E671E61CC40F9;
        Tue, 17 Jan 2023 13:15:18 +0100 (CET)
Message-ID: <90dab560-da68-6fa1-57e5-7afa8aedfe4c@molgen.mpg.de>
Date:   Tue, 17 Jan 2023 13:15:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [5.15] Backport commit 0c25422d34b4 (scsi: mpt3sas: Remove
 scsi_dma_map() error messages)
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     stable@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>, regressions@lists.linux.dev,
        Christoph Hellwig <hch@lst.de>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Pittman <jpittman@redhat.com>, linux-scsi@vger.kernel.org,
        it+linux-scsi@molgen.mpg.de,
        Laurence Oberman <loberman@redhat.com>, djeffery@redhat.com
References: <693e9047-f52a-b426-616a-6157505e5165@molgen.mpg.de>
In-Reply-To: <693e9047-f52a-b426-616a-6157505e5165@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Cc: +loberman@redhat.com, +djeffery@redhat.com]

Am 16.01.23 um 15:23 schrieb Paul Menzel:
> Dear Linux folks,
> 
> 
> Could you please apply commit 0c25422d34b4 (scsi: mpt3sas: Remove 
> scsi_dma_map() error messages) to the 5.15.y series?
> 
> commit 0c25422d34b4726b2707d5f38560943155a91b80
> Author: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> Date:   Thu Mar 3 19:32:03 2022 +0530
> 
>      scsi: mpt3sas: Remove scsi_dma_map() error messages
> 
>      When scsi_dma_map() fails by returning a sges_left value less than zero,
>      the amount of logging produced can be extremely high.  In a recent end-user
>      environment, 1200 messages per second were being sent to the log buffer.
>      This eventually overwhelmed the system and it stalled.
> 
>      These error messages are not needed. Remove them.
> 
>      Link: https://lore.kernel.org/r/20220303140203.12642-1-sreekanth.reddy@broadcom.com
>      Suggested-by: Christoph Hellwig <hch@lst.de>
>      Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
>      Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> We see this regression after upgrading from Linux 5.10 to 5.15 on our 
> file servers with Broadcom/LSI SAS3008 PCI-Express Fusion-MPT SAS-3 
> (mpt3sas) – though luckily our systems do not stall/crash.
> 
> The commit message does not say anything about, what commit caused these 
> error to be appearing – the log statements have been there since 
> v4.20-rc1, if I am not mistaken, so it must be something else –, and 
> also do not mention, why these log messages are not needed, but the new 
> error condition is actually expected.
> 
> In the Canonical/Ubuntu bug tracker I found the explanation below [2].
> 
>> 2. mpt3sas: Remove scsi_dma_map errors messages:
>> When driver set the DMA mask to 32bit then we observe that the
>> SWIOTLB bounce buffers are getting exhausted quickly. For most of the
>> IOs driver observe that scsi_dma_map() API returned with failure
>> status and hence driver was printing below error message. Since this
>> error message is getting printed per IO and if user issues heavy IOs
>> then we observe that kernel overwhelmed with this error message. Also
>> we will observe the kernel panic when the serial console is enabled.
>> So to limit this issue, we removed this error message though this
>> patch.
>> "scsi_dma_map failed: request for 1310720 bytes!"
> 
> The Launchpad issue was created in March 2022, and the fixed Linux 
> kernel package 5.15.0-53.59 for Ubuntu 22.04 released on November 15th, 
> 2022.
> 
> Sreekanth, looking again, you are the patch author, one of the Broadcom 
> maintainers (LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)) and created the 
> Launchpad bug report. I am surprised you didn’t get it backported upstream.
> 
> 
> Kind regards,
> 
> Paul
> 
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=master&id=0c25422d34b4726b2707d5f38560943155a91b80
> [2]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1965927
>      "[Ubuntu 22.04] mpt3sas: Request to include latest bug fix patches"
