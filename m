Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0946B3B9600
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 20:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhGASPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 14:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbhGASPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 14:15:33 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93208C061764
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 11:13:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d12so6861915pgd.9
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 11:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L4frH1VEvCLr/97mRnBCvwJ264/bfXW3vbuxhIoApP4=;
        b=qA+se5SJjZr+edTPOtLJ7h0aK2mPbTeo9tni19LQFLZuBI+p3YeyI7z/yPAsj12icH
         7KhYeS0BPjRms2/R92sWpz4TiT5RJ9mrlMyg8HCT2QcpGyZ58ET7r4mAa3k4Drpr+Bb3
         IfY9Gp7+ov4NClwHadaJqCz+hXCppAnHa3UmocoYKqmhH0TbOD+8Yn5aZIyT78ZRSSI5
         otiTRLiW+MfEBcx0p0eLWitE5WsVroKp0vbBjWKncZ5dyzTmm2kwl2iIHAqsyFjf5rq9
         ZN+OYlmgboGfR9wCF37Q+VH2aaI4krgxWU1h60MFRwIDt9V5opaKYxwZ5d9spW5i62X2
         NINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L4frH1VEvCLr/97mRnBCvwJ264/bfXW3vbuxhIoApP4=;
        b=OIzqgnOpwKd115dufY6vf9QRA4olRxN6wYGP6EEWiiy9OSO1Acs1r7XVzHYc+2zEZa
         /6FzG8x2Sti4dz5msoaBwzeAGrZY/2IdyMwpySy//cmYQBzVvayfvL5Qk/+P13fqB67x
         2kPbMuG8f2F8AB5ig67VNyBU+f8CBieaMhfO6BWqtBP+c5Ima2Ah7roL+TjIkI0eA2tO
         3RS3VtkyCqrLwrhCN6FJNKTzYqg8jk4MLvc1LZzzzMyVWX1YmqqlKs1xk9Ofm7UJTds3
         /vpA6zW/y7YiCV2hwq550Wg3nn9Cwy8UrcGLPyIm4mlS+0IPUnLLB5ivd1wQMXsetSPP
         8XlA==
X-Gm-Message-State: AOAM5317HY/U3+ZKjtEAqoPQCM/GbMo6XV4n25Alk0l7n7dIFYXsho2e
        xyThkjvJmm4xHIEDBw3lsrpsFA==
X-Google-Smtp-Source: ABdhPJyxS2vr04XyiD8xgxoJw4VetJ6DJ10MV3IeZpelDf+BgQOvWN3SJQFtJxjKNv4LWx4oiHeI5w==
X-Received: by 2002:a63:2dc6:: with SMTP id t189mr827230pgt.442.1625163180986;
        Thu, 01 Jul 2021 11:13:00 -0700 (PDT)
Received: from google.com ([2620:15c:280:201:558a:406a:d453:dbe5])
        by smtp.gmail.com with ESMTPSA id m10sm649105pff.215.2021.07.01.11.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 11:13:00 -0700 (PDT)
Date:   Thu, 1 Jul 2021 11:12:54 -0700
From:   Paul Burton <paulburton@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Joel Fernandes <joelaf@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
Message-ID: <YN4Fpl+dhijItkUP@google.com>
References: <20210630003406.4013668-1-paulburton@google.com>
 <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com>
 <YN38D3dg0fLzL0Ia@google.com>
 <20210701140754.5847a50f@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210701140754.5847a50f@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 01, 2021 at 02:07:54PM -0400, Steven Rostedt wrote:
> On Thu, 1 Jul 2021 10:31:59 -0700
> Paul Burton <paulburton@google.com> wrote:
> 
> > I was tempted to just add the redundant checks anyway (pick your battles
> > and all) but for show() in particular it wound up making things seem
> > non-sensical to me ("display the value describing this non-NULL pointer
> > into tgid_map only if tgid_map is not NULL?").
> 
> I agree with your assessment, and will actually take your first patch,
> as I don't think the comment is that helpful,

Thanks - agreed, the comment doesn't add much.

> not to mention, we don't
> use '//' comments in the kernel, so that would have to be changed.

D'oh! Apparently a year away from the kernel melted my internal style
checker. Interestingly though, checkpatch didn't complain about this as
I would have expected...

Thanks,
    Paul
