Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E381C6CF172
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 19:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjC2Rvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 13:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjC2Rvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 13:51:41 -0400
X-Greylist: delayed 462 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Mar 2023 10:51:32 PDT
Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d500])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB911FC0;
        Wed, 29 Mar 2023 10:51:32 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:5e51:0:640:23ee:0])
        by forward500a.mail.yandex.net (Yandex) with ESMTP id 9980C5EEAE;
        Wed, 29 Mar 2023 20:43:46 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id dhMcaO4DV4Y0-RpmWL4SQ;
        Wed, 29 Mar 2023 20:43:45 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1680111825;
        bh=+6hq+ziRMggGufmRgWE7w5d122tdGKys5kWzuZKVUlY=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=ocAFkHsKYq8hDDFbwOSDcQx9ejam55BOvIe2gdGzNi5HwmrEEMlYgq2q60zb06+5p
         OxL/e8/xRGTmNB+nfCI3Sokiy9iscLolRhuUUZ9W/hBjqyEnqDSZZVl3U38LBVg1Op
         NxTgxhatiACTTX/30DtkJgcbsT4eTpL2sU9ewG7M=
Authentication-Results: mail-nwsmtp-smtp-production-main-51.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <0994ea3a-e197-e938-6eab-72433d6547fd@yandex.ru>
Date:   Wed, 29 Mar 2023 22:43:38 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.0.y / 6.1.y] x86/split_lock: Add sysctl to control the
 misery mode
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net,
        kernel-dev@igalia.com, kernel@gpiccoli.net, fenghua.yu@intel.com,
        joshua@froggi.es, pgofman@codeweavers.com, pavel@denx.de,
        pgriffais@valvesoftware.com, zfigura@codeweavers.com,
        cristian.ciocaltea@collabora.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andre Almeida <andrealmeid@igalia.com>
References: <20221218234400.795055-1-gpiccoli@igalia.com>
 <Y6A6Q57/qz7w7cxM@kroah.com>
 <Y6BD9W7hk4CjhSdh@hirez.programming.kicks-ass.net>
 <3ff9f56c-479b-2dbd-9ee6-c7d00c7bd285@igalia.com>
 <ZCRx8YaAt7ybDlLM@google.com>
From:   stsp <stsp2@yandex.ru>
In-Reply-To: <ZCRx8YaAt7ybDlLM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sean, thanks for a head-up!

29.03.2023 22:14, Sean Christopherson пишет:
> Resurrecting this thread with a concrete use case.
> dosemu2, which uses KVM to accelerate DOS emulation (stating the obvious), ran
> into a problem where the hardcoded (prior to this patch) behavior will effectively
> hang userspace if the 10ms sleep is interrupted, e.g. by a periodic SIGALRM[*].

Yes, and we also created a ready-to-use
host test-case with no dosemu2 involved.

> Alternatively, we could try to figure out a way to ensure forward progress without
> letting userpace run an end-around on the enforced misery, but backporting this
> patch to stable kernels seems easier.
>
> Stas, do you happen to know what the oldest stable kernel your users use, i.e.
> how far back this backport would need to go?
It seems, the "broken" code was added by
the patch b041b525dab95 which is "described"
as v5.18-rc4-1-gb041b525dab9.
So I guess the answer would be "down to 5.18".

Of course I don't believe the patch you
mention, is a real solution. Its good for
-stable, but something else needs to be
developed in the future.

