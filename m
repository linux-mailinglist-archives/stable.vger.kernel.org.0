Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88F5D95A7
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 17:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404988AbfJPPci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 11:32:38 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34008 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfJPPci (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 11:32:38 -0400
Received: by mail-qk1-f194.google.com with SMTP id q203so23161583qke.1;
        Wed, 16 Oct 2019 08:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T9N8Qt/Q4T/fLDKFrE/yGjdsJz9c4IKV5iMQVuzGrps=;
        b=uR+B/8KpPRzIhOBAr5vomaF58ezGmJX/eSypGMHunaNAhefJay3pXHyQMlfeT33DY2
         E7CYU5KMl9Bvj6oHq9PBQ/vQ4QhvoLaD8r9wy3Id7EKa6ZnUkh9C8r0M1g82ZyAAcRsA
         F8+Xxp3LqG/0rsTC+TCAaLPer+M4sVHPnYCFLSQ8AgEKp+5dkJ5KUf5oSjb4BDsB9VnN
         LTdQU3BkzHyE+SgCrKzT8ogPqp79w2Z45xmDJ2QbmKgqdd1vmbWHGQW5kdpch5QSKCt5
         9LN25GRra8d834gUX5t4Z/INq89v6v7FkHZNuYvqadr1h9sT7s7zYSlvpz+zY8zONofD
         hXIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=T9N8Qt/Q4T/fLDKFrE/yGjdsJz9c4IKV5iMQVuzGrps=;
        b=TahZLGn8FfS68bbu4SCx9zK+NuY4PXmWieaqMVzW8thWVJo9cAmB79UgEAlf50cM9+
         A9orCeUJ669l72Pj0cT5sD1J+Jr3C5hzO1Qs8RjrZtO+/jVYHl9ioLwSqT8JZFRQaY2k
         pe8VRrKN3qJFnXfwsse3uo+9LPyg52GF7Dgensavu6mp+IMNxQYLfUfEYnKshBBhahZi
         d8F5luQLGc94pWdlBFVIer1vT4S0ozto4+bwXIZwqL8OdKXTcTzYwcRh6DdaSx4IRLfb
         ZM4xqIX5XQzUqEWWfzLOdiJTSujYm7NZxhELOcY+KHy87o0hRwkfjMobMHd6c+K+gPPn
         0nzA==
X-Gm-Message-State: APjAAAXg2NsYSXtnHBkticKPKQ+LKMyF+7FxlNxZ0TFD4RoY+8yC4Uia
        aLBrVmW5SzJU1tdDPcU4MX0=
X-Google-Smtp-Source: APXvYqzyFvjB0Qdu/707bwgi1BqkvK7HYcGOwQw/+HX2xBFJ+Ju9kRmlElS1taWq5eKHN+mn/sFduw==
X-Received: by 2002:a37:4151:: with SMTP id o78mr38324867qka.263.1571239956891;
        Wed, 16 Oct 2019 08:32:36 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::1:2d57])
        by smtp.gmail.com with ESMTPSA id o14sm16778400qtk.52.2019.10.16.08.32.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 08:32:36 -0700 (PDT)
Date:   Wed, 16 Oct 2019 08:32:34 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Message-ID: <20191016153234.GO18794@devbig004.ftw2.facebook.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
 <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
 <20191014163307.GG18794@devbig004.ftw2.facebook.com>
 <20191016083218.ttsaqnxpjh5i5bgv@yavin.dot.cyphar.com>
 <20191016142756.GN18794@devbig004.ftw2.facebook.com>
 <20191016152946.34j5x45ko5auhv3g@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016152946.34j5x45ko5auhv3g@yavin.dot.cyphar.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Thu, Oct 17, 2019 at 02:29:46AM +1100, Aleksa Sarai wrote:
> > Hah, where is it saying that?
> 
> Isn't that what this says:
> 
> > Therefore, if you find yourself only using the Non-RMW operations of
> > atomic_t, you do not in fact need atomic_t at all and are doing it
> > wrong.
> 
> Doesn't using just atomic64_read() and atomic64_set() fall under "only
> using the non-RMW operations of atomic_t"? But yes, I agree that any
> locking is overkill.

Yeah, I mean, it's an overkill.  We can use seqlock or u64_stat here
but it doesn't matter that much.

> > > As for 64-bit on 32-bit machines -- that is a separate issue, but from
> > > [1] it seems to me like there are more problems that *_ONCE() fixes than
> > > just split reads and writes.
> > 
> > Your explanations are too wishy washy.  If you wanna fix it, please do
> > it correctly.  R/W ONCE isn't the right solution here.
> 
> Sure, I will switch it to use atomic64_read() and atomic64_set() instead
> if that's what you'd prefer. Though I will mention that on quite a few
> architectures atomic64_read() is defined as:
> 
>   #define atomic64_read(v)        READ_ONCE((v)->counter)

Yeah, on archs which don't have split access on 64bits.  On the ones
which do, it does something else.  The generic implementation is
straight-up locking, I think.

Thanks.

-- 
tejun
