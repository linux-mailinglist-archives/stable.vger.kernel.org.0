Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F555A4391
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiH2HMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2HMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:12:43 -0400
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187B04D804;
        Mon, 29 Aug 2022 00:12:42 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id y3so13894044ejc.1;
        Mon, 29 Aug 2022 00:12:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=MSqMM4aEnjO/gK78QtEwWeffAOcbFLWjzfFBsK77XPc=;
        b=fSEA3+BluCBkEjbtx62cdgcmujmAs6z97n0YKM/CMUdaXaOPRMVDOe+lr+1AOkY8lE
         bIN7YoJ8RxEunJRQQmMzHD36W3sdzXomJf3P0X6oXM+tUO2wOgL4o77X1agsqbJInU2d
         V8DPDVJWsCxW9qr+LT7IzbPkbcKtb00k46eeavztxW15QS2UElfvCpHapKH60PikMj86
         gJtL+l0Z8W5BYPonUCJqIE+QVSuJVG651sERNvB3IkLT67YsqCj/82qJcMzra+HT2hvl
         8RBbdq9uVMST1/xvvVWI49SW5hV03tf6fpzbgJBI5WnSCxkpPClB1+HtPFeCh57oNAQA
         BXQA==
X-Gm-Message-State: ACgBeo1i9eKTkMYlxAPAgVvGTnGEErUei28SqS5xArvm/J4nMv4E5lej
        e+sp+UXYaiqo2SzNY7zFiQ4=
X-Google-Smtp-Source: AA6agR4ol21KX2mKJiXGb6L9rLzNUeTO+E03VzEAMfYBHtubtcipcN9LN7sMgqVAWuiQLVj4cJrEew==
X-Received: by 2002:a17:907:75c6:b0:741:75a0:b82b with SMTP id jl6-20020a17090775c600b0074175a0b82bmr3780766ejc.465.1661757160605;
        Mon, 29 Aug 2022 00:12:40 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id q12-20020a17090676cc00b007413dde3151sm3304316ejn.130.2022.08.29.00.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 00:12:40 -0700 (PDT)
Message-ID: <71dbe196-a3d4-41f4-a00c-24f8b0222288@kernel.org>
Date:   Mon, 29 Aug 2022 09:12:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 5.19 145/365] kbuild: dummy-tools: avoid tmpdir leak in
 dummy gcc
Content-Language: en-US
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
References: <20220823080118.128342613@linuxfoundation.org>
 <20220823080124.294570326@linuxfoundation.org>
 <9996285f-5a50-e56a-eb1c-645598381a20@kernel.org>
 <CAFqZXNv2OvNu7BctW=csNLevgGWyoT1R81ypH8pGoAeo3vd4=w@mail.gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <CAFqZXNv2OvNu7BctW=csNLevgGWyoT1R81ypH8pGoAeo3vd4=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27. 08. 22, 10:34, Ondrej Mosnacek wrote:
> On Sat, Aug 27, 2022 at 9:51 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>> On 23. 08. 22, 10:00, Greg Kroah-Hartman wrote:
>>> From: Ondrej Mosnacek <omosnace@redhat.com>
>>>
>>> commit aac289653fa5adf9e9985e4912c1d24a3e8cbab2 upstream.
>>>
>>> When passed -print-file-name=plugin, the dummy gcc script creates a
>>> temporary directory that is never cleaned up. To avoid cluttering
>>> $TMPDIR, instead use a static directory included in the source tree.
>>
>> This breaks our (SUSE) use of dummy tools (GCC_PLUGINS became =n). I
>> will investigate whether this is stable-only and the root cause later.
> 
> It looks like both the Greg's generated patch and the final stable
> commit (d7e676b7dc6a) are missing the addition of the empty
> plugin-version.h file. It appears in the patch's diffstat, but not in
> the actual diff. The mainline commit does include the empty file
> correctly, so it's likely a bug in the stable cherry pick automation.

Right, this fixed the issue for me:
--- 
a/patches.kernel.org/5.19.4-144-kbuild-dummy-tools-avoid-tmpdir-leak-in-dummy-.patch
+++ 
b/patches.kernel.org/5.19.4-144-kbuild-dummy-tools-avoid-tmpdir-leak-in-dummy-.patch
@@ -20,6 +20,8 @@ Signed-off-by: Jiri Slaby <jslaby@suse.cz>
   scripts/dummy-tools/gcc | 8 ++------
   1 file changed, 2 insertions(+), 6 deletions(-)

+diff --git 
a/scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h 
b/scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h
+new file mode 100644
  diff --git a/scripts/dummy-tools/gcc b/scripts/dummy-tools/gcc
  index b2483149bbe5..7db825843435 100755
  --- a/scripts/dummy-tools/gcc

>>> Fixes: 76426e238834 ("kbuild: add dummy toolchains to enable all cc-option etc. in Kconfig")
>>> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
>>> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>    .../dummy-tools/dummy-plugin-dir/include/plugin-version.h | 0
>>>    scripts/dummy-tools/gcc |    8 ++------
>>>    1 file changed, 2 insertions(+), 6 deletions(-)
>>>    create mode 100644 scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h
>>>
>>> --- a/scripts/dummy-tools/gcc
>>> +++ b/scripts/dummy-tools/gcc
>>> @@ -96,12 +96,8 @@ fi
>>>
>>>    # To set GCC_PLUGINS
>>>    if arg_contain -print-file-name=plugin "$@"; then
>>> -     plugin_dir=$(mktemp -d)
>>> -
>>> -     mkdir -p $plugin_dir/include
>>> -     touch $plugin_dir/include/plugin-version.h
>>> -
>>> -     echo $plugin_dir
>>> +     # Use $0 to find the in-tree dummy directory
>>> +     echo "$(dirname "$(readlink -f "$0")")/dummy-plugin-dir"
>>>        exit 0
>>>    fi

thanks,
-- 
js
suse labs

