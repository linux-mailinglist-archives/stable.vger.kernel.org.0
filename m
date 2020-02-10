Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778D1156E1C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 04:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgBJDyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 22:54:23 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43879 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgBJDyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 22:54:23 -0500
Received: by mail-pl1-f194.google.com with SMTP id p11so2259675plq.10;
        Sun, 09 Feb 2020 19:54:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ScLq+uxFxJJ8h5yf9gT2oaJ4q5A422rvmbSfgGHlTkI=;
        b=asreeiCON18FbpnBX5EvnmAIGq2DUq/FwXgodffnSmKY2EyOhhc2s6kH3BKPw58wqf
         LlrchaTsM8+6yxkvFjkmNIaejwxvgftHrZ44BODYHUKMfF+IJYrX5KCOS8leu77S25FV
         EuakRrrtD5j+qIZv06DzTgBTJI78HpKQMgxIglt508ysxLHzMuH7ShhCr+UYX4UfW59A
         awNpeR7RHXtUsGc3pyvVuComcJkc5+DC/WX96WYIcOxGmLwQCIxA7Mvu2Dw4FTlnvk7/
         ZjXNlBnpZx4ZkRxdV8ezUJoGbuBQt4XN2EvH3YmcQT39OaqqVQ8b85rRGleDInEudam5
         df5Q==
X-Gm-Message-State: APjAAAXMlZXUajyHbBrGmRrUfGlZTlnerIl7wX4G4kR7l4CDRcESVemQ
        KAnI8m+Kkrak3m2C9BBPgfSQ4dZv3hA=
X-Google-Smtp-Source: APXvYqzgLuQm5NOq5Yew8JsNhvwWoOjoaqOaGv7crlQb1vt/yr6df4a5+SoDJnh8Bzunu3vWZLgV9w==
X-Received: by 2002:a17:90a:1b42:: with SMTP id q60mr17706605pjq.108.1581306860815;
        Sun, 09 Feb 2020 19:54:20 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:20b3:5fd0:4962:3980? ([2601:647:4000:d7:20b3:5fd0:4962:3980])
        by smtp.gmail.com with ESMTPSA id h13sm9640150pjc.9.2020.02.09.19.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2020 19:54:19 -0800 (PST)
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
To:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, tristmd@gmail.com,
        stable@vger.kernel.org
References: <20200206142812.25989-1-jack@suse.cz>
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
Message-ID: <6a49e67f-e621-939e-11d5-b614fa8da7d8@acm.org>
Date:   Sun, 9 Feb 2020 19:54:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200206142812.25989-1-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-02-06 06:28, Jan Kara wrote:
> KASAN is reporting that __blk_add_trace() has a use-after-free issue
> when accessing q->blk_trace. Indeed the switching of block tracing (and
> thus eventual freeing of q->blk_trace) is completely unsynchronized with
> the currently running tracing and thus it can happen that the blk_trace
> structure is being freed just while __blk_add_trace() works on it.
> Protect accesses to q->blk_trace by RCU during tracing and make sure we
> wait for the end of RCU grace period when shutting down tracing. Luckily
> that is rare enough event that we can afford that. Note that postponing
> the freeing of blk_trace to an RCU callback should better be avoided as
> it could have unexpected user visible side-effects as debugfs files
> would be still existing for a short while block tracing has been shut
> down.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
