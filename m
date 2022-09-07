Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF335AFDB5
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 09:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiIGHkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 03:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiIGHkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 03:40:35 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6737170D;
        Wed,  7 Sep 2022 00:40:29 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id a14so1365419uat.13;
        Wed, 07 Sep 2022 00:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=g16GP4bu/uD+DaOwHMIh0qkgrJd01UuDeeB5lzoFaA8=;
        b=GSCoAphAr6zgl1lLnGHCFub+qo42vZu2x/vkUi0a0iz/aLgnsLIqgYqCfKnYGZnH6k
         Ajpn/CzERT+iCu00abzYiZhCH/UAWRsyc5ApzZ8Pcj0tZlwnr3+KML68i5vHRc1gggEh
         5FTqP/Gz2RJF3SDpfVj6cT8vznWCY017f8SLiNQYoQjElpXUaaHZD3QnrXAEq5YUMxDz
         DB3zx9jaAJgDrJTAJ7bolO3h6uYVe+hH68W5aAcrzvhkWU1LkLK2eebBwYEasB7ch50X
         8iNBinlN8Yz24VH2fecPfLg2rtM9A5U9ZxMkpbMyPlfjaINOOpjfYey6j4G4lkiI7ibc
         NxiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=g16GP4bu/uD+DaOwHMIh0qkgrJd01UuDeeB5lzoFaA8=;
        b=HhUVKFxIuR59eApHjgmm/7tmVjqxQsvY7803SuRw9szpq4kC8stckzdW+IaPcsfTfc
         Tz8UILHWxXe98v2RMN4QwGe8UAvgXX5FGyACiI8hosD5h+YPoiIaOk0s7/MGZbFzqvjs
         yx6XZO15ulnhPbWOc9MIAaDMtqdkMoG2hnA3h/9wLuU4/6WGd4cnW6NYrFcbiB90yRVX
         YwRxbADhg1odwHRv7UEpp//MYk9HUo90tuh1H6rxiRtFE5jJcOFLQM38sgWJLbNzNkEA
         9sjdgyZS0e29B2C/sPmgc3jhNm2AEXcYKqJW/LbGUGssL4g68B/yRH/XUjuUEIiKFTX2
         xDOw==
X-Gm-Message-State: ACgBeo2P/sYLcBimqBLYybxydC6ybD3iAfcSF4a82shw6Iv9TxPp8Btz
        Jl5U3VE/Af5YgrTunxhgf0yXjNBWWs9B/Q6TuUXumY8YgqI=
X-Google-Smtp-Source: AA6agR7FesrkI+O6VNx9t6d6xVMKYrNLE3Qq8629sdBX8PoUqJ2NjcBPDgh1z5Be2ENgbsZxZYTXfSB6lo6i4a0yA0Y=
X-Received: by 2002:ab0:3b89:0:b0:39f:6dee:d6b with SMTP id
 p9-20020ab03b89000000b0039f6dee0d6bmr711667uaw.102.1662536428048; Wed, 07 Sep
 2022 00:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220906183600.1926315-1-teratipally@google.com> <20220906183600.1926315-2-teratipally@google.com>
In-Reply-To: <20220906183600.1926315-2-teratipally@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 7 Sep 2022 10:40:16 +0300
Message-ID: <CAOQ4uxi_Q8aXUg+FM0Q9__t=KqJSVqOgkS8j8kNC3MQfniZLWA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
To:     Varsha Teratipally <teratipally@google.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Dave Chinner <david@fromorbit.com>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 6, 2022 at 9:36 PM Varsha Teratipally
<teratipally@google.com> wrote:
>
> From: Christoph Hellwig <hch@lst.de>
>
> XFS always inherits the SGID bit if it is set on the parent inode, while
> the generic inode_init_owner does not do this in a few cases where it can
> create a possible security problem, see commit 0fa3ecd87848
> ("Fix up non-directory creation in SGID directories") for details.
>
> Switch XFS to use the generic helper for the normal path to fix this,
> just keeping the simple field inheritance open coded for the case of the
> non-sgid case with the bsdgrpid mount option.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Hi Varsha,

For future reference, when posting an xfs patch for stable,
please follow these guidelines:

1. Post it to xfs list for review BEFORE posting to stable
2. LKML is not a relevant list
3. Tag the patch with the target kernel [PATCH 5.10]
4. Include the upstream commit id
5. Add some description (after --- line) about how you tested

Regarding this specific patch for 5.10, I had already tested and posted it
for review back in June [1].

Dave Chinner commented then that he was concerned about other
security issues discovered later on related to the generic implementation
of SGID stripping.
At the time, the generic upstream fixes and tests were still WIP.

Christoph Hellwig, the author of the original patch replied to Dave's
concern:

"To me backporting it seems good and useful, as it fixes a relatively
big problem.  The remaining issues seem minor compared to that."

Christiain Brauner who has been reviewing the generic upstream
also agreed that:

"Imho, backporting this patch is useful. It fixes a basic issue."

So this specific fix patch from the v5.12 release, which is not
relevant for 5.15.y has my blessing to go to 5.10.y.

Regardless, the last bits of the upstream work on the generic
implementation by Yang Xu have landed in v6.0-rc1 [2] and the
respective fstests have just recently landed in fstests v2022.09.04.

I already have all the patches backported to 5.10 [3] and will start
testing them in the following weeks, but now I also depend on Leah
to test them for 5.15.y before I can post to 5.10.y and that may take
a while...

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/CAOQ4uxg4=m9zEFbDAKXx7CP7HYiMwtsYSJvq076oKpy-OhK1uw@mail.gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/20220809103957.1851931-1-brauner@kernel.org/
[3] https://github.com/amir73il/linux/commits/xfs-5.10.y-sgid-fixes
