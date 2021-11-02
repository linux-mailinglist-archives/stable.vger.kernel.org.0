Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F95443859
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 23:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhKBWY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 18:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhKBWY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 18:24:56 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C1BC061203
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 15:22:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v20so1062193plo.7
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 15:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j1DHSf7OFCAhcG6Ev4KJ21kqE/vBpcfBYIGy5Hss0OU=;
        b=KbIy8DPz7BelN4mQVIa0lcsRGU6Js24LddT3z3AFm+N/o5wou5dV5YqAIDqnzq4+tt
         LIJBLAJH8pjczuGamwxqmUOsApKplS/ryb+wwMN2rybQSRu8JYzkUVFuD8cNK9spVlqe
         EBJ6J8nviBhozNbO3krGbgaGpZB8YyvhkyaKW9kkiukid8H8R1SW+j6ih7xv6wsJ2md5
         0Kx57w8wQ6iQeTiF/U//maoEkSIrIR67lz/hJnrimQvvgtjKxmiqu1VxyP4+7zrzOAyr
         +DRLPssX2DQ0LxlbXa0PR7AYTRVat6FC6ka9JUVHOfXwRRxf7FwxZlrwVKHjSxpE+OMI
         wLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j1DHSf7OFCAhcG6Ev4KJ21kqE/vBpcfBYIGy5Hss0OU=;
        b=ChUfBGslYvqb6LtbRpOQxt+0QG+rMUxf+YuQoeUO3GST9Zu8KEcORYZgswbPrgvxNA
         gDxWegO32BJArArPnISX7O3ph1laKkFZQREzcJzIy/a8DQt+cPjyVvGzcUlgDttpFawA
         XLOgRRYDIl2RwLcxqZ51P3wxEzNN0NakPUHagDB8v9NUILN29nczeDyHMumFUrsjCV94
         msbZhYGNV+jFr4TzbeilQFir3WvaXD9SnsOlRFajmStQMYnQeqScwRGiR3/2lqy+Szp2
         iFyzQaTi+2dE3e1t8uyMoVlA1vOnGw3kBwsMjWPQ1Z3ep0rpnv5v4mG+c3/BZ5fm5OjY
         fbOg==
X-Gm-Message-State: AOAM532D5HA3aOWbgducOb+1GfIu+H18K7xQE5Iyo/PmeaknSaCTMTKY
        QMHjh1S2xS7YWNpM6SKOUE8V5A==
X-Google-Smtp-Source: ABdhPJzNzgeCRneEtl/OuRcnmdMRl0O3mLH2zosezbf53RYoTXXwpuQAhPCXODDFyBqJjToUhg2Muw==
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr10165734pjb.111.1635891740644;
        Tue, 02 Nov 2021 15:22:20 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id e8sm97040pgn.46.2021.11.02.15.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 15:22:20 -0700 (PDT)
Message-ID: <f80fd188-a0e5-2e75-506c-3e82d138fe28@linaro.org>
Date:   Tue, 2 Nov 2021 15:22:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] scsi: core: initialize cmd->cmnd before it is used
Content-Language: en-US
To:     dgilbert@interlog.com, Bart Van Assche <bvanassche@acm.org>,
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
 <cad499a9-7587-1fa9-9f7d-223e66a18efa@interlog.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <cad499a9-7587-1fa9-9f7d-223e66a18efa@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/2/21 14:33, Douglas Gilbert wrote:
>> Thanks for having taken a look. I found the above check in sg_new_write(). To 
>> me that function seems to come from a code path that is unrelated to sg_io(), 
>> the function shown in the call stack in the email at the start of this thread. 
>> Maybe I overlooked something but I haven't found a minimum size check for 
>> hdr->cmd_len in sg_io() before the blk_execute_rq() call. Should such a check 
>> perhaps be added?
> 
> I guess it came from ioctl(<non_sg_fd>, SG_IO, ) and I found no lower bound
> check when I looked in lk 5.15.0 . No-one has complained to me about the
>     hp->cmd_len < 6
> 
> check in the sg driver ***. So I think such a check may be useful in the 
> scsi_fill_sghdr_rq() function in drivers/scsi/scsi_ioctl.c . And a return
> of -EMSGSIZE seems to be tailor made for this situation.
> 
> Doug Gilbert
> 
> 
> *** It is possible a vendor specific command could be between 1 and 5 bytes
> long, but that would probably be an unwise choice.

Bart,
Do you want me to send a patch with the check in scsi_fill_sghdr_rq()?
I want to close the mentioned syzbot issue in 5.10. I can also do the
back-porting if anything will be required.

-- 
Thanks,
Tadeusz
