Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D96D18278C
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 04:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbgCLDwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 23:52:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41071 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387453AbgCLDwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 23:52:41 -0400
Received: by mail-qt1-f195.google.com with SMTP id l21so3304498qtr.8;
        Wed, 11 Mar 2020 20:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WUYv968HTJjo1Mkp2/EuQ7/8GKIJ2nyGafz2Vr8qTVU=;
        b=vVMFSuX799qi1oZfkM763trW9w5t0dLOrZsD+gKWVTb+cnNmhasgRFnkZVGyWZh3aa
         Mq1aOr0aivlPh2BaZC2fTWQXFWfAOSE+uV9TeIPNCv4lRInrqOz5NGNb5he7AlpH5+Vn
         IcplsE90MjuAk2JQZJTyXmGrlo76pG/lH/lPERxK5chFrFY6k4ZIAvAP9iXUqQv1+wf8
         A5ivCiLHvrAytRq8uFCzpYHkUWUNJDdSxOIhxPQIWdwnvvR3oXsviVm5uCb3bwNkVsJo
         f8MWSlFm9B8qibj5U0gje3m022CRZ2OOZ+NfMjME9LHSP5GG+mSYxGpFeiqElrOIY4pt
         EOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WUYv968HTJjo1Mkp2/EuQ7/8GKIJ2nyGafz2Vr8qTVU=;
        b=FNNA4EyC0oLsch4bcvOZ8anQjgBw/Do/51h6eb+ZVtMswRMmXCUHIniblrft/2rIrJ
         NRb80RRRjFyaklQSVPfzdiIlPRbsPh3ShRbkqVqNWiph73Vjv8RKfTc5hv/avlwIT5NT
         Zt0FCZw0sS/Ui3RJAt4HmMVTlVhlomIX4+c1Oe/n87P1jWmDfndF1FhJ09N1OF6N2VCj
         xb3WZZWF73WVms7lbKUmAMRqAFk0rDe3NsP9uMFI94FhgEv6xXrI7RR1dqsuEn09T0Ae
         CAgceCb2TgknJpSPQmcpzZ4Q41XZW/mTXY7Z04XLGPsFlzR0VrsDpAovIvluYNSUMJrt
         EPGw==
X-Gm-Message-State: ANhLgQ2n9knsb69KfcS35WXJOtEwn4AF5dbU28tbMQNYFHbOW4F0WZxx
        +BIO5k8+BvkdL+IBPZt2g3mLt+fMgdQ=
X-Google-Smtp-Source: ADFU+vsr7Qn8d5IsLiuWpSqtsp+6BR3IFdwwAKdoOOHKkgW9qSF96V8Tse0BhdrAktQUvAmOzrFgwA==
X-Received: by 2002:ac8:4cc9:: with SMTP id l9mr5461056qtv.207.1583985159524;
        Wed, 11 Mar 2020 20:52:39 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id x1sm7836549qkl.128.2020.03.11.20.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 20:52:39 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Wed, 11 Mar 2020 23:52:37 -0400
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4.19 84/86] efi/x86: Handle by-ref arguments covering
 multiple pages in mixed mode
Message-ID: <20200312035235.GA270934@rani.riverdale.lan>
References: <20200310124530.808338541@linuxfoundation.org>
 <20200310124535.409134291@linuxfoundation.org>
 <20200311130106.GB7285@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200311130106.GB7285@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 02:01:07PM +0100, Pavel Machek wrote:
> We don't really need to do this computation on pa, it would work on va
> as well, right? It does not matter much, but old code worked that way.
> 
> Plus, strictly speaking, pa + size can overflow for huge sizes, and
> test will return false negatives.

This is 64-bit code, overflow would need pa + size to be bigger than
2^64, and even then a false negative would need size to be around 2^64.
