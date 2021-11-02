Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2404437DF
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 22:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhKBVg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 17:36:29 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:36933 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhKBVg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 17:36:28 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 9C6832EA2CA;
        Tue,  2 Nov 2021 17:33:52 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id VzrVROEuocBK; Tue,  2 Nov 2021 17:33:51 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 8A96C2EA06A;
        Tue,  2 Nov 2021 17:33:51 -0400 (EDT)
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
 <8fbb619a-37b3-4890-37e0-b586bdee49d6@interlog.com>
 <17a1b72e-2c2a-8492-cb92-4dec36a6531d@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <cad499a9-7587-1fa9-9f7d-223e66a18efa@interlog.com>
Date:   Tue, 2 Nov 2021 17:33:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <17a1b72e-2c2a-8492-cb92-4dec36a6531d@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-01 11:06 p.m., Bart Van Assche wrote:
> On 11/1/21 18:56, Douglas Gilbert wrote:
>> On 2021-11-01 4:20 p.m., Bart Van Assche wrote:
>>> One of the functions in the call stack in the first message of this email
>>> thread is sg_io(). I am not aware of any documentation that specifies whether
>>> it is valid to set cmd_len in the sg_io header to zero. My opinion is that
>>> the SG_IO implementation should either reject cmd_len == 0 or set cmd_len
>>> to a valid value if it is zero.
>>
>> For the sg driver in production, the v3 interface users (including
>> ioctl(<sg_fd>, SG_IO,) ) have this check:
>>
>>         if ((!hp->cmdp) || (hp->cmd_len < 6) || (hp->cmd_len > sizeof (cmnd))) {
>>                  sg_remove_request(sfp, srp);
>>                  return -EMSGSIZE;
>>          }
> 
> Hi Doug,
> 
> Thanks for having taken a look. I found the above check in sg_new_write(). To me 
> that function seems to come from a code path that is unrelated to sg_io(), the 
> function shown in the call stack in the email at the start of this thread. Maybe 
> I overlooked something but I haven't found a minimum size check for hdr->cmd_len 
> in sg_io() before the blk_execute_rq() call. Should such a check perhaps be added?

I guess it came from ioctl(<non_sg_fd>, SG_IO, ) and I found no lower bound
check when I looked in lk 5.15.0 . No-one has complained to me about the
    hp->cmd_len < 6

check in the sg driver ***. So I think such a check may be useful in the 
scsi_fill_sghdr_rq() function in drivers/scsi/scsi_ioctl.c . And a return
of -EMSGSIZE seems to be tailor made for this situation.

Doug Gilbert


*** It is possible a vendor specific command could be between 1 and 5 bytes
long, but that would probably be an unwise choice.

