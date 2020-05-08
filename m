Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F026B1CA0E3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 04:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgEHC2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 22:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgEHC2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 22:28:13 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528B6C05BD43
        for <stable@vger.kernel.org>; Thu,  7 May 2020 19:28:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so3559592pjh.2
        for <stable@vger.kernel.org>; Thu, 07 May 2020 19:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4doDNbNltxqhzk3lbUMRdt2VtGJH3KG9nbYr5hl5TwM=;
        b=c2Crkcf6BJm8XAZyqLRzdnU4JOCE829O8iRcxXkD/9CKtW3LEaEaLGuyCPLtor9Bix
         RfWLwfBv2sS2BEwdqVB94vlzTC5GAWuVsSGG+i8QX/Yc9NiLfcptAiOXcwVE7xujlLmH
         uemX7rPR2YK3DWe68N81Tp+2/rib9T7x2UlJViuqZkFl72wlZ1W9wPKXgncSd6SSEjm8
         c+YyGJFgnFWsD5x0jsWj+4o2LTxk8YPpFQzZmHdrPf6NZvk10Ohsu66BtCILWc+iFtfa
         BQHDhY8N3vKd7ZhB5tvVl1NbotQubgeHLVBOKgir96oMvryb0eZDAOFAEOkT1QRET2ly
         lZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4doDNbNltxqhzk3lbUMRdt2VtGJH3KG9nbYr5hl5TwM=;
        b=hJ5gqNq5dZYrUYxRAeLGbEDeryXCLTfmkl6F1f7IuDkdFX89mpR8E503/A9pZw6m9P
         56oIeLhK6zwi+qHE5RgLPJ7SVTaUA82AsRZRE3K88Q1OvOrEM7Q+dU9uOnkyi/dy85IM
         g6ReOEWR03GukVT2ygLli5z2rMXW6z4tXXiYW+oJH3LNBMpEI4rHLggeWQhTaW04n9Gq
         jNv00GEaytuS+c+6XuJI7jXbLvAXhuWxE6DiNMnilZBZDL71aXPHnxS0p93cXiedrVFs
         rW+VSWA3jZr1WNyebN1oSUtRHB1NeWMb2wds2Zoz9d0VYuUKIEdRFl3c2HwdF6hyqjXw
         4Qqw==
X-Gm-Message-State: AGi0PuZhlgSyEVVp9jfST/1usyb/eSK9RvGW0RFp5s1hTLPMgfKlEHRP
        bL/v1j4TruadO1Nktcg0NzCwZtYt+vo=
X-Google-Smtp-Source: APiQypIYZasnd2fbZ1mbPjna0cK4o3xA9Ei9Rfpp9uXLfjAuo77K28CoZCemGakyD8n2m/2R1aSwnA==
X-Received: by 2002:a17:902:c194:: with SMTP id d20mr197709pld.256.1588904892424;
        Thu, 07 May 2020 19:28:12 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id cp22sm1040611pjb.28.2020.05.07.19.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 19:28:11 -0700 (PDT)
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Max Kellermann <mk@cm4all.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
 <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
 <20200507192903.GG23230@ZenIV.linux.org.uk>
 <8e3c88cc-027b-4f90-b4f8-a20d11d35c4b@kernel.dk>
 <20200507220637.GH23230@ZenIV.linux.org.uk>
 <283c8edb-fea2-5192-f1d6-3cc57815b1e2@kernel.dk>
 <20200507224447.GI23230@ZenIV.linux.org.uk>
 <e16125f2-c3ec-f029-c607-19bede54fa17@kernel.dk>
 <20200507233132.GJ23230@ZenIV.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <629de3b6-cf80-fe37-1dde-7f0464da0a04@kernel.dk>
Date:   Thu, 7 May 2020 20:28:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507233132.GJ23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/7/20 5:31 PM, Al Viro wrote:
> On Thu, May 07, 2020 at 05:03:17PM -0600, Jens Axboe wrote:
>> On 5/7/20 4:44 PM, Al Viro wrote:
>>> On Thu, May 07, 2020 at 04:25:24PM -0600, Jens Axboe wrote:
>>>
>>>>  static int io_close(struct io_kiocb *req, bool force_nonblock)
>>>>  {
>>>> +	struct files_struct *files = current->files;
>>>>  	int ret;
>>>>  
>>>>  	req->close.put_file = NULL;
>>>> -	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
>>>> +	spin_lock(&files->file_lock);
>>>> +	if (req->file->f_op == &io_uring_fops ||
>>>> +	    req->close.fd == req->ctx->ring_fd) {
>>>> +		spin_unlock(&files->file_lock);
>>>> +		return -EBADF;
>>>> +	}
>>>> +
>>>> +	ret = __close_fd_get_file_locked(files, req->close.fd,
>>>> +						&req->close.put_file);
>>>
>>> Pointless.  By that point req->file might have nothing in common with
>>> anything in any descriptor table.
>>
>> How about the below then? Stop using req->file, defer the lookup until
>> we're in the handler instead. Not sure the 'fd' check makes sense
>> at this point, but at least we should be consistent in terms of
>> once we lookup the file and check the f_op.
> 
> Actually, what _is_ the reason for that check?  Note, BTW, that if the
> file in question happens to be an AF_UNIX socket, closing it will
> close all references held in SCM_RIGHTS datagrams sitting in its queue,
> which might very well include io_uring files.
> 
> IOW, if tries to avoid something really unpleasant, it's not enough.
> And if it doesn't, then what is it for?

Maybe there is no issue at all, the point was obviously to not have
io_uring close itself. But we might just need an ordering of the
fput vs put_request to make that just fine. Let me experiment a bit
and see what's going on.

-- 
Jens Axboe

