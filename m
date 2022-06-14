Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA56A54B9F6
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbiFNTCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 15:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357994AbiFNTBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 15:01:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECB92BD1
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 12:00:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z7so12925382edm.13
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 12:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0RtQY3s2vYYq68H+r/lgX/x0yv7hdr9UXLRzRq5pNtQ=;
        b=IEOJkNe1bGyhhPHG1DEoQ0Ucjm42dZ1O7iMPXmgYjEYU66yMJUuQsKaOmWMADxC5gz
         06N8t4Rugf6GWyqk1uKlXIXS1WO36VAykdBQK9w2aI1uoNIFb3DN0ZZMpBYcZuF/11iE
         I5MsnbrRo0uIWSGXelUcnUz0/6CZIKWNOoStE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0RtQY3s2vYYq68H+r/lgX/x0yv7hdr9UXLRzRq5pNtQ=;
        b=z7QyXTrOCMEIa/Hkw5PQyEhodeEoxx5iv/VNyQVEoZrRGx8u38j1aoYFupXwgcgoTk
         OsRAeriUVJ1BgL9q0vawHzZeRWIn5ZEbFmCLQJRje9Kwbm9UAR8mGQDScvJgBKzoheP4
         kkxCfIGiE6jQxOnnh/YngNAlTkanPUkBWhJhmjjfyS+p7cYiKM4xXjovie3Cd5D+fByi
         mOC9hVWzhPdzzqqe3JA5g/sHgbUuEBpdnBoaqu5I4eYQrXOyYtprSct/QQyZ6SbViUDo
         F+V6qczWsNu7+6YyNt/4PN/rP+I0XIOL4MNd5q9TwaBX71GGssb8S9BpfITQdHF1k9JP
         7c+A==
X-Gm-Message-State: AJIora8bEQJLpz7kUyt8Sd1bdq2YKpw7cAfclaAKcIcw07fhWVtOvt8g
        BFDmdKg2DDO5jK33DYVHLUizXFH4aQ6nmZAkOEQ=
X-Google-Smtp-Source: AGRyM1v7jl93w10D9PlencONTwt7f/XAs8o/3aw0GRBnrczuLdUaSSAxTATxph/GsDsZtv/gUTpxvw==
X-Received: by 2002:a05:6402:274a:b0:42d:dcd1:c847 with SMTP id z10-20020a056402274a00b0042ddcd1c847mr7785967edd.169.1655233241395;
        Tue, 14 Jun 2022 12:00:41 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id r12-20020a170906a20c00b006f3ef214db4sm5382431ejy.26.2022.06.14.12.00.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 12:00:39 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id e5so5186518wma.0
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 12:00:39 -0700 (PDT)
X-Received: by 2002:a05:600c:354c:b0:39c:7e86:6ff5 with SMTP id
 i12-20020a05600c354c00b0039c7e866ff5mr5742710wmq.145.1655233239137; Tue, 14
 Jun 2022 12:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <bd80cd0d-a364-4ebd-2a89-933f79eaf4c7@tmb.nu> <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
In-Reply-To: <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Jun 2022 12:00:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgfFhwMP0=QQY_iZvf0kveR5=VGK919Ayn+ZSUADs9mag@mail.gmail.com>
Message-ID: <CAHk-=wgfFhwMP0=QQY_iZvf0kveR5=VGK919Ayn+ZSUADs9mag@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
To:     Thomas Backlund <tmb@tmb.nu>, Jan Kara <jack@suse.cz>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 11:51 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Or just make sure that noop_backing_dev_info is fully initialized
> before it's used.

I don't see any real reason why that

    err = bdi_init(&noop_backing_dev_info);

couldn't just be done very early. Maybe as the first call in
driver_init(), before the whole devtmpfs_init() etc.

But I might be missing some dependency there.

              Linus
