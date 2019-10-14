Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92DED664B
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 17:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbfJNPlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 11:41:40 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36800 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731457AbfJNPlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 11:41:40 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so16290892qkc.3;
        Mon, 14 Oct 2019 08:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BUs6ww2wp2HkRKO5Ig1yFUSfYWRm/mJFXsejJnbtOqs=;
        b=oQOzhgiLemf2MFAncmQNwr1h9wmPYZjB9Mhg6CjWxiGAzLmQaUUeRd3rfj1VMVUgXB
         T/o3WuHsOpozELcayBmb+2CMX2fA22LFOds2rvcs7WSjLFP2WyZn5MlPTOwV0zJEUGk/
         0AH3sWGN4COj6efHDv2YZyJZGaaUl/5jK7q8NriAucA/qduGE/SI5d3R8Kq47J5m2EXo
         AP2tAQNe4qD4gD8HfxptPoFq51uauD9hmaTSpJmi6PdyFi/oYoXjibGgvoME/Pzo/d3Y
         7pv6CwmKL8neIiyMfpoFvvqHNK7ArxkXw1SmJyNxDEi5/K0k6Cd9X3hcnMsDpkSu1bUO
         /G1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=BUs6ww2wp2HkRKO5Ig1yFUSfYWRm/mJFXsejJnbtOqs=;
        b=G4AAw2jhzNI4PL0K2aVdIemeTkbuKlVHFnWUEvUcTnxF15VOcfOVu61KrSotSFV6kf
         p3FOrqX+uPG9a9emycij6j50iCG5q5+GpawRoSXhnos9ISzyZxnJhhNKYsSJa/2OSDPJ
         WKOkiKjwzhSdGqvBTkv/mxI5a1rkMS20zhoSP/DdpcIw37hEMrp6BIBbL6G0+d2MG9+w
         joj6B688sUo7eOd99dSii3q4u83Qiyl0M7XkFFnnNEGrcWyGjnnKjOUNj8slPWkbhWVf
         G7MVLeBYVJHvUhUnrb1vAbOHjjcd0orzdhKBI39khT8x1+XjIcWwwllfQwuv9yZU3ymo
         dFBg==
X-Gm-Message-State: APjAAAWLnftbc/ZoibBYV/Xnr8m97g4EgbUEG/B+618L8bmFCUfcW+zX
        lw5omnY2eYAJCwhG6WSXvlQ=
X-Google-Smtp-Source: APXvYqw6h4Cle6f9ZGijs+B74SXDMAHKmu3JulWpk9p6jKiLNU22tm/HqcYx2y0bbEjKhUbAETn66g==
X-Received: by 2002:a05:620a:887:: with SMTP id b7mr27937691qka.186.1571067698911;
        Mon, 14 Oct 2019 08:41:38 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::1:50c5])
        by smtp.gmail.com with ESMTPSA id c20sm7453462qkm.11.2019.10.14.08.41.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 08:41:38 -0700 (PDT)
Date:   Mon, 14 Oct 2019 08:41:36 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Message-ID: <20191014154136.GF18794@devbig004.ftw2.facebook.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012010539.6131-1-cyphar@cyphar.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 12, 2019 at 12:05:39PM +1100, Aleksa Sarai wrote:
> Because pids->limit can be changed concurrently (but we don't want to
> take a lock because it would be needlessly expensive), use the
> appropriate memory barriers.

I can't quite tell what problem it's fixing.  Can you elaborate a
scenario where the current code would break that your patch fixes?

Thanks.

-- 
tejun
