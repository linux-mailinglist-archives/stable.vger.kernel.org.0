Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B962253CBD
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 06:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgH0EcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 00:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgH0EcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 00:32:16 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB4FC0612A9
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 21:32:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id p11so2498661pfn.11
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 21:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=dKp2GETWl0ZucmlkjzrcyOtXdtr8PxIKbJ71zLroZNg=;
        b=ufIsPltK8Co8yZGA3JJ/d5Ht7EamyM27QBl0bSNGRT5S1cI8fZNTCFtdzcQECKzsNc
         1iB4rpJWe1Fqs1YAj2aTf6/VjKoAThW0q9QwAYcavQD5kwzM0P+0Sk470W7q7FyX3bMw
         3vFJHRLg4zNv5xcpBLz7iSPvEW4aOf48wiyGMGGfz0M3qNUxtQxT8awJi1QGdWondn5/
         PvmMAaeHxoXTpJMeTqvapCgAGZUaiPwP3rCBGpnawpsn3uuOA0PPStxSIoCFMprTka9s
         m4NLeh9HRoYBfCQ7sNRCOwoVft/Ag5HqlhQsLM+ADV0wbFESLhW8WU4njXvKCRTyJF8/
         QYJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=dKp2GETWl0ZucmlkjzrcyOtXdtr8PxIKbJ71zLroZNg=;
        b=lZQXoTcjpOuSPWPPdHcWGqtaMUeFoFYt3fN+SL5+KVxTT2Ke0Z+Wp/v14donrCn3sE
         hO+bO8v8cCJunEY1phgdkfL0KNPwF+XWMHI1mTXjw+6385F943NEU6u8gFQgoO3Ap1Em
         E0vNnB1qaUBDmGjIFscz/RnxPkZAE4jOnrYPR0Xc/VYC45+6L8ckVb9y72/SCCAwqh6d
         lFTpQTJTCjl2x23u8MW9S1nEajjlHECul5o26w0bMTgwZW0ub3Q14avvsi8oCtMJn5kI
         8wNLd7ZLQF3YcfPF5c2vXsRN9Bh5bHqapaytoTZcxKZU4oqTC9Q3uRX2gTtDMaMW7uzg
         QL9A==
X-Gm-Message-State: AOAM532SG8O51bZqvYaUsAU5Phyq9DS0oUQiU4Hmra7Miiap2wr1Dq9x
        eLh4QrUhUI4fBj4IHHgE8V2IUw==
X-Google-Smtp-Source: ABdhPJzTBI7Yt4vVu6iybAfI5Z5436bYMOR8JnUBB5vme+sjUpGfkavzB0Mqu3wI+8bv3Wn+dGvS9g==
X-Received: by 2002:a17:902:6a8b:: with SMTP id n11mr14317011plk.75.1598502735254;
        Wed, 26 Aug 2020 21:32:15 -0700 (PDT)
Received: from localhost ([122.167.135.199])
        by smtp.gmail.com with ESMTPSA id w14sm837748pfi.211.2020.08.26.21.32.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 21:32:14 -0700 (PDT)
Date:   Thu, 27 Aug 2020 10:02:12 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Rajendra Nayak <rnayak@codeaurora.org>,
        Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        linux-pm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2 1/4] opp: Enable resources again if they were disabled
 earlier
Message-ID: <20200827043212.ercvjq5tdgeyu6vq@vireshk-i7>
References: <c6bba235a9a6fd777255bb4f1d16492fdcabc847.1597292833.git.viresh.kumar@linaro.org>
 <20200826135408.54B8822B4D@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200826135408.54B8822B4D@mail.kernel.org>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26-08-20, 13:54, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: cd7ea582866f ("opp: Make dev_pm_opp_set_rate() handle freq = 0 to drop performance votes").
> 
> The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59.
> 
> v5.8.2: Build OK!
> v5.7.16: Build failed! Errors:
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
> 
> v5.4.59: Build failed! Errors:
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

I have already sent the right fix for stable.

https://lore.kernel.org/lkml/31f315cf2b0c4afd60b07b7121058dcaa6e4afa1.1598260882.git.viresh.kumar@linaro.org/

-- 
viresh
