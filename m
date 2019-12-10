Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AE9118C38
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfLJPNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:13:25 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:46226 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbfLJPNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 10:13:24 -0500
Received: by mail-il1-f196.google.com with SMTP id t17so16372954ilm.13
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 07:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FluuqedFsDG2KxFI/2uK9kxG/iDZm0NhrUd3U8p+PGU=;
        b=RgWVRadeDQjBu1BGZ1cVSL3ENFUnLuhp90whbsIXBhKP9l3uRkHuLcoQu2lT+vPlnX
         K4IN0tpWhwtvcFboaYo3Y3D6XzSOCzSQJpNB7ZTVfME1ajpGQ4riwI/YPPtRRF/OVJ4o
         kCRI/qhMDuq0vMLdAyAJk/95JGHyNhx/IypKMgN5Iohrb3v98Yl9WItSeqyQaKeKmOJ1
         laUuGoar4OPkLWVZHaBFN0y4rCtZrx3J6j8reLZmH0IWjXG/H8xXFFcf1acUbsTir/SC
         4Kvj775BUcPh7w/wW8PCrbzRSo28Ev5oWAfG4MyGkfNmagk34a/M1DsjzaNE4Emt15Tq
         n5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FluuqedFsDG2KxFI/2uK9kxG/iDZm0NhrUd3U8p+PGU=;
        b=h/+GOx2A52f9vRgrROoXoktW6ZJITqYrZQXs/YtL9NsrVTF9hBtnL5RR3+s6lA4EVY
         5z9sPuM8NVaHygDwbXJw0+fqcs4+c+UhG11ECZN/QIGq1NDSCvH/XMt7eStnCPhv6IOa
         h7/KNofEzCk6xkSldcaAwhw3DQ4q7tLqkAEKCU3IJHEVjk+//dNmuD1/ixQHLVMiKTLC
         qC/jUVLz63kF+Nfz/nhd/V7z93EIVLCBY9Ml07vkSSLdiqMeGM/phDzS+1nmP02b/h7k
         +jTj8GFeKRwcq61+PW+Y/J8khCZtipEVAprcoL+lI6nyhHEglXGPvZZ70ckoXRdhkC56
         70xw==
X-Gm-Message-State: APjAAAULbgVVZAINIf0EzKV9ulM4Scx9YgxRfbzArpzla0CKdh2IODqC
        0l2aBDrYASmnbig9Ne6e5cmW7A==
X-Google-Smtp-Source: APXvYqwA6KsgxhpSxh7cHUhuaWTUaw28H99GYAp3/7OCgeZLGK4kWP8ivU/jL55Q0AZdsIfyxs37tA==
X-Received: by 2002:a92:246:: with SMTP id 67mr10334165ilc.155.1575990803619;
        Tue, 10 Dec 2019 07:13:23 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l7sm746380iol.22.2019.12.10.07.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 07:13:22 -0800 (PST)
Subject: Re: [PATCH 1/4] io_uring: allow unbreakable links
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
References: <20191209231854.3767-1-axboe@kernel.dk>
 <20191209231854.3767-2-axboe@kernel.dk>
 <809147c7-58b2-6e21-66ab-edf09e1757b9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b17ac667-d916-51e6-1f19-8a38726d18e0@kernel.dk>
Date:   Tue, 10 Dec 2019 08:13:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <809147c7-58b2-6e21-66ab-edf09e1757b9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/10/19 3:13 AM, Pavel Begunkov wrote:
> On 12/10/2019 2:18 AM, Jens Axboe wrote:
>> Some commands will invariably end in a failure in the sense that the
>> completion result will be less than zero. One such example is timeouts
>> that don't have a completion count set, they will always complete with
>> -ETIME unless cancelled.
>>
>> For linked commands, we sever links and fail the rest of the chain if
>> the result is less than zero. Since we have commands where we know that
>> will happen, add IOSQE_IO_HARDLINK as a stronger link that doesn't sever
>> regardless of the completion result. Note that the link will still sever
>> if we fail submitting the parent request, hard links are only resilient
>> in the presence of completion results for requests that did submit
>> correctly.
>>
>> Cc: stable@vger.kernel.org # v5.4
>> Reported-by: 李通洲 <carter.li@eoitek.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c                 | 54 +++++++++++++++++++++--------------
>>  include/uapi/linux/io_uring.h |  1 +
>>  2 files changed, 33 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 405be10da73d..662404854571 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -377,6 +377,7 @@ struct io_kiocb {
>>  #define REQ_F_TIMEOUT_NOSEQ	8192	/* no timeout sequence */
>>  #define REQ_F_INFLIGHT		16384	/* on inflight list */
>>  #define REQ_F_COMP_LOCKED	32768	/* completion under lock */
>> +#define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
>>  	u64			user_data;
>>  	u32			result;
>>  	u32			sequence;
>> @@ -941,7 +942,7 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
>>  
>>  		list_del_init(&req->link_list);
>>  		if (!list_empty(&nxt->link_list))
>> -			nxt->flags |= REQ_F_LINK;
>> +			nxt->flags |= req->flags & (REQ_F_LINK|REQ_F_HARDLINK);
> 
> I'm not sure we want to unconditionally propagate REQ_F_HARDLINK further.
> 
> E.g. timeout|REQ_F_HARDLINK -> read -> write
> REQ_F_HARDLINK will be set to the following read and its fail won't
> cancel the write, that seems strange. If users want such behaviour, they
> can set REQ_F_HARDLINK when needed by hand.

Yeah you're right, how about if we set REQ_F_HARDLINK in io_submit_sqe()
if IOSQE_IO_HARDLINK is set, and just keep the above as it is. We need
to ensure we're correctly keeping hard link if it's set in the sqe, not
carry over like the above if it wasn't set.

>>  		*nxtptr = nxt;
>>  		break;
>>  	}
>> @@ -1292,6 +1293,11 @@ static void kiocb_end_write(struct io_kiocb *req)
>>  	file_end_write(req->file);
>>  }
>>  
>> +static inline bool req_fail_links(struct io_kiocb *req)
>> +{
>> +	return (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK;
>> +}
>> +
> 
> req_fail_links() sounds like it not only do checking, but actually fails
> links. How about as follows?
> 
> +static inline void req_set_fail_links(struct io_kiocb *req)
> +{
> +	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
> +		req->flags |= REQ_F_FAIL_LINK;
> +}
> 
> And it would be less code below

That's cleaner, I'll make the change.

>> @@ -3518,7 +3528,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>>  		 * If previous wasn't linked and we have a linked command,
>>  		 * that's the end of the chain. Submit the previous link.
>>  		 */
>> -		if (!(sqe_flags & IOSQE_IO_LINK) && link) {
>> +		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) && link) {
> 
> IMHO, requests shouldn't have IOSQE_IO_HARDLINK without IOSQE_IO_LINK,
> the same is in the code. Then, it's sufficient check only IOSQE_IO_LINK.

IOSQE_IO_HARDLINK implies link behavior, it's really just a modifier. So
yes, I agree, and that change should then also be removable.

I'll post a v2, thanks for your review.

-- 
Jens Axboe

