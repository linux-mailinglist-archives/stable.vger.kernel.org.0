Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F6A1C93E
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 15:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfENNMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 09:12:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41642 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfENNMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 09:12:32 -0400
Received: by mail-pl1-f195.google.com with SMTP id f12so6237242plt.8
        for <stable@vger.kernel.org>; Tue, 14 May 2019 06:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8j4bTePHKvxQHvdCNJpe7zeTS2p9aPCumSJI0+OPUho=;
        b=QFJ7Uj5YexuFf6uISaOzUn230iNrGfeGlc5p43zd5sz3KohEp5mu1AieK2+nd3A4Ul
         eQMY2Z8dEI6SO527Hx3lpfx+qG6PFsMPpD8t0XJPiyUJoIEBsXU5wI/dI8+2+w1/Bl+0
         F7ItnZYkgweTYUPkCBIpXzOWiI6lbAftb+paqcWaapzMQYXvfTvEEGXQMmjkEZM7EvfU
         JDy5Nb6VX3ws3gAv+5glr4Pzo4FaSnwIq6LIsjLjUDxFyWz8vLdxOval9hI5sS5ZRJpl
         bt6XDed0yt9H9K/f2WX8NStrCnX2jieuEGxGp4X4QmG0/5+qsHIdzOxikX00+d+q7typ
         qEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8j4bTePHKvxQHvdCNJpe7zeTS2p9aPCumSJI0+OPUho=;
        b=syZuGhyH62Ev4zaikLC95zTiuq0OZ0lcY/xJjYCgFnqYi+ZvD8aqPyDdJn1PWaJZCi
         g/JQRE7eFf3o0czsd0BYGzIY3q0l2Y2XjFW9e8++Em0+F38B71InEjbZkmMPzxW0GOWW
         e91BJuvCjZMl/xGzehFYD9Gfrpp29TprnGJnMXLdZYO06z2uugEoPn1nj9qUOLPZWLYs
         RD8TkthfLApM5EhdC6/dGDgJuRdDh3H73wSSvQqKh2iUIwK0BXDk6PKBz0nZNC3+tNJt
         9pTzcPbs95U5yvAkKFqvMIIwFShk+2y6cWkaNllkFjX1SQMRdrCgr3RtHcXwUz5WOelA
         /dFw==
X-Gm-Message-State: APjAAAVSXMATyRreFYkoYKzXDxkKSvwzYjKVLlUNhSjwlVyhb8tFPQMD
        UfN3b79xh1+HPMqq/z2bMeUTQA==
X-Google-Smtp-Source: APXvYqxqgfcYr8ueqlj/ULqC7UHBgssWO16AHhzumldec5lumpiBNFn6b6GYsRNopPkPY29HgGR5nw==
X-Received: by 2002:a17:902:84:: with SMTP id a4mr37940501pla.210.1557839552080;
        Tue, 14 May 2019 06:12:32 -0700 (PDT)
Received: from box.localdomain ([134.134.139.83])
        by smtp.gmail.com with ESMTPSA id 5sm2405005pfh.109.2019.05.14.06.12.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 06:12:30 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id F2F551007C1; Wed,  8 May 2019 17:47:39 +0300 (+03)
Date:   Wed, 8 May 2019 17:47:39 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Baoquan He <bhe@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@kernel.org, hpa@zytor.com, kirill.shutemov@linux.intel.com,
        keescook@chromium.org
Subject: Re: [PATCH v4] x86/mm/KASLR: Fix the size of vmemmap section
Message-ID: <20190508144739.we4owbvjmjisium5@box>
References: <20190508080417.15074-1-bhe@redhat.com>
 <20190508082418.GC24922@MiWiFi-R3L-srv>
 <20190508090424.GA19015@zn.tnic>
 <20190508093520.GD24922@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508093520.GD24922@MiWiFi-R3L-srv>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 05:35:20PM +0800, Baoquan He wrote:
> On 05/08/19 at 11:04am, Borislav Petkov wrote:
> > On Wed, May 08, 2019 at 04:24:18PM +0800, Baoquan He wrote:
> > > I think this's worth noticing stable tree:
> > > 
> > > Cc: stable@vger.kernel.org
> > 
> > Fixes: ?
> 
> Not sure which commit validated 5-level.
> 
> Hi Kirill,
> 
> Is this commit OK?
> 
> Fiexes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic for CONFIG_X86_5LEVEL=y")

Yep.

-- 
 Kirill A. Shutemov
