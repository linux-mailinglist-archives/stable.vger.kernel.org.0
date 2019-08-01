Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408F57D589
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 08:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbfHAGfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 02:35:48 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34796 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbfHAGfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 02:35:48 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so31728650plt.1
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 23:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vy7fiSVgkFbOoM9oVuh/IZ30LQ8S9jpUhyBj3j5WAYE=;
        b=ae8KMe7vtw9CbOVo5NW8OvD+W3A0H5gmbjw08lE21V5g/XHpJKjPHpZ/4oz1312HMR
         gNLZHyAOxxb8maEL9vCVgtaRtYNEQPx24fbVagwL6bKGPWrqDPCYHxXrKM+LFxKSLyXv
         dFo+a9IZYyXAOcp8Vsiv4c3YJh9HHtXgSllMpNFr8PAGLOUpzWaBd6pZ6B+zJ6+yRkyk
         K6uldheuuNBHLqB3mgE42PqNe8v/fHXlwV3zJPVQ2inDSw0XhDAg2GNrwsN/g0mzWrdO
         rvej6sD9a41ViP7+3hsYS+G+QhCGpzNQ/bdeqlPzVtwzND5mVrRD0tSHN3hroO+PvfGh
         /lYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vy7fiSVgkFbOoM9oVuh/IZ30LQ8S9jpUhyBj3j5WAYE=;
        b=d0r35gWNfxH6IyxnuJEiPJmWfu/BhWkOjbXwPUX0z7zkeJKWLYZcfhJIm2KZEGHVIS
         ErBESs6zGPKAh+weYAq4U4ev3yXzJUZG7pTXHN3fTHq9rqtIW5+E5+8lbQKUN/Yc5FTN
         XTR0/QX23BLA0GMkhqQNxCUl/gU41i6+JHask0omgYqg0GP8gt8lbJkn4wVOCAddGJqh
         zNrKWmmaKoSGUQ21fQcJJpbU+1sd4/PWdBgg/deAUlW6qc4XgqKdD303oHrR+FToB7Z9
         u3FjayRGeaXuSRKs2h5VenD7J3r2Zsq6ZOHBguoEnvbT6eH5kBf/lBIB81c/K8/TNK4C
         uBYg==
X-Gm-Message-State: APjAAAULfAO0cHXUzv460WKXNF1OvbhJsiitVWa0uzef1iywOaxEwfgt
        wFKllghcXB8ueST706vs9EAv1A==
X-Google-Smtp-Source: APXvYqxzLt9itVfefRAkcodWXvJsyh1SKFRKmzWXDdVEME2BmOSrNLsKad//WkasBmqGS2/yrA2+SA==
X-Received: by 2002:a17:902:820c:: with SMTP id x12mr125486939pln.216.1564641347199;
        Wed, 31 Jul 2019 23:35:47 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id f15sm4067463pje.17.2019.07.31.23.35.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 23:35:46 -0700 (PDT)
Date:   Thu, 1 Aug 2019 12:05:44 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Julien Thierry <julien.thierry@arm.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH v4.4 V2 25/43] arm64: Move BP hardening to
 check_and_switch_context
Message-ID: <20190801063544.ruw444isj5uojjdx@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
 <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
 <20190801050940.h65crfawrdifsrgg@vireshk-i7>
 <86354576-fc54-a8b7-4dc9-bc613d59fb17@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86354576-fc54-a8b7-4dc9-bc613d59fb17@arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01-08-19, 07:30, Julien Thierry wrote:
> I must admit I am not familiar with backport/stable process enough. But
> personally I think the your suggestion seems more sensible than
> backporting 4 patches.
> 
> Or you can maybe ignore patch 25 and say in patch 24 that among the
> changes made for the 4.4 codebase, the call arm64_apply_bp_hardening()
> was moved from post_ttbr_update_workaround as it doesn't exist and
> placed in check_and_switch_context() as it is its final destination.

Done that and dropped the other two patches.

> However, I really don't know what's the best way to proceed according to
> existing practices. So input from someone else would be welcome.

Lets see if someone comes up and ask me to do something else :)

-- 
viresh
