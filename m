Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A411D2114
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 08:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733011AbfJJGxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 02:53:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43792 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfJJGxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 02:53:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id a2so3245691pfo.10
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 23:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=1tog4qOu28aA6MBUMyxcFn0XIhdAFDQXw6a1PcMV9YQ=;
        b=vaa/hrOuOtWmZoqekcNT/l2sNwCQcdVYJi0jw8jleaHfe3O8hcZqvuziiDv8hxM8Yi
         YGec/XSJmMvcTHvTxqxz2pQ5RA2eKyTLO48Ozj+Alv/FzGWW+qg4oZekR1irnnnI5LBp
         7Gkf68L5z/Hjh2979LubA5/jsC4cjONNKa+sewFyYm0qkbq+Oliut0uZXkQCDQJFi6bu
         SynjqkTnRwxofYY8ZEXYCtJlMWcKN//VdmUfELu8593kDCXDtNGYI13FQ1kk6Gjb3EFT
         5MFlP0YhUvPoNENnFSJgH+PeN9n+qYxI9FdyGdyLIIe7ArPJON201fbBck6Yd3/x405X
         AM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=1tog4qOu28aA6MBUMyxcFn0XIhdAFDQXw6a1PcMV9YQ=;
        b=sCLY68FOo6OT5nlmLcnvOsVjb0fX79uvklcnxcg7O75hE9kHD+Bfsr4kPX94VqxQSw
         JU/5qzlABnI9fNPmce6LclfkAcD0Bkw2yFDrfUz8AdNpw6KHyxQcFHLNDDRt4IH5qz7x
         hFMcVBUVscnEqjGwthxkJMPF9Zc9noCx924DILgybXHQ5yz+Kpi55nBx+0nY4vHWplnl
         BmoEBn7Emsia9IhdXf7dVBbhQjZHuuq8AT3iS4wrtnVBZCBZ+yaheh6qPxK0pnwmvEkz
         yIR7ZThIvrysH3PxypnBpsiuZpjgVCqPwjz4iHv5EcJeYK6l+1KnLYu0bDVx6QrmElji
         3Gng==
X-Gm-Message-State: APjAAAU86/7jraENGuO0leTs4kLiF8ro69t1pAQZmFmR56Y9qLz8kT4O
        bQXPqRMlB9ofkb4jDlcKcixiow==
X-Google-Smtp-Source: APXvYqxU20oqFB5TOhSKMaCwUM9mTTrvoKhEEwkYaAntasBDVIqDyOcWBnmY3OgD603MRBU9wdOBAg==
X-Received: by 2002:a17:90b:914:: with SMTP id bo20mr9126322pjb.6.1570690384766;
        Wed, 09 Oct 2019 23:53:04 -0700 (PDT)
Received: from localhost ([122.172.151.112])
        by smtp.gmail.com with ESMTPSA id 16sm4121658pfi.55.2019.10.09.23.53.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 23:53:04 -0700 (PDT)
Date:   Thu, 10 Oct 2019 12:23:02 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Linux PM <linux-pm@vger.kernel.org>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] cpufreq: Avoid cpufreq_suspend() deadlock on system
 shutdown
Message-ID: <20191010065302.ltdngpfqzpj3gxjr@vireshk-i7>
References: <20191003140828.14801-1-ville.syrjala@linux.intel.com>
 <20191004123026.GU1208@intel.com>
 <CAJZ5v0hsiyKfVcDFbnJKqDkCKWhbSfNrmm7yVhudONuS0SWALw@mail.gmail.com>
 <10202295.pfq90QWH5T@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10202295.pfq90QWH5T@kreacher>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09-10-19, 01:29, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> It is incorrect to set the cpufreq syscore shutdown callback pointer
> to cpufreq_suspend(), because that function cannot be run in the
> syscore stage of system shutdown for two reasons: (a) it may attempt
> to carry out actions depending on devices that have already been shut
> down at that point and (b) the RCU synchronization carried out by it
> may not be able to make progress then.
> 
> The latter issue has been present since commit 45975c7d21a1 ("rcu:
> Define RCU-sched API in terms of RCU for Tree RCU PREEMPT builds"),
> but the former one has always been there regardless.
> 
> Fix that by dropping cpufreq_syscore_ops altogether and making
> device_shutdown() call cpufreq_suspend() directly before shutting
> down devices, which is along the lines of what system-wide power
> management does.
> 
> Fixes: 45975c7d21a1 ("rcu: Define RCU-sched API in terms of RCU for Tree RCU PREEMPT builds")
> Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/base/core.c       |    3 +++
>  drivers/cpufreq/cpufreq.c |   10 ----------
>  2 files changed, 3 insertions(+), 10 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
