Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7845C43C5FF
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 11:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhJ0JFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 05:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbhJ0JFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 05:05:30 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF9FC061745
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 02:03:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z14so2853852wrg.6
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 02:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=m/lmfg8lrkJFw99bDPYgEC/M85U2yW6MPQbOK719Eac=;
        b=c55XGKacwy9vWeUKJwi+1vmNzQUpF4OcfK85SURbp8fUvAMXbgZaSbE9V/JdWYTaw6
         SCzO02w0G1e2Zl1OpxgrLJ9aAsgkY8jOFc8FLP+dY0s/uZPRN4VQe/yzFoE57w5M7/Yg
         vuUU3nZJZ1xs3XEkVJdO9YHuuyueF9+fJKAT3M5GNpgUXUNJ1FqxH/LHXThQg2L/aUgI
         U6/v2DI/aAhF3QuDdhWfq+25Yk159N21V4DDakSBGizToeOyMOfj+LokECPvdJQZzBE2
         u/OdjHgsjFhP/82+VcjBv6jRk9PZlfL7D+hTN2C2ir8RqMWP06/PLmgvD364+4GUifgz
         vigg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=m/lmfg8lrkJFw99bDPYgEC/M85U2yW6MPQbOK719Eac=;
        b=t4YrzsDOTVKtYBU3uPKQ4IXf+D5FYKHZPnGDh/NKm/3uDKErsTZKfZlEOLELW0qwyI
         v5PVtVyJQs01zBbUtNQamqG/UxQHPLqsbudZHq5Ea6VnxnsZcOCSJ9mRYO15ee3hYqAr
         Q4RYc2Xcqo4GH7GFL4XeTm6L6QXzC4SnIw0zxJxzdVhYePofe5ngnnfurCmjJSnbHLtu
         hiFF+Zh47GfTTQVDUWclIa5NIAgaTlYzDjbvtMBgzW9rKcvSM+gGEdxa/nDzmd4khYaw
         s4yCxEasehCG1jSkpafbq3r9awLlh76NNe8rSBtATb4zCKhKiqhFcL7ibU+4HM/sIANz
         I9SQ==
X-Gm-Message-State: AOAM533j98SZD6RuRSNmk6/dcVoemRtRAkyMxUccydgr/2u6YQuuTSuU
        3bILR6RoJnnqPs42eb1hja1i7w==
X-Google-Smtp-Source: ABdhPJyjC2QuqWMe5pFr62dB8fh6LQPMeVykpGEWtlGNH3NBw+AL+uOyIjCFEtX8F9Eah9U7fKBW5g==
X-Received: by 2002:adf:c183:: with SMTP id x3mr36753950wre.90.1635325383584;
        Wed, 27 Oct 2021 02:03:03 -0700 (PDT)
Received: from google.com ([95.148.6.207])
        by smtp.gmail.com with ESMTPSA id b19sm2995765wmj.9.2021.10.27.02.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 02:03:03 -0700 (PDT)
Date:   Wed, 27 Oct 2021 10:03:01 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 1/1] io_uring: fix double free in the
 deferred/cancelled path
Message-ID: <YXkVxVFg8e5Z33zV@google.com>
References: <20211027080128.1836624-1-lee.jones@linaro.org>
 <YXkLVoAfCVNNPDSZ@kroah.com>
 <YXkP533F8Dj+HAxY@google.com>
 <YXkThoB6XUsmV8Yf@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YXkThoB6XUsmV8Yf@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Oct 2021, Greg KH wrote:

> On Wed, Oct 27, 2021 at 09:37:59AM +0100, Lee Jones wrote:
> > On Wed, 27 Oct 2021, Greg KH wrote:
> > 
> > > On Wed, Oct 27, 2021 at 09:01:28AM +0100, Lee Jones wrote:
> > > > 792bb6eb86233 ("io_uring: don't take uring_lock during iowq cancel")
> > > > inadvertently fixed this issue in v5.12.  This patch cherry-picks the
> > > > hunk of commit which does so.
> > > 
> > > Why can't we take all of that commit?  Why only part of it?
> > 
> > I don't know.
> > 
> > Why didn't the Stable team take it further than v5.11.y?
> 
> Look in the archives?  Did it not apply cleanly?
> 
> /me goes off and looks...
> 
> Looks like I asked for a backport, but no one did it, I only received a
> 5.11 version:
> 	https://lore.kernel.org/r/1839646480a26a2461eccc38a75e98998d2d6e11.1615375332.git.asml.silence@gmail.com
> 
> so a 5.10 version would be nice, as I said it failed as-is:
> 	https://lore.kernel.org/all/161460075611654@kroah.com/

Precisely.  This is the answer to your question:

  > > > Why can't we take all of that commit?  Why only part of it?

Same reason the Stable team didn't back-port it - it doesn't apply.

The second hunk is only relevant to v5.11+.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
