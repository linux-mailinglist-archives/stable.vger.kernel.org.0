Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4DC60551C
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 03:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiJTBkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 21:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiJTBkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 21:40:19 -0400
X-Greylist: delayed 224 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Oct 2022 18:40:14 PDT
Received: from 002.mia.mailroute.net (002.mia.mailroute.net [199.89.3.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250C3E0991
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 18:40:12 -0700 (PDT)
Received: from 002.lax.mailroute.net (002.lax.mailroute.net [199.89.1.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by 002.mia.mailroute.net (Postfix) with ESMTPS id 4Mt9DK1PV2z25hY3
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 01:36:17 +0000 (UTC)
Received: from localhost (002.lax.mailroute.net [127.0.0.1])
        by 002.lax.mailroute.net (Postfix) with ESMTP id 4Mt9CY51ZMzGpmD
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 01:35:37 +0000 (UTC)
X-Virus-Scanned: by MailRoute
Received: from 002.lax.mailroute.net ([199.89.1.5])
        by localhost (002.lax [127.0.0.1]) (mroute_mailscanner, port 10026)
        with LMTP id Xa4zryYPBcVH for <stable@vger.kernel.org>;
        Thu, 20 Oct 2022 01:35:36 +0000 (UTC)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 002.lax.mailroute.net (Postfix) with ESMTPS id 4Mt9CX5LxDzGpm3
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 01:35:36 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id bd33-20020a056a0027a100b005665e548115so8670736pfb.10
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 18:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s84IK5ZpIas0l3tXvn3vU3R5PeAHMcM0QykoMJwkgJ0=;
        b=oy/7V0qlHU2zl9gHCmjr+2I1CSrjzD+N309Ra2kZBjUYDm7t9jmCv/ANh/iO8riPlS
         PuCuYxZDUrUQL7oKZtIGIykHEeEyBFShJ+cqT8Azc6PyO+wcq3Sh+SXTaD+l9uqKKljI
         +jQGQdVvgdwilB7IQrWU8HbCuHl88zpJciP8/BcXEsK4s0hkGuwIDy/Dn32APDA3UUyS
         5AqjUevtRX52/cGez+urXliYjH29m5d5DVB+kEJZEQo/VOc281nSoLrW6WIbBi6H+w7r
         Vkes3I/2RTPDB9BjEqwormSJw7pJFYUsMz7zWJpbvALZyMRVL6b4v3myVJGgx+Qrb1zy
         xSiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s84IK5ZpIas0l3tXvn3vU3R5PeAHMcM0QykoMJwkgJ0=;
        b=oVyVagckSiTJhz4n52TWn1Vl2vmnE3a1K6HVsee2MFXK+oHziDbSr+kkUe9mgPfqYl
         gxlApZIEYNE+Lz/t/T8+EjMn+sWTeoPH4A7wRQij3RBHOWSmxfEsBtlllIHEr2F1ndAP
         RYgU0tMY3blQffB0XtgJooKk7p2+hOB8SYp5QrnBDQKKGxHel+AwwIZjlau8hbEtsMj1
         5hlZ1l+9isKniDLGKvbybhHbS+LJjVtkl4cSQB+sGdnpoHwQetOVES4OSBKPi0Gx0ppR
         c0yC0ldyNz7EPCeiPPWPZQAKWUAw1aXu7CBp7jKoG4ubRa7hbhbWDpBTJ7yB0ho6abvc
         TbTw==
X-Gm-Message-State: ACrzQf1AwdkAVAj0DwOjCM00NSVVbhFnpXqknABm8XuWVXF06D74NooM
        C8tGmiy5qZJvQD+kOYTleG43WujDSqbPCLbL/sbJwrwYbMInsdufPpn5fuiVKe9V7SaSUiUVNbv
        sQ7jchMCztPPqWJRTjoyh4TGDR6O/l2yyFPKcXNXjDLkG93Y=
X-Received: by 2002:a05:6a00:3202:b0:565:c863:78a1 with SMTP id bm2-20020a056a00320200b00565c86378a1mr11333898pfb.7.1666229735887;
        Wed, 19 Oct 2022 18:35:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7HsGFLjSI91FIhTwQr2u4SGD6l5e1/gXT/jz3B6gPoPhiBjczM6d31Zn8QY7R1cpdII0W0ggSLyMj3OK76JvI=
X-Received: by 2002:a05:6a00:3202:b0:565:c863:78a1 with SMTP id
 bm2-20020a056a00320200b00565c86378a1mr11333882pfb.7.1666229735628; Wed, 19
 Oct 2022 18:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20221019085604.1017583-6-jolsa@kernel.org> <Y1Cgp/TOmE8scCvJ@b995051e45c0>
In-Reply-To: <Y1Cgp/TOmE8scCvJ@b995051e45c0>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Wed, 19 Oct 2022 21:35:23 -0400
Message-ID: <CA+pv=HPV0iG0NDe6K=7hBa1sVh-cWZZ8XZTVCrHZPDq7A1Z_2g@mail.gmail.com>
Subject: Re: [PATCH stable 5.10 5/5] kbuild: Add skip_encoding_btf_enum64
 option to pahole
To:     kernel test robot <lkp@intel.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, stable@vger.kernel.org,
        kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 9:14 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi,
>
> Thanks for your patch.
>
> FYI: kernel test robot notices the stable kernel rule is not satisfied.
>
> Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> Subject: [PATCH stable 5.10 5/5] kbuild: Add skip_encoding_btf_enum64 option to pahole
> Link: https://lore.kernel.org/stable/20221019085604.1017583-6-jolsa%40kernel.org

Uh, this should be fine though, right? The stable list was the primary
recipient and all show up for me in my stable folder.

-srw
