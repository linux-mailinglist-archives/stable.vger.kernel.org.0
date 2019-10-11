Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E7AD3975
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 08:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfJKGgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 02:36:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43405 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfJKGgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 02:36:49 -0400
Received: by mail-pg1-f196.google.com with SMTP id i32so5185878pgl.10
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 23:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4FLxp/dEwVPUkJCWIuKTHTWt7KberWtzFab1YKPFU6c=;
        b=rLzoC01nT0O1TGwVA8CD2rE2Y9cKGjZKGLgJM31cEKi8gCMVpMtRkROTRS2rRtXUy4
         Ww015Xa7LdpNbJdRXgULxCb7qgJfkClBp+tlo8MhdrUPMK9NVjULkJDnphfRyxHNxr4+
         UspiOslebs5rd0PxqrGmIP3ldHpd+WFY138dFXuSWNuk2zrZzGbPk9Ld7Zlf6jbb+R4g
         Tp6XMODF2LUm1zw9ArMOMHUi8gHRqB+5B88RI9HrHrnszhykteYTIozWlDLHHW79kVE8
         X0k8f+O2rQFvDqFY6ybZSp7j0ZTp2sbTEzHwYtS1dHbZ9wYC2UQB5g1BWKazRNe2cDoC
         SBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4FLxp/dEwVPUkJCWIuKTHTWt7KberWtzFab1YKPFU6c=;
        b=oEFrGh3W1laRBk9CMs4fThVTHxVvsPVqMJ8KXEBwvvzXZPeYEm2IWBp3pFOqSTfZPy
         YLXa2z/bRHaPXETf+1STyTl/b8Uwy1//kX3UesHSItckMxebKO29nB5evlGE4cLXM4Jg
         82Z49ELuqQ3nbLuuetmQTEIHNBLwdWWiOj+paTrr5F1ynLt67zk3VXHr/L2grZM0Uyjh
         frAllonazTYG91mkdQ63t7CAoafNNk/U1zpREJ0GgYdIR9791VIKOum1hVPo8R5D12Cz
         Jh2PkuL0xoIg5Srv6to+3N78zg+eBHx6vn2AGwgx8JfBYEmDbdJNwqcLNXOLWH0ov998
         ul3A==
X-Gm-Message-State: APjAAAVoEQcP+dosLP0rX2w37P7SNPxwCOKjunQntsTPHl99dbQkAla/
        onxe/YjP0x6NPZEF2TKnKCGHeg==
X-Google-Smtp-Source: APXvYqzLkaMl6CfDTwvz0FBFkKZME+VEpDqLMNl073+AEryuW84eYEaSUg06leZ233q8TXP8R7n/AA==
X-Received: by 2002:a63:2882:: with SMTP id o124mr15314781pgo.320.1570775808528;
        Thu, 10 Oct 2019 23:36:48 -0700 (PDT)
Received: from localhost ([122.172.151.112])
        by smtp.gmail.com with ESMTPSA id u9sm7255815pjb.4.2019.10.10.23.36.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 23:36:47 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:06:45 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH ARM64 v4.4 V3 12/44] arm64: cpufeature: Test 'matches'
 pointer to find the end of the list
Message-ID: <20191011063645.n2mhemjp4yy367ds@vireshk-i7>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <617ad445043f040c5ab986b9620b2ba7847b561e.1567077734.git.viresh.kumar@linaro.org>
 <20190902142741.GB9922@lakrids.cambridge.arm.com>
 <20190905074506.oxsw24xoex7gcfgm@vireshk-i7>
 <20190906134935.GA17375@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906134935.GA17375@lakrids.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06-09-19, 14:49, Mark Rutland wrote:
> Sure. I'll have to take another look over the series to figure that out,
> and as above I might not be able to do so until after LPC -- sorry!

Just wanted to check if someone was able to come back to this series
to give further reviews :)

-- 
viresh
