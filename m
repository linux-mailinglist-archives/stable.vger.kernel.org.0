Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE580253C28
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 05:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgH0Dfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 23:35:47 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53802 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgH0Dfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 23:35:46 -0400
Received: by mail-pj1-f68.google.com with SMTP id nv17so1902481pjb.3;
        Wed, 26 Aug 2020 20:35:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DLj4W2vhUepXhNqbwxvkKgKcWXo+LmOht5KSU3PyXno=;
        b=CNDuEBG3TZeebeFRiiITJUHlIIvyzkH1AJVox26BEl4Fz7DTRoOz2YsBVZajxz6x7H
         31XHwgDCNnCbhy8TrDR8e7lIRahN4CJZtzNAThIi2ESfAn5WSFn1omZAcY3rojqB+ntj
         P6/NJtqPKAJB9k7jI6X6QhJG3vLeClGE06TUE3Z7fUxKhcpAYlSWwLq/lD0Ki9kJOjHZ
         keWfOAfkfzlhyZ8xtBo6KzA1NgNtijR4OtallNuy6eQijg7L2gUBPbZinQetHZZzC5BN
         TAXcHxvjKCZkKLkTvpfLN165W9/5vTNCL8TkNPOEqvlxbY5gNdXEzu6Mg0jLVy6Z9JzP
         WFkw==
X-Gm-Message-State: AOAM532pBPKAtwKUJcjDy18fmwloiNCFtH7bP317iEPIbU5mDldhbjKz
        AqbjyULq+BG9W4LoNgNJ/p4=
X-Google-Smtp-Source: ABdhPJyklio1mpgzNgrsrCHSPZvogO3jiJOroyEAHY0jOBex6B9DucFvtYvn85NN5Ors5xumTTcubg==
X-Received: by 2002:a17:90b:18e:: with SMTP id t14mr7740779pjs.69.1598499345718;
        Wed, 26 Aug 2020 20:35:45 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d23sm504620pjz.44.2020.08.26.20.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 20:35:44 -0700 (PDT)
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
 <20200825182423.GB375466@rowland.harvard.edu>
 <1f798c21-241f-59f8-5298-a32fffe2ff01@acm.org>
 <20200826015159.GA387575@rowland.harvard.edu>
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
Message-ID: <af1b1f57-59ff-0133-8108-0f3d1e1254e1@acm.org>
Date:   Wed, 26 Aug 2020 20:35:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826015159.GA387575@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-25 18:51, Alan Stern wrote:
> Ah, perfect.  So in blk_queue_enter(), pm should be defined in terms of 
> RQF_PM rather than BLK_MQ_REQ_PREEMPT.
> 
> The difficulty is that the flags argument is the wrong type; RQF_PM is 
> defined as req_flags_t, not blk_mq_req_flags_t.  It is associated with a 
> particular request after the request has been created, so after 
> blk_queue_enter() has been called.
> 
> How can we solve this?

The current code looks a bit weird because my focus when modifying the PM
code has been on not breaking any existing code.

scsi_device_quiesce() relies on blk_queue_enter() processing all PREEMPT
requests. A difficulty is that scsi_device_quiesce() is used for two
separate purposes:
* Runtime power management.
* SCSI domain validation. See e.g. https://lwn.net/Articles/75917/.

I think that modifying blk_queue_enter() such that it only accepts PM
requests will require to split scsi_device_quiesce() into two functions:
one function that is used by the runtime power management code and another
function that is used by the SCSI domain validation code. This may require
to introduce new SCSI device states. If new SCSI device states are
introduced, that should be done without modifying the state that is
reported to user space. See also sdev_states[] and show_state_field in
scsi_sysfs.c.

Thanks,

Bart.
