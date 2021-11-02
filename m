Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F09442567
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 03:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhKBCFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 22:05:05 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:48299 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhKBCFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 22:05:04 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2021 22:05:04 EDT
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 26CC92EA40E;
        Mon,  1 Nov 2021 21:56:01 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id YUyp_3wp9qgl; Mon,  1 Nov 2021 21:56:00 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 6E7532EA0BD;
        Mon,  1 Nov 2021 21:56:00 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: core: initialize cmd->cmnd before it is used
To:     Bart Van Assche <bvanassche@acm.org>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        linux-scsi@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
References: <20211101192417.324799-1-tadeusz.struk@linaro.org>
 <4cfa4049-aae5-51db-4ad2-b4c9db996525@acm.org>
 <0024e0e1-589c-e2cd-2468-f4af8ec1cb95@linaro.org>
 <da8d3418-b95c-203d-16c3-8c4086ceaf73@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <8fbb619a-37b3-4890-37e0-b586bdee49d6@interlog.com>
Date:   Mon, 1 Nov 2021 21:56:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <da8d3418-b95c-203d-16c3-8c4086ceaf73@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-01 4:20 p.m., Bart Van Assche wrote:
> On 11/1/21 1:13 PM, Tadeusz Struk wrote:
>> On 11/1/21 13:06, Bart Van Assche wrote:
>>> This patch is a duplicate and has been posted before.
>>>
>>> Please take a look at 
>>> https://lore.kernel.org/linux-scsi/20210904064534.1919476-1-qiulaibin@huawei.com/. 
>>>
>>>  From the replies to that email:
>>> "> Thinking further about this: is there any code left that depends on
>>>  > scsi_setup_scsi_cmnd() setting cmd->cmd_len? Can the cmd->cmd_len
>>>  > assignment be removed from scsi_setup_scsi_cmnd()?
>>>
>>> cmd_len should never be 0 now, so I think we can remove it."
>>
>> Thanks for quick response, but I'm not sure if statement
>> "cmd_len should never be 0 now" is correct, because the cmd_len is
>> in fact equal to 0 here and this BUG can be triggered on mainline, 5.14,
>> and 5.10 stable kernels.
> 
> (+Doug Gilbert)
> 
> One of the functions in the call stack in the first message of this email
> thread is sg_io(). I am not aware of any documentation that specifies whether
> it is valid to set cmd_len in the sg_io header to zero. My opinion is that
> the SG_IO implementation should either reject cmd_len == 0 or set cmd_len
> to a valid value if it is zero.

For the sg driver in production, the v3 interface users (including
ioctl(<sg_fd>, SG_IO,) ) have this check:

        if ((!hp->cmdp) || (hp->cmd_len < 6) || (hp->cmd_len > sizeof (cmnd))) {
                 sg_remove_request(sfp, srp);
                 return -EMSGSIZE;
         }

For the v1 and v2 interface users there was no cmd_len. It was deduced via
COMMAND_SIZE(opcode) or by calling ioctl(SG_NEXT_CMD_LEN) prior to the write()
to issue the SCSI command.

Looking at the block layer/ SCSI mid level implementation of ioctl(SG_IO) I
can see no lower bound check on cmd_len (which is 'unsigned char' so at least
it can't go negative).

Doug Gilbert

