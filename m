Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B26D960C
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 17:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405906AbfJPPyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 11:54:11 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43565 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405903AbfJPPyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 11:54:11 -0400
Received: by mail-qk1-f193.google.com with SMTP id h126so23207747qke.10;
        Wed, 16 Oct 2019 08:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0WPO79DQDmX9K5UUvDG9NIvgYir9s6WI5TJKIJkxgcM=;
        b=KCKGbCnnZALErjaIOXUYlE+dIZkF5JwVP/bpZ27+TuqqGH9oF0ds351xGOTB7cX87c
         c4943D0f6UUJc5cY4nDXJIhYnPI8ba57pzg6LD+UtawPccJUsKjuyd0K8Y6vM2/hJm5I
         RflHR2EyV1blt1g8DVrTRsNn+6EwcKLXhSqsK6OznGPFaYfeKCajl+kZriwEBFPPtDIC
         LGwjAz89030aFNhbBaWQtFZnJTGGXoLm4aPpNSC1rj5FOBJXVMSkAZGyhvXwt8cU8Ppo
         1pTL4woX4HN5aiZXh64itUXu4jap71Aba4sJGmNQlXnuRmfaDnNtUd8f4WP9tHxpEf67
         KKXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0WPO79DQDmX9K5UUvDG9NIvgYir9s6WI5TJKIJkxgcM=;
        b=cNAR3KtXW+5S96RcMbualKEeWbYNHyBu2nz7xJkLbxfGHCpHjYHnIfEZ0PVIjnLg60
         /4OKmYU1mirnTYYwEKeuykLjM/Uu9n+S7MRadHAtJz17YQCDw8+l2XBvSwj4u7Zxi3d5
         t1P9bu4OWFWaMKQB2ua00X65xN1pl7cpS0a43xxtNBfaxhIKUUGyFNCsJ+Vs/yZWdm2A
         HdURnkMokfyVwkkFQLskztrY0KKNOO21C7ZwpN3Ew9+brbcfBgrcgTyOwIGwyIc/L4mo
         vbLg5/hnWo1QWhu2kopSAu1FzKJIqEbeYCOLnhWx1cbXXIsM/TN6Gp5zPyMLY54LctJR
         eTig==
X-Gm-Message-State: APjAAAXlS4AuDcpmmM6CzWWcBtoKrYvU/nGS7/paNQkj26aNM9V2aXpO
        jXvgCxs0lOWVfZFwnoNP284=
X-Google-Smtp-Source: APXvYqwBOCFb3TTsHBTEWw1SzJD1ztkfhHtDDk3aI2+Pj7u5QuOWjlAz0L3mRgFVS7r/KKRiaPiqBw==
X-Received: by 2002:a37:db0a:: with SMTP id e10mr4290823qki.3.1571241250379;
        Wed, 16 Oct 2019 08:54:10 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::1:2d57])
        by smtp.gmail.com with ESMTPSA id b4sm11832566qkd.121.2019.10.16.08.54.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 08:54:09 -0700 (PDT)
Date:   Wed, 16 Oct 2019 08:54:07 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Message-ID: <20191016155407.GP18794@devbig004.ftw2.facebook.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
 <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
 <20191014163307.GG18794@devbig004.ftw2.facebook.com>
 <20191016083218.ttsaqnxpjh5i5bgv@yavin.dot.cyphar.com>
 <20191016142756.GN18794@devbig004.ftw2.facebook.com>
 <20191016152946.34j5x45ko5auhv3g@yavin.dot.cyphar.com>
 <20191016153520.zet5mn5xsygig4xc@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016153520.zet5mn5xsygig4xc@yavin.dot.cyphar.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 02:35:20AM +1100, Aleksa Sarai wrote:
> > Sure, I will switch it to use atomic64_read() and atomic64_set() instead
> > if that's what you'd prefer. Though I will mention that on quite a few
> > architectures atomic64_read() is defined as:
> > 
> >   #define atomic64_read(v)        READ_ONCE((v)->counter)
> 
> Though I guess that's because on those architectures it turns out that
> READ_ONCE is properly atomic?

Oh yeah, on archs where 64bit accesses are atomic, READ_ONCE() /
WRITE_ONCE() would work here.  If the limit variable were ulong
instead of an explicit 64bit variable, RW ONCE would work too as ulong
accesses are atomic on all archs IIRC.

Thanks.

-- 
tejun
