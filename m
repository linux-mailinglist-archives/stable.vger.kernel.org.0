Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269F36A699C
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 10:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCAJOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 04:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCAJOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 04:14:33 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4D030187
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 01:14:10 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id s8so7951601ilv.10
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 01:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677662048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2W74kZgdzLwXeWfd5vUawHJhbxagnPJTHMTQTU6PIRY=;
        b=EqdQFRMJfDAc/HB9IYLLJHxZN3CZe6nWDd+o5+XRMUDJQ1rQKQSXWRpl3TNvJqEf22
         3moVrMnX/2UKnpa5STzEtEdRpLvIgT6yA5JnEt2H0llyXGpK6ZSPTeEPWWA/3FaZvO39
         3r9l3D0gg5kbrWUToc4sGP/v4KDnfS0X3Im0hGFdqX1HlzYniB5hgj5r+suen7IjBaQZ
         pbJNZWIKe+g7jDixy7e00nMRq7zpfGPd1O5Dp+lI55iQYy5+0/P1VGg4V0+qMPIiCrV6
         FEQf1fYfBwVcSaVlK0FUlVrVYdep/6C0MnOxGgNQHmIx4AWKIPS+aAYYbOtfKruVLBhp
         EByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677662048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2W74kZgdzLwXeWfd5vUawHJhbxagnPJTHMTQTU6PIRY=;
        b=ksDepeehVhvu4vheEiasoREGg57rG6A41ZmcgbNYhmXqgtbuUjmK+JEQjR8Q7YoYEj
         q4z8XEL7+v1UnOj74ZJoySo6t+W54Ytj1jqMW3Yby3e8noJHLzzsMlGqFnQdix8jrz7j
         XoNIB0ibpiU0D0pksIppBbAxwop5Z0oWYZ2pffseSOqCyOrh1TQZzJiYtSHCMbBP71lj
         j0qJFcsxKeHuqp6phgqk82kVw6zDsklVM4nzi5+27Q4OAv0r+wpn25dl2XqYp6XOc1iW
         IZf/dA+RT6vIEuFHrK9tsd8rF+zRthHRjxAhhD2nLnMmzZrT2D6gBMeYwsDBOnikyA4H
         5Odg==
X-Gm-Message-State: AO0yUKVIqQEq1FBOmPxawJhRoGbqchew8xmNiKoxWd5ff9EXa8mBxwvg
        nnkJzMibDq5ndtcDjHHtIe0XXXG8HvgQ35jA11JcEA==
X-Google-Smtp-Source: AK7set898CCnTC3c5RyGK6sk6QHq0j8agD5VbcCuyIbbapZ6q5MuXC+HWFmomNCBZxpdUi1RTtnMOsUzsdcNg/In1/Q=
X-Received: by 2002:a92:300c:0:b0:317:b01:229 with SMTP id x12-20020a92300c000000b003170b010229mr2774235ile.2.1677662046865;
 Wed, 01 Mar 2023 01:14:06 -0800 (PST)
MIME-Version: 1.0
References: <20230301002857.2101894-1-kuba@kernel.org>
In-Reply-To: <20230301002857.2101894-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Mar 2023 10:13:50 +0100
Message-ID: <CANn89iKh_gZFgSBnF=TCBCspS-2EUWDT6vvXjsUvgM-rcQBqSw@mail.gmail.com>
Subject: Re: [PATCH net] net: tls: avoid hanging tasks on the tx_lock
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com,
        stable@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, simon.horman@netronome.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 1, 2023 at 1:29=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> syzbot sent a hung task report and Eric explains that adversarial
> receiver may keep RWIN at 0 for a long time, so we are not guaranteed
> to make forward progress. Thread which took tx_lock and went to sleep
> may not release tx_lock for hours. Use interruptible sleep where
> possible and reschedule the work if it can't take the lock.
>
> Testing: existing selftest passes
>
> Reported-by: syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com
> Fixes: 79ffe6087e91 ("net/tls: add a TX lock")
> Link: https://lore.kernel.org/all/000000000000e412e905f5b46201@google.com=
/
> Cc: stable@vger.kernel.org # wait 4 weeks
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: borisp@nvidia.com
> CC: john.fastabend@gmail.com
> CC: simon.horman@netronome.com
>

This seems sane to me, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
