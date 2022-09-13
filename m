Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D305B7BF2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 22:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiIMUD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 16:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiIMUDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 16:03:41 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08F467CB8
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 13:02:15 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id y29so15689205ljq.7
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 13:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=UgahDT4K/6PJoSfdFDmAXx5aWHR/jtgde3ag9OrCEvc=;
        b=YBvb2t1GRBVuAc1boKut7G1X9ZGsJSAa6klS09qJccGduUaj+HOpCpw1Wn2ePQv24a
         YdrOC5GL83Cuy6dP7mkBF4n2ky3hW5ZqP48fw/XufxI2q42pCke9XF1ILdyk7dIDeOH3
         EHYcLAzawl0aQimZUDh7/BILxFZLeY1laCIls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=UgahDT4K/6PJoSfdFDmAXx5aWHR/jtgde3ag9OrCEvc=;
        b=ifm4AIDwQJF5Hz4rusa8D4JBz4GaVhfnjG0G2fzxct0sqpDKi6IP+p3DvmtJgSi8X/
         C8yP5dYEH1CHIxckNpKwrhT9I3/bwwsN1sv5vEKscpk9e1MJZzTypV2V/8LTXUM/F7ol
         OhVL2AGC5SXglpT6EhFTwrabNM9jSuTb6JIofkKPQCJLEU4xMqcSutThIvDpUgqyw1h6
         PECYcxRuk6FmpcSo4gVnMP+rq3kH5UEEZrvt4ddqXyIyerbNWZ5t/qYmrN24lVmxdCF+
         AErdPlBLxWHCe43afu6ItYWfMAxnEcVtPoeRcG+/oUrlnuUyd/6kDkFo11BsvcpO5ZGE
         X4yA==
X-Gm-Message-State: ACgBeo0tcpjSF1oILWOO6gnPfoYCls5/cx+6Jiq2y8pA7WJCCRi+UCXn
        e6+Lc7m3YHb05ZpoTNA6odHiIsgBtNFcyQ==
X-Google-Smtp-Source: AA6agR7WJhgfIPUHC+TNxSv9/VTF7wRBoD3MriLUEjPte/WsPUYV0ugDlB9N8gKc/0Zh3b2RWJt1Ew==
X-Received: by 2002:a2e:994f:0:b0:26a:ce85:ad98 with SMTP id r15-20020a2e994f000000b0026ace85ad98mr9665817ljj.481.1663099306027;
        Tue, 13 Sep 2022 13:01:46 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id be28-20020a05651c171c00b0026ad316375esm1969360ljb.38.2022.09.13.13.01.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 13:01:45 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id a3so9854081lfk.9
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 13:01:45 -0700 (PDT)
X-Received: by 2002:a05:6512:3b86:b0:499:4d:2c0b with SMTP id
 g6-20020a0565123b8600b00499004d2c0bmr6637721lfv.607.1663099305013; Tue, 13
 Sep 2022 13:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <166274826116451@kroah.com> <CA+ASDXNVxj-fCM94p5sbAn5-TShamWvTXN2r6KRp9+J9xJNqkQ@mail.gmail.com>
 <YyBq1zS13gwI7luy@kroah.com>
In-Reply-To: <YyBq1zS13gwI7luy@kroah.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 13 Sep 2022 13:01:33 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPuhZEyhTuk9i2mVvwKOTmAK96+TF3=z6kzTB7SndiFNw@mail.gmail.com>
Message-ID: <CA+ASDXPuhZEyhTuk9i2mVvwKOTmAK96+TF3=z6kzTB7SndiFNw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] tracefs: Only clobber mode/uid/gid on
 remount if asked" failed to apply to 5.15-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 4:34 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Here is what patch says:
>
> Applying tracefs-only-clobber-mode-uid-gid-on-remount-if-asked.patch to linux-5.15.y
> Applying patch tracefs-only-clobber-mode-uid-gid-on-remount-if-asked.patch
> patching file fs/tracefs/inode.c
> Hunk #3 FAILED at 278.
> 1 out of 5 hunks FAILED -- rejects in file fs/tracefs/inode.c
> Patch tracefs-only-clobber-mode-uid-gid-on-remount-if-asked.patch does not apply (enforce with -f)
> quilt returned 1, with 0 fuzz and 1 rejects
>
> How did you apply the patch to 5.15.y that worked?

Hmm, I suppose I have 'git am' doing 3-way merges for me, which resolve OK:

$ curl https://lore.kernel.org/all/166274826116451@kroah.com/raw | git am -
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  6614  100  6614    0     0  27768      0 --:--:-- --:--:-- --:--:-- 27789
Applying: FAILED: patch "[PATCH] tracefs: Only clobber mode/uid/gid on
remount if asked" failed to apply to 5.15-stable tree
Using index info to reconstruct a base tree...
M fs/tracefs/inode.c
Falling back to patching base and 3-way merge...
Auto-merging fs/tracefs/inode.c

And originally, I guess I was testing 'git cherry-pick', not literally
this patch. That also does some "auto-merging":

$ git cherry-pick 47311db8e8f33011d90dee76b39c8886120cdda4
Auto-merging fs/tracefs/inode.c
[detached HEAD e9f574cc9df9] tracefs: Only clobber mode/uid/gid on
remount if asked
 Date: Fri Aug 26 17:44:17 2022 -0700
 1 file changed, 23 insertions(+), 8 deletions(-)

I'll generate a clean patch based on the above, but it'll look awfully
similar. (I think there's a single line of context that looks
different, a few lines away.) Stay tuned.


Brian
