Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BFC675EB0
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 21:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjATULS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 15:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjATULR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 15:11:17 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BED1A199B
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 12:11:16 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id b127so2963781iof.8
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 12:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HRqU9uEBTqzhDiWyPAG5GchN799BBQRFlOwkfwzE5+8=;
        b=XalxLION0iG89LP1bqX3jc+pOUHoY39NkgqmsISKgQsFnV0BozjJw8zs7wrAeGEllH
         KxkbKFzj7PIlMwoFnX8vj0hzMSOYjUehwgL5dYgotnBsQOlyGwfF4X6KK2tNRE1XHMwh
         R2hT7qcUX5il3jWHMOCROBfBvSmvAdpuIXBty6QMzyWBAFj5hDhXdrlg7TcL7vxw+OV9
         r0zqejByo+WXzylrgfCT9SD2OuTc/1A7Mt3RZr1waUVmfWXbdD3tiHaK2yywuQfoRomp
         ONKEyKV8EaYwTuuEcvQ1YbjT4Vdj6pWiqoNc15nPdbz6ier5tVV5C5ZpXRiYX/nThp5q
         veBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HRqU9uEBTqzhDiWyPAG5GchN799BBQRFlOwkfwzE5+8=;
        b=1jVMyCMLqSEsZzi5BixVcBRqCI3pYxtj4nbBHX4q1eSJp9dJI7bihBx9Yvf7dgbnEr
         MlbU55pTV/j/AgSnR+kpNPyWzO01Xu4n+85J7lN+NUlCCAl7To8mNHmgrqR5DVRSNvZ/
         52DCZZrKJpzDdGaAwLb22JtFsefdcphWc/DMQeglRjxiFR5PryZLqPLhWbWEOzKoO4SF
         Z0MWFRQTxSSZsc/z3vb3vYEZIXE/PnT3FG1CA7hQHw6uj4K3NcTSWUwDrZpS3Cj9Z7D3
         qkeQQXwtHqSxQBR6m1CD8rtQCyWBa07zWkEcTeZDcLmuaLS/DNryudttRdWizHWQFtrc
         IV9A==
X-Gm-Message-State: AFqh2kpp3bBLkwag/vgroYWoj23b09HRAhaThXLEE4ovcp9kzCDq4aJR
        1g42zrz66DSdPlm5elIX9KrjD4aSVWZyVWckEecpHw==
X-Google-Smtp-Source: AMrXdXsyHF+kdJryuvQKVYsxIhQ9BgXT893vLRtX10dVbY4MlCqk+9xKxeIscyJz/ZJijI41e1pk3DF2B1bQWgmIhU4=
X-Received: by 2002:a05:6638:419f:b0:3a4:e0b3:e6c7 with SMTP id
 az31-20020a056638419f00b003a4e0b3e6c7mr2056913jab.116.1674245475605; Fri, 20
 Jan 2023 12:11:15 -0800 (PST)
MIME-Version: 1.0
References: <20230117131839.1138208-1-maze@google.com> <Y8rrGaaDnIQyBSD0@donbot>
In-Reply-To: <Y8rrGaaDnIQyBSD0@donbot>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 20 Jan 2023 12:11:03 -0800
Message-ID: <CANP3RGdkOqtuV1bRq5wFmpr0Lw5yTa0L=mU-hJgim+Skd=iOVQ@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()
To:     John Keeping <john@metanate.com>
Cc:     Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Carlos Llamas <cmllamas@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

> This looks like the wrong place to fix things - if this case is hit,
> don't we go on to call usb_eq_queue() which can't be valid if the gadget
> has been destroyed?
>
> I don't see how cdev->gadget can be set to null without cdev being freed
> so is this actually a use-after-free not a simple null-dereference?
>
> My guess is that somehow the gadget is being destroyed while the network
> interface is held open (we've seen similar issues in other, non-network,
> gadget functions), but I don't know enough about the network side of
> things to know how to cause that from userspace.

I'm still waiting on confirmation of whether this fixes things.
So far we've seen it crash twice without the fix...

I don't know what triggers it - it's being triggered in some huge
automated test framework.
Whether the issue is lack of bind, or a too early gadget unbind... or
something else...

As mentioned in the patch, I'm not entirely sure if this is the right fix...
I certainly don't claim to understand the usb/gadget stack.

It does seem like usb_ep_queue() at least has some protections in place...
though no idea if they're enough - and whether we'll hit a
WARN_ON_ONCE now instead?

Honestly I don't even understand *why* we're sending out this speed
notification out of ncm_close...
(and if we do send speed notification of out ncm_close()... shouldn't
it always just say speed 0?)
