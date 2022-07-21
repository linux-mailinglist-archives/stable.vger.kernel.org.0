Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EEA57C4E2
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 09:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiGUHDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 03:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiGUHDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 03:03:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A957C7AB1C;
        Thu, 21 Jul 2022 00:03:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C5EDB82339;
        Thu, 21 Jul 2022 07:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B488C3411E;
        Thu, 21 Jul 2022 07:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658386993;
        bh=VM0oLzDa8uJ5GNLVPNZm+mqO/OI9nNTkAnc0YIDvwmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NyWEynkOI3gX5YVwCrsEAj40fE8nUbfOvd3Uu3xT8jGJQSmC+9JJcPu3CRJjvXrlA
         T5TMqFjUWNkvtWYFMMKQFS/C4/ya6jX+OOi8uhQuwVI8IA5lbZo7Cqm1RzqvbtLAJ/
         rqVIi+7l9wdbdxi31hNHwZnaZN8UKcjNSQeFxGWs=
Date:   Thu, 21 Jul 2022 09:03:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Justin Forbes <jforbes@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <Ytj6LhlYHVq9Rmid@kroah.com>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
 <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
 <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
 <6cb8a9c9-d256-5db2-e352-e8de1165950c@kernel.org>
 <bb2516b5-8dd3-3223-0bdc-809e51311347@kernel.org>
 <9d2eaa61-17f6-1c26-b4a5-e615935d1625@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d2eaa61-17f6-1c26-b4a5-e615935d1625@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 21, 2022 at 08:58:47AM +0200, Jiri Slaby wrote:
> On 21. 07. 22, 8:05, Jiri Slaby wrote:
> > Thinking about it, that's likely the reason I'm not seeing any failures
> > -- I still carry all the retbleed patches on the top of stable. So while
> 
> Confirmed. So I assume this gets fixed once the rest of retbleed patches is
> dropped from 5.18.13-rc1.

Yes, let me fix this all up, sorry for the mess...
