Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874625A8E04
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 08:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiIAGMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 02:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiIAGMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 02:12:41 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C105F1195E5;
        Wed, 31 Aug 2022 23:12:38 -0700 (PDT)
Message-ID: <1f035daa-1905-1edd-687e-2426f6bda90e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662012755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LylrUWZZwGt8NJUNyP64kxnBFR3e4U6j0g2p8eJuHKQ=;
        b=aLIhVBUyVumYoO28x11m2Yn6HDwi3I3UX14mp2qgawMDsnrb2quaQgN4pGIivbKqifTOAf
        XN0cLu8ZLLkur/d+VTEox1iArLrChWh2R0kmP0uS95w1A5D8ON29ruUYCP38YE1MGlKpbR
        xoOStJeMAX6Q6GKXv5OnwfO4eh7ISvc=
Date:   Thu, 1 Sep 2022 14:12:23 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] scsi: mpt3sas: Fix NULL pointer crash due to missing
 check device hostdata
Content-Language: en-US
To:     huhai <15815827059@163.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        huhai <huhai@kylinos.cn>, stable@vger.kernel.org
References: <20220825092645.326953-1-15815827059@163.com>
 <49b0768d.96d.182f69a26f6.Coremail.15815827059@163.com>
 <CAFdVvOzAWcFLgPi_y8HW5Jx5JbC1AgBtADnwvd9usq8veU0vOg@mail.gmail.com>
 <3b74287a.3728.182f7a604b3.Coremail.15815827059@163.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jackie Liu <liu.yun@linux.dev>
In-Reply-To: <3b74287a.3728.182f7a604b3.Coremail.15815827059@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hu hai:

I think Sathya means this:

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c 
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index def37a7e5980..2a8c1fef1d34 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5704,27 +5704,31 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 
smid, u8 msix_index, u32 reply)
         struct MPT3SAS_DEVICE *sas_device_priv_data;
         u32 response_code = 0;

-       mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
-
         scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
         if (scmd == NULL)
                 return 1;

+       sas_device_priv_data = scmd->device->hostdata;
+       if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
+               scmd->result = DID_NO_CONNECT << 16;
+               goto out;
+       }
+
         _scsih_set_satl_pending(scmd, false);

+       if (sas_device_priv_data->sas_target->deleted) {
+               scmd->result = DID_NO_CONNECT << 16;
+               goto out;
+       }
+
         mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);

+       mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
         if (mpi_reply == NULL) {
                 scmd->result = DID_OK << 16;
                 goto out;
         }

-       sas_device_priv_data = scmd->device->hostdata;
-       if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
-            sas_device_priv_data->sas_target->deleted) {
-               scmd->result = DID_NO_CONNECT << 16;
-               goto out;
-       }
         ioc_status = le16_to_cpu(mpi_reply->IOCStatus);

         /*

-- 
Jackie Liu


在 2022/9/1 14:03, huhai 写道:
> 
> At 2022-09-01 13:08:14, "Sathya Prakash Veerichetty" <sathya.prakash@broadcom.com> wrote:
>> The patch could be improved to clear the ata_cmd_pending bit for the
>> cases !sas_device_priv_data->sas_target and
>> sas_device_priv_data->sas_target->deleted before returning
> 
>> DID_NO_CONNECT to retain the current functionality.
> 
> Hi,
> 
> Maybe my commit information is not clear enough，This patch is fixed NULL pointer crash
> duto to "struct MPT3SAS_DEVICE *priv = scmd->device->hostdata;"  got a NULL pointer, and
> when "clear_bit(0, &priv->ata_command_pending);" is called, kernel will panic.
> 
> Thanks
> 
>>
>>
>> On Wed, Aug 31, 2022 at 7:11 PM huhai <15815827059@163.com> wrote:
>>>
>>> Friendly ping.
>>>
>>>
>>> At 2022-08-25 17:26:45, "huhai" <15815827059@163.com> wrote:
>>>> From: huhai <huhai@kylinos.cn>
>>>>
>>>> If _scsih_io_done() is called with scmd->device->hostdata=NULL, it can lead
>>>> to the following panic:
>>>>
>>>>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
>>>>   PGD 4547a4067 P4D 4547a4067 PUD 0
>>>>   Oops: 0002 [#1] SMP NOPTI
>>>>   CPU: 62 PID: 0 Comm: swapper/62 Kdump: loaded Not tainted 4.19.90-24.4.v2101.ky10.x86_64 #1
>>>>   Hardware name: Storage Server/65N32-US, BIOS SQL1041217 05/30/2022
>>>>   RIP: 0010:_scsih_set_satl_pending+0x2d/0x50 [mpt3sas]
>>>>   Code: 00 00 48 8b 87 60 01 00 00 0f b6 10 80 fa a1 74 09 31 c0 80 fa 85 74 02 f3 c3 48 8b 47 38 40 84 f6 48 8b 80 98 00 00 00 75 08 <f0> 80 60 18 fe 31 c0 c3 f0 48 0f ba 68 18 00 0f 92 c0 0f b6 c0 c3
>>>>   RSP: 0018:ffff8ec22fc03e00 EFLAGS: 00010046
>>>>   RAX: 0000000000000000 RBX: ffff8eba1b072518 RCX: 0000000000000001
>>>>   RDX: 0000000000000085 RSI: 0000000000000000 RDI: ffff8eba1b072518
>>>>   RBP: 0000000000000dbd R08: 0000000000000000 R09: 0000000000029700
>>>>   R10: ffff8ec22fc03f80 R11: 0000000000000000 R12: ffff8ebe2d3609e8
>>>>   R13: ffff8ebe2a72b600 R14: ffff8eca472707e0 R15: 0000000000000020
>>>>   FS:  0000000000000000(0000) GS:ffff8ec22fc00000(0000) knlGS:0000000000000000
>>>>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>   CR2: 0000000000000018 CR3: 000000046e5f6000 CR4: 00000000003406e0
>>>>   Call Trace:
>>>>    <IRQ>
>>>>    _scsih_io_done+0x4a/0x9f0 [mpt3sas]
>>>>    _base_interrupt+0x23f/0xe10 [mpt3sas]
>>>>    __handle_irq_event_percpu+0x40/0x190
>>>>    handle_irq_event_percpu+0x30/0x70
>>>>    handle_irq_event+0x36/0x60
>>>>    handle_edge_irq+0x7e/0x190
>>>>    handle_irq+0xa8/0x110
>>>>    do_IRQ+0x49/0xe0
>>>>
>>>> Fix it by move scmd->device->hostdata check before _scsih_set_satl_pending
>>>> called.
>>>>
>>>> Other changes:
>>>> - It looks clear to move get mpi_reply to near its check.
>>>>
>>>> Fixes: ffb584565894 ("scsi: mpt3sas: fix hang on ata passthrough commands")
>>>> Cc: <stable@vger.kernel.org> # v4.9+
>>>> Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
>>>> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
>>>> Signed-off-by: huhai <huhai@kylinos.cn>
>>>> ---
>>>> drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +++++++--------
>>>> 1 file changed, 7 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>>>> index def37a7e5980..85f5749a0421 100644
>>>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>>>> @@ -5704,27 +5704,26 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>>>>        struct MPT3SAS_DEVICE *sas_device_priv_data;
>>>>        u32 response_code = 0;
>>>>
>>>> -      mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
>>>> -
>>>>        scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>>>>        if (scmd == NULL)
>>>>                return 1;
>>>>
>>>> +      sas_device_priv_data = scmd->device->hostdata;
>>>> +      if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
>>>> +           sas_device_priv_data->sas_target->deleted) {
>>>> +              scmd->result = DID_NO_CONNECT << 16;
>>>> +              goto out;
>>>> +      }
>>>>        _scsih_set_satl_pending(scmd, false);
>>>>
>>>>        mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
>>>>
>>>> +      mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
>>>>        if (mpi_reply == NULL) {
>>>>                scmd->result = DID_OK << 16;
>>>>                goto out;
>>>>        }
>>>>
>>>> -      sas_device_priv_data = scmd->device->hostdata;
>>>> -      if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
>>>> -           sas_device_priv_data->sas_target->deleted) {
>>>> -              scmd->result = DID_NO_CONNECT << 16;
>>>> -              goto out;
>>>> -      }
>>>>        ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
>>>>
>>>>        /*
>>>> --
>>>> 2.27.0
>>>>
>>>>
>>>> No virus found
>>>>                Checked by Hillstone Network AntiVirus
>>
>> -- 
>> This electronic communication and the information and any files transmitted
>> with it, or attached to it, are confidential and are intended solely for
>> the use of the individual or entity to whom it is addressed and may contain
>> information that is confidential, legally privileged, protected by privacy
>> laws, or otherwise restricted from disclosure to anyone else. If you are
>> not the intended recipient or the person responsible for delivering the
>> e-mail to the intended recipient, you are hereby notified that any use,
>> copying, distributing, dissemination, forwarding, printing, or copying of
>> this e-mail is strictly prohibited. If you received this e-mail in error,
>> please return the e-mail to the sender, delete it from your computer, and
>> destroy any printed copy of it.
