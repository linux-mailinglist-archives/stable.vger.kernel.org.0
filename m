Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278642FC4B9
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 00:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbhASX0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 18:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730197AbhASX0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 18:26:25 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF35C061757
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:25:45 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id f1so9475118edr.12
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nLVmnjsRjsvPfcv+qR81fqQ82nCHzCwJpCr3gMa8qpM=;
        b=dAcWGwcZtOkGl91KAQMik53LuZX6ZSccMFs3bWza9LyO6HI/lLfwFkwQlQ/01ybUmj
         k1wJaO07PHYttGv51JjnNL3KeZKrxz0FkL8MHwZ1+sRHblVhTtD6+8Dk1x86E6CkHLaV
         TwJKIm9tsm8JqdI9B/9cPQbV+eJ/uhc2hIfwDwms0xo/yRuM7KLh1iSazZtCZC8m+/rV
         qZYYudXenbF1RCPDn+tzzpCO9szONFhqvZRVfiR2xmDODdJADrrOnfAfFn8B5A1PVIjr
         Ih1xHbt74jirEAHXok5TvKhEniAJu4BDy1LTrWSK9KdKPcUfCgyUp4VTRaMId/q0jfbM
         ku+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nLVmnjsRjsvPfcv+qR81fqQ82nCHzCwJpCr3gMa8qpM=;
        b=BmEQROC9XxM/bDMlSfUa++ClMAo9HL9pP+iTYZQG3/IvYuMwhNcUeBlIWhnV3jFk25
         ok4Ch9026EulzxyBYhNDTeeEx6C8bdcHTrJYe2Rnqz3Dy1vWi4KwphK2cuLOMx0XYC8+
         YVK/HoqnBlHk4dtecHzYM+AI6FWGu1LPRcV68WTyYRI8SwJP1H0eE8QPSWjzeHqNLFaf
         r5cydq9NoWgjRNWHTMcd+K9YewvNXBP7LDWKYwdJDwhgHTfFCC325n+tKf3+IDanWuak
         HjC0ECvF2yvqhOND+kwd5Dtm/aMV1lVZuRknodiVfYk4YFK7BWo2uPxwy7quji5s8O1i
         CDXQ==
X-Gm-Message-State: AOAM532BgfoyfjkRMsNOM9Pz9DtpWNFHr0Ztpspj9cmv47jxr/Y/LKAN
        p+eB9uMH9fBjWY2ZA/Vo4kVN1t7iZlp2cc8QQVVm8w==
X-Google-Smtp-Source: ABdhPJwmRrrtgu0RFvV2SL4uC48edxmHQXwLDsUMFnVk1a39Rsf61wCV1LIWhaaZmRERT6egGEuA6VFV23bOMKvwWfM=
X-Received: by 2002:a05:6402:60a:: with SMTP id n10mr5096942edv.230.1611098743762;
 Tue, 19 Jan 2021 15:25:43 -0800 (PST)
MIME-Version: 1.0
References: <20210115161907.2875631-1-mathias.nyman@linux.intel.com>
 <20210115161907.2875631-2-mathias.nyman@linux.intel.com> <42c6632e-28f1-9aae-e1a6-3525bb493c58@gmail.com>
 <b70e0bb512d44f00ac5f8380ba450ba6@AcuMS.aculab.com> <f439cf12-106f-3634-397f-dc17a4d0e94d@gmail.com>
 <2722043c-208b-c965-e6cf-8474c698df2c@linux.intel.com>
In-Reply-To: <2722043c-208b-c965-e6cf-8474c698df2c@linux.intel.com>
From:   Ross Zwisler <zwisler@google.com>
Date:   Tue, 19 Jan 2021 16:25:32 -0700
Message-ID: <CAGRrVHxvhUyc=z1W13QUJJ8pJgscTJSLGgjV=1OmOKi0F16uqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] xhci: make sure TRB is fully written before giving it
 to the controller
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 5:05 AM Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
<>
> True, good point, dma_wmb() should be enough here.
> In fact most other wmb()s in xhci could be turned into dma_wmb().

FWIW I've confirmed in my testing that dma_wmb() does indeed also
solve the problem.
