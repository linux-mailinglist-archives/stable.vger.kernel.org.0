Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BE7D6763
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 18:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbfJNQdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 12:33:11 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37287 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfJNQdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 12:33:11 -0400
Received: by mail-qk1-f195.google.com with SMTP id u184so16453603qkd.4;
        Mon, 14 Oct 2019 09:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4e/+dg0NVCCBrtHyCNhp9Ya4wF37EwRkEK+NeEl5+VU=;
        b=A31njF9Kt8jL9DxYdqt+AFERZ4GXgyF70roSgACytG3oPAM4SAiEfGJA0thhHyQsRE
         LDJwdWYGEuIpGGkNJedBJR9j2bImNS5IFxRfVCKSyf0ecjmUBeGfXkQhqHu0Q0/J9Z3S
         6WvQvuglHPm37Ceukii41k6PvelrK0oe30D2phoqsH1fIzkYqooz65ZizMGS2Ae21r4u
         NQwH94TUGi4i8G9syVddwuPF4XeoBEdQbqtIcjw26FBbZcP0aibSAUHvEZE7EsZQDlcN
         rwgH1ijPQlLfswIvNQnaBq6wZuH+iOrUri5/E4uHH/RxDQQI8TCzgHFtRKVT9V2KgZL7
         MY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4e/+dg0NVCCBrtHyCNhp9Ya4wF37EwRkEK+NeEl5+VU=;
        b=ZkbS568dRcdXYnh0M97wyMVgUFqEekU46ma0zvcwvIdfHOrYVIRGGBalrs5lLzY25o
         Jav3zSNQqxcuB010qOt/D2de3ze7cEHEeWqPBab5yfV57DFwidSjSGvg4Gs12dtJV0FI
         31JEdcbb30HGCvGyKbcEkswZc96byhSlsmuYIfZXX8T19Qk71vLZKWcl/MYQXr3Po3Ea
         pJAiugIL/UPAgCzNXyLgBD2uszrQBSaVleBBEN17OI685omQP4NeLTpHq/OnSNP7eWNE
         LCoTb6+oimCB0yXtoPR7+ZSWlRt9XWnxqmwF2rzqn3f6kzzVM7glMR9EdNGYmAI+uueT
         SGoQ==
X-Gm-Message-State: APjAAAWYpPBXVWivtuLm8iNO1rWer7dyVih3RddpS7271pt3lt9DWzi8
        +Ilm2V+7LltSgX2PSeto5QY=
X-Google-Smtp-Source: APXvYqz1ACcaWifQWUyV2g9FPNEuBZNZlzJ6t7epHU0KuMJ9cSqy7/zM89IFXIFaY8NMX42nGDVQtw==
X-Received: by 2002:a37:484b:: with SMTP id v72mr31746062qka.206.1571070789784;
        Mon, 14 Oct 2019 09:33:09 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::1:50c5])
        by smtp.gmail.com with ESMTPSA id o124sm8220344qke.66.2019.10.14.09.33.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 09:33:09 -0700 (PDT)
Date:   Mon, 14 Oct 2019 09:33:07 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Message-ID: <20191014163307.GG18794@devbig004.ftw2.facebook.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
 <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, Aleksa.

On Tue, Oct 15, 2019 at 02:59:31AM +1100, Aleksa Sarai wrote:
> On 2019-10-14, Tejun Heo <tj@kernel.org> wrote:
> > On Sat, Oct 12, 2019 at 12:05:39PM +1100, Aleksa Sarai wrote:
> > > Because pids->limit can be changed concurrently (but we don't want to
> > > take a lock because it would be needlessly expensive), use the
> > > appropriate memory barriers.
> > 
> > I can't quite tell what problem it's fixing.  Can you elaborate a
> > scenario where the current code would break that your patch fixes?
> 
> As far as I can tell, not using *_ONCE() here means that if you had a
> process changing pids->limit from A to B, a process might be able to
> temporarily exceed pids->limit -- because pids->limit accesses are not
> protected by mutexes and the C compiler can produce confusing
> intermediate values for pids->limit[1].
>
> But this is more of a correctness fix than one fixing an actually
> exploitable bug -- given the kernel memory model work, it seems like a
> good idea to just use READ_ONCE() and WRITE_ONCE() for shared memory
> access.

READ/WRITE_ONCE provides protection against compiler generating
multiple accesses for a single operation.  It won't prevent split
writes / reads of 64bit variables on 32bit machines.  For that, you'd
have to switch them to atomic64_t's.

Thanks.

-- 
tejun
