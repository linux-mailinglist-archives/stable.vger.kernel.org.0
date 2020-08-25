Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E612252388
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 00:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHYWWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 18:22:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36071 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgHYWWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 18:22:08 -0400
Received: by mail-pg1-f195.google.com with SMTP id p37so8930pgl.3;
        Tue, 25 Aug 2020 15:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VFYKY6spuVaJ6jGfkYS1+XEwHNCIt2AYyCr2W3bH/H0=;
        b=GzjBkLwB8bwK+E/jEsApRStoX2hmI1nhK60nHGhIqpUOdDQJPePw6OGBpQYFYSnOFM
         eHc2re96M3JRBirqklfQZV3ORpnLKg7vaaekPpbxSi7YazFc2SZJx2A0ZbIYUojb6X1k
         5Hl/kmzNYxQvqMMa2KGuPCf7KsH8cZec6GSxdcFX6N0XvluROaPNcZEnzSNG8vAosck0
         9QgENAiUBXTMfy8vd8VWJJ6Y3LtSPwZBNR7UBGdrSdrlaVeL2NEi0unqKT6vObmcaKj+
         tZrhdGI30AvVm3PSYOonW4L/ED3Rl/VAERBmeFHm4fmvfcrCmqay3TvssoKDenuq3Yl8
         2ysg==
X-Gm-Message-State: AOAM532A7nEhA9DKRy/2c/w/Q5Vl/TmB+EPKakOtZH9StMbLFM+fBXAv
        D22l9brrLnOcqYnOzjGWIUDEIKYDakQ=
X-Google-Smtp-Source: ABdhPJwySdGLvYUx7m5cxQh/SnIlMtgb3vrtw//q1PUJ9GnfMpN0QUvo/pATjwBr07VhuMR7k0/HJQ==
X-Received: by 2002:a62:cf85:: with SMTP id b127mr9670310pfg.89.1598394126825;
        Tue, 25 Aug 2020 15:22:06 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p11sm120433pgh.80.2020.08.25.15.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 15:22:05 -0700 (PDT)
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
To:     Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
 <20200825182423.GB375466@rowland.harvard.edu>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <1f798c21-241f-59f8-5298-a32fffe2ff01@acm.org>
Date:   Tue, 25 Aug 2020 15:22:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825182423.GB375466@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-25 11:24, Alan Stern wrote:
> A related question concerns the BLK_MQ_REQ_PREEMPT flag.  If it is set 
> then the request is allowed while rpm_status is RPM_SUSPENDING.  But in 
> fact, the only requests which should be allowed at that time are those 
> created by the lower-layer driver as part of its runtime-suspend 
> handling; all other requests should be deferred.  The BLK_MQ_REQ_PREEMPT 
> flag doesn't seem like the right way to achieve this.  Should we be 
> using a different flag?

I think there is already a flag that is used to mark power management
commands, namely RQF_PM.

My understanding is that the BLK_MQ_REQ_PREEMPT/RQF_PREEMPT flags are used
for the following purposes:
* In the SCSI core, scsi_execute() sets the BLK_MQ_PREEMPT flag. As a
  result, SCSI commands submitted with scsi_execute() are processed in
  the SDEV_QUIESCE SCSI device state. Since scsi_execute() is only used
  to submit other than medium access commands, in the SDEV_QUIESCE state
  medium access commands are paused and commands that do not access the
  storage medium (e.g. START/STOP commands) are processed.
* In the IDE-driver, for making one request preempt another request. From
  an old IDE commit (not sure if this is still relevant):
  + * If action is ide_preempt, then the rq is queued at the head of
  + * the request queue, displacing the currently-being-processed
  + * request and this function returns immediately without waiting
  + * for the new rq to be completed.  This is VERY DANGEROUS, and is
  + * intended for careful use by the ATAPI tape/cdrom driver code.

Bart.
