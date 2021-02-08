Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC34B3140B0
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 21:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhBHUmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 15:42:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232762AbhBHUka (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 15:40:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612816743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=btg00I64wsKOUWqtLHwx48Qsg1d88XywVIHITa//+D8=;
        b=gXBAriF4D3p/m9BCupevT+80C337LEGkE6PSOQLWRd8HzxmaARWV/jpI94yshBDunPNFjs
        mNQtNF2NhjmrYi5+gFUrec+1GYOJ1P2g+QZBNvOlZMiD2Bv9jNszz0krw2TdigcqDWG+uG
        TAWNzhlTQkIRJ10gT6mLqOnhNUYU7lU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-VRWIMA1yMO2jUE5VtIKU8A-1; Mon, 08 Feb 2021 15:39:01 -0500
X-MC-Unique: VRWIMA1yMO2jUE5VtIKU8A-1
Received: by mail-ed1-f72.google.com with SMTP id y6so15486134edc.17
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 12:39:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=btg00I64wsKOUWqtLHwx48Qsg1d88XywVIHITa//+D8=;
        b=ubs3tt1/zWKAmF9uXwUFkXr74Rn5yBsVjbFa7IWp1pY5HanXpzN4rg1sv2KZhoWs/K
         XcGS7TaPYL54jLpuvg3zxt0kWZS9Q8qg05ehk0yomwEcXKGtDr+wRPC7aSw3JKdTrnXL
         V3dJyl8yDL3h79MZ7RH4mOPSOxdGFntgHl/rgrPo9BtqCoSsJdQkcLDtnHrUS4WxKs0I
         vXQ/OFdj1Md9QQ+hjHCc8WI0uw0X1Hju2OKFVRk7h74R1TmaPSdIGq8bwG5lyp609NgQ
         MPd0Ap8q1fpBaFtfXpzPDr3m9f5z76Pf97k4B61Urr+dE/cfYRYkclRlhL3IQkMGqoUn
         KEvQ==
X-Gm-Message-State: AOAM532OavQKuJ5W2nZ8BJ/mKcQNYuinsO3moAjVNw4+PGCVD+SBzK+e
        xezQiMpBE+pVtbJiYwFwfYHvho1gr8nffG7fN8X9d7pkZ3WYAQa/f5Mds0P8iRYyGwJBg47GUdI
        9QULBhEFYBUye/lPi
X-Received: by 2002:aa7:da92:: with SMTP id q18mr19031902eds.91.1612816740199;
        Mon, 08 Feb 2021 12:39:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVlnb6rdi8weAO9rC4aWWfStAKzviyajrirVN/SteOO2IQxvjj1S6/SYDoQ9HL2IWg5NUEgA==
X-Received: by 2002:aa7:da92:: with SMTP id q18mr19031881eds.91.1612816740058;
        Mon, 08 Feb 2021 12:39:00 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id v9sm9266436ejd.92.2021.02.08.12.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 12:38:59 -0800 (PST)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
From:   Hans de Goede <hdegoede@redhat.com>
Subject: [5.10.y regression] i915 clear-residuals mitigation is causing gfx
 issues
Message-ID: <fe6040b5-72a0-9882-439e-ea7fc0b3935d@redhat.com>
Date:   Mon, 8 Feb 2021 21:38:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

We (Fedora) have been receiving reports from multiple users about gfx issues / glitches
stating with 5.10.9. All reporters are users of Ivy Bridge / Haswell iGPUs and all
reporters report that adding i915.mitigations=off to the cmdline fixes things, see:

https://bugzilla.redhat.com/show_bug.cgi?id=1925346

Which should be fully visible without a bugzilla account.

I noticed that 5.10.13 had one more related i915 patch, so I've asked the reporters
to retest with 5.10.13, 5.10.13 is better, but things are not fixed there, it just
takes longer for the problems to show up.

Greg, I can prepare a Fedora test-kernel build for the reporters to test with
the following 3 commits reverted:

520d05a77b2866eb ("drm/i915/gt: Clear CACHE_MODE prior to clearing residuals")
ecca0c675bdecebd ("drm/i915/gt: Restore clear-residual mitigations for Ivybridge, Baytrail")
48b8c6689efa7cd6 ("drm/i915/gt: Limit VFE threads based on GT")
(Note this are the 5.10.y hashes)

Reverting these 3 is not ideal, but it is probably the fastest way to get
this resolved for the 5.10.y series.

Greg, do you want me to have the reporters test a 5.10.y series kernel
with these 3 reverts ?

Regards,

Hans

