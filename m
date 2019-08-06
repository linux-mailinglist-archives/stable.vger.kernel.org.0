Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61AE82A21
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 06:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfHFEBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 00:01:03 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32797 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfHFEBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 00:01:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so40737137pfq.0
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 21:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3TFYUjYnPdFwbR/gZPSkhap+wwa2+UTWPedjNUfvaCs=;
        b=Ur1TTksHqEzo+3mspdwHLh/GPTMgpYFALryUKxCRN74kc9TNhwuseHRUfrQ9+59trc
         blJCGvuLj4KJ9h4GIfQaAG0/v5p5aZx6ZkjjIhmxB2gGTlbY/Uyv/yNEHl83mkKeUfwl
         Rjdynz3duonl57UAn+YkaQxrfx6OWvdYv7ied0JgviZXwpaKMlYB50/y7i/UCcUFwt9z
         /7PMYLpV96bsmqqQMkxc7RQjIAYURoc5Ji5kZcYDIgJffde5ee2BBZHS+v4PUvC2/0Os
         khZhvBeQ82l4kJJCLTlbg4ilgJXyPADJOwl+qUYiA5uWsAYsE7Ri1R0TRdugbH9aBrl0
         C64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3TFYUjYnPdFwbR/gZPSkhap+wwa2+UTWPedjNUfvaCs=;
        b=YV54Wu6nxELf58Nxn8gOHsAfNETCLRE+puA4Cl9sRFWUMC0TlOUvhe94senWqUmTTb
         /occbRjRZTw5zB7u0bD/4gw93wpKUTyN9C6+t4e0wDM3tAZr4soUxgMxVQSBX2jNziPL
         RxhLGWdBxKx4pugRmPa9JYlYypV+JfMY4p4WlTFXhJkaOwIaTRhnrusQEasThPsENxaL
         SThKTm/6xTaVtXFFtD8tmu41d/aQ8ilQSMC1Q3n3xKxG5YyQL6ychXWPO32pUujfTtEg
         vCARpubtlgrSHAS8xsWcXf1KciK7drrCz+3x6EM/hssj/ByyMxq2jHq9tmqouDaphNyu
         HBIA==
X-Gm-Message-State: APjAAAU3E/XW6VfLy224LnUyoin/DjmDJQR6QNOPMd+ON2azQzjlFpiF
        16ZP9mxFyTi2IDMZT6qEcJEiXg==
X-Google-Smtp-Source: APXvYqx1/4OA0fwfHhSRGbm8u/zUMW5hd76Tbpp6hlQ3NVYY8btzNNtrrWg6ZXfxmtcL7Je7iiXrQA==
X-Received: by 2002:a62:82c2:: with SMTP id w185mr1548036pfd.202.1565064061906;
        Mon, 05 Aug 2019 21:01:01 -0700 (PDT)
Received: from localhost ([122.172.146.3])
        by smtp.gmail.com with ESMTPSA id a15sm118235731pfg.102.2019.08.05.21.01.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 21:01:01 -0700 (PDT)
Date:   Tue, 6 Aug 2019 09:30:59 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Doug Smythies <dsmythies@telus.net>,
        "'Rafael J. Wysocki'" <rafael@kernel.org>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Linux PM' <linux-pm@vger.kernel.org>,
        'Vincent Guittot' <vincent.guittot@linaro.org>,
        'Joel Fernandes' <joel@joelfernandes.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits
 change
Message-ID: <20190806040059.ty4qhjarx4obomhs@vireshk-i7>
References: <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
 <000001d54892$a25b86b0$e7129410$@net>
 <20190802034819.vywlces7rxzfy33f@vireshk-i7>
 <1599417.3YyTWY6lWL@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599417.3YyTWY6lWL@kreacher>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02-08-19, 11:11, Rafael J. Wysocki wrote:
> On Friday, August 2, 2019 5:48:19 AM CEST Viresh Kumar wrote:
> > On 01-08-19, 10:57, Doug Smythies wrote:
> > > Disagree.
> > > All I did was use a flag where it used to be set to UNIT_MAX, to basically
> > > implement the same thing.
> > 
> > And the earlier code wasn't fully correct as well, that's why we tried
> > to fix it earlier.
> 
> Your argument seems to be "There was an earlier problem related to this, which
> was fixed, so it is fragile and I'd rather avoid it".  Still, you are claiming that the
> code was in fact incorrect and you are not giving convincing arguments to
> support that.
> 
> > So introducing the UINT_MAX thing again would be
> > wrong, even if it fixes the problem for you.
> 
> Would it be wrong, because it would reintroduce the fragile code, or would it
> be wrong, because it would re-introduce a bug?  What bug if so?

There will be two issues here if that patch is reintroduced:

- It will cause the BUG to reappear, which was fixed by the earlier
  commit. The commit log of ecd28842912 explains the bug in detail.

- And overriding next_freq as a flag will make the code fragile and we
  may have similar bugs coming up.

But yeah, lets continue discussion on the intel-pstate patch now.

-- 
viresh
