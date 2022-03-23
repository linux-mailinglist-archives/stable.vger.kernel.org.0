Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81414E5A0D
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 21:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344815AbiCWUqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 16:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344804AbiCWUqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 16:46:45 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244641CB0B;
        Wed, 23 Mar 2022 13:45:15 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id m30so3846246wrb.1;
        Wed, 23 Mar 2022 13:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u9d0f/NedwcIVfjLdWBxuOPqRd+ooLfwyim+u/FbE7M=;
        b=SYqThQRUSiqOTU5MMDxdf9iUHUwlTyxJdc4G1pFJVS7RrKE3B3aYNAzgiG+bAFz5jY
         JptGFHgOu7VoFF+xogseEBMjYs2YSqf+/CXjeVMZ27qsoIbnZ8GuZCQCNFzUPqxDWIiv
         Y6hlFz5ehTzsjm1dc4qKcSZhhIhYDvoRUHEBdhna0AvXbixZBIYp9x24BYOUfGBZG8zN
         yVefL8LsmX8xeSgYG/BJz+9snB/aNWclTv1jqi/eL+wCTb7n9O5VDrAsyPp9dhqrkyhn
         jXuEJk1CmmWpTxy7zPERGF/YcEF8g+PR6MZggmrtEqapb2hLn7HqM15XhNf5mxXFeEU9
         186g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u9d0f/NedwcIVfjLdWBxuOPqRd+ooLfwyim+u/FbE7M=;
        b=D2YSsHnZfZTUi3g5i0CHXni+iuFHBGdNYnHw4V4gbYCzh/S4ju6abdhwpVVBobQ0eO
         oKn3FmFvt+vGWpwW3ZPoXlL7ExtBC1dXqpNFq3RJFE/mO3V4f9Oqk7VIfcNtxt2KLhw6
         2ZCd2GMlZAbyKHRh0hPqF6fCIrYxR9F0LRqeKdtGGqaDU4krY3J+HpMR2RsW+c9H0zs6
         wBkvhX2Kvq/yg/E9i4HNpmyqzygtYcxLDmad/lGffe8fNQ7WBTv8fM+MZtffDp48FQis
         WdDvdVb49BURgTZWSO8bFL2/duvf7xx+xhDc/p95dGcRSPFNcurBkY3vNPcLQcYVqY1o
         kHTw==
X-Gm-Message-State: AOAM532nUIHHUn0EweSjL6oQy+rXT5pG3U9dXEjBJXb6VuwyRjcagG/r
        VNh/TgFMNIMhT12gxg6J+DXfroThcYDn8XCk/Jg=
X-Google-Smtp-Source: ABdhPJym31SP0o+rELGefoebjTeOa0AXP6LwIwrWOKdloI6/jD6iyd249G90/HkXbWaJ1W+QHpe5c3MMg2B/BLmELT8=
X-Received: by 2002:a05:6000:18ac:b0:203:ecad:a203 with SMTP id
 b12-20020a05600018ac00b00203ecada203mr1626594wri.177.1648068313663; Wed, 23
 Mar 2022 13:45:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220323153947.142692-1-axboe@kernel.dk> <20220323153947.142692-2-axboe@kernel.dk>
 <64197456-87f2-e780-186d-272e06ae223b@gmail.com>
In-Reply-To: <64197456-87f2-e780-186d-272e06ae223b@gmail.com>
From:   Constantine Gavrilov <constantine.gavrilov@gmail.com>
Date:   Wed, 23 Mar 2022 22:45:02 +0200
Message-ID: <CAAL3td3_VFmOH1mNXiG6geFeONSm066Xba5ePqPwkMr-zxkDGg@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        stable@vger.kernel.org
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

On Wed, Mar 23, 2022 at 10:14 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 3/23/22 15:39, Jens Axboe wrote:
> > We currently don't attempt to get the full asked for length even if
> > MSG_WAITALL is set, if we get a partial receive. If we do see a partial
> > receive, then just note how many bytes we did and return -EAGAIN to
> > get it retried.
> >
> > The iov is advanced appropriately for the vector based case, and we
> > manually bump the buffer and remainder for the non-vector case.
>
> How datagrams work with MSG_WAITALL? I highly doubt it coalesces 2+
> packets to satisfy the length requirement (e.g. because it may move
> the address back into the userspace). I'm mainly afraid about
> breaking io_uring users who are using the flag just to fail links
> when there is not enough data in a packet.
>
> --
> Pavel Begunkov

Pavel:

Datagrams have message boundaries and the MSG_WAITALL flag does not
make sense there. I believe it is ignored by receive code on daragram
sockets. MSG_WAITALL makes sends only on stream sockets, like TCP. The
manual page says "This flag has  no  effect  for datagram sockets.".

-- 
----------------------------------------
Constantine Gavrilov
Storage Architect
Master Inventor
Tel-Aviv IBM Storage Lab
1 Azrieli Center, Tel-Aviv
----------------------------------------
