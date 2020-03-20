Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E2C18C72A
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 06:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgCTFle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 01:41:34 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42712 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgCTFld (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 01:41:33 -0400
Received: by mail-oi1-f193.google.com with SMTP id 13so5325763oiy.9
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 22:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k688XzVuSNLYe3/7qT3llYLpqx6g5F7Zxm3QiJQLoqY=;
        b=U3bFLpxB0E1piwMeEM1qfe+GRCdtO2Zd+VZHSSx23ldLwDnUzwMpzAXvR1kOHbKj+B
         xKbk7Zpg2hzEba4e0Wpr5j3U1iuse35Pg3BjUk9FeiFJqCUYiVW8En0IOtYxR18FolS2
         yszGygfmtACg2iotXT1BcwP4sfHv0odRerjm5yH1YXwv16JZGtPf4yERkzMdli43CrDk
         FY0AyUjYHXOy8OYF3KvhYydasPnvmHtGkpH5KM7J9aBPwJ3OZpiKEqBAZ6OxVb4YBcxH
         onVmOv3DTBNJuunCPjM6jgMe6pyERoNBLdNFFr0OPNOVaoWXDzBGWKXLf8Itu9umML3Y
         xRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k688XzVuSNLYe3/7qT3llYLpqx6g5F7Zxm3QiJQLoqY=;
        b=O8AMfSpOq6LIr5fp7PkeJ69rQKKnxyutjYcmogq5ZMV/30uyIUCEWxoQitmQuT9pKi
         UpZh5PUiiAxbZO93e5rbMFqXzMcyH1mMh27mLpwEdvwWlZUExWcCxsI5PZU9QajNNLoB
         5rU011kzrdDlTGs0cB2qB7jGb8J9+UZzUxKI9UrVVTdFeqDpqitm1Ql1en0QQ3sxh170
         K4HGouw67soBB+vHZzmWoLkqhXlgSPzDvNkmTB4RN+Ur+dXQevD3zvTtQChDqohL7cWv
         7Tk5AcumcbxOc0vGIx60Ywfgxm+qqv27V/VyEGZxy2ZVsPl08CQO32zH1uGIfJzKyOIk
         k2pw==
X-Gm-Message-State: ANhLgQ2DjqnMZQupem7ytBGSFkfeSqwgaj0S5q6dvCoNZsq/MiFUzGBw
        2/9Jwx7BVX7tfVv8LogORXK6P3zD
X-Google-Smtp-Source: ADFU+vvFDokCzqit29Qie6+1WIDzfxJZRMxfsKeN7TY4kM1M+mqPRrakJbqHnnpj/+3ibRHL47N1SQ==
X-Received: by 2002:aca:3302:: with SMTP id z2mr333039oiz.3.1584682892690;
        Thu, 19 Mar 2020 22:41:32 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id 103sm1613439oty.36.2020.03.19.22.41.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 22:41:31 -0700 (PDT)
Date:   Thu, 19 Mar 2020 22:41:30 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] locks: fix a potential use-after-free problem when
 wakeup a waiter
Message-ID: <20200320054130.GA9611@ubuntu-m2-xlarge-x86>
References: <2082b1e11fdbf3b64f0da022fb15a8b615c3678c.camel@codethink.co.uk>
 <20200318222906.GJ4189@sasha-vm>
 <20200319063742.GB3274814@kroah.com>
 <500c8174c171378e8b6802ad70b4bf5563b3fab0.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500c8174c171378e8b6802ad70b4bf5563b3fab0.camel@codethink.co.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 07:27:56PM +0000, Ben Hutchings wrote:
> On Thu, 2020-03-19 at 07:37 +0100, Greg Kroah-Hartman wrote:
> > On Wed, Mar 18, 2020 at 06:29:06PM -0400, Sasha Levin wrote:
> > > On Wed, Mar 18, 2020 at 10:09:20PM +0000, Ben Hutchings wrote:
> > > > This commit (included in 5.6-rc5) seems to be needed for 5.4 and 5.5
> > > > branches:
> > > > 
> > > > commit 6d390e4b5d48ec03bb87e63cf0a2bff5f4e116da
> > > > Author: yangerkun <yangerkun@huawei.com>
> > > > Date:   Wed Mar 4 15:25:56 2020 +0800
> > > > 
> > > >    locks: fix a potential use-after-free problem when wakeup a waiter
> > > 
> > > I've queued it up for 5.5 and 5.4, thanks!
> > > 
> > > > I'm a bit surprised that it hasn't yet been applied, while some fixes
> > > > from 5.6-rc6 have.
> > > 
> > > Greg, I wonder if it makes sense to have you push a "Greg is here
> > > --->" "bookmark" in the form of a tag/branch on linux-stable-rc.git? at
> > > the very least it'll make it easy to see if something was missed or
> > > still waiting in the queue.
> > 
> > To quote Jeff Layton:
> > 
> > 	Hi Greg, there is a performance regression with this patch. We're
> > 	sorting through potential ways to address it at the moment, but you may
> > 	want to hold off until we have a fix for that merged.
> > 	
> > 	Sorry for the hassle!
> > 
> > Which is why I dropped it for now.
> > 
> > I'll go drop it again :)
> 
> I didn't see any mention of this on the stable list though.
> I also don't think that a performance regression outweighs the
> seriousness of the bug being fixed.
> 
> Ben.
> 

Looks like a fix for the performance regression was committed yesterday
to mainline.

dcf23ac3e846c ("locks: reinstate locks_delete_block optimization")

Cheers,
Nathan
