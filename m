Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F273B95F4
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 20:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhGASLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 14:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbhGASLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 14:11:55 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF80C061762
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 11:09:24 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id w5so3405073qvu.10
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 11:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R138qpb5V9GltpoHl9JfVzIFIBjpIQq4f7DuRdEpxfk=;
        b=UwTe7TNS+a++bNDyVEugeP17Qo36wJmTqNxmkt85UpPo+fx3IHQxylras006MHg/pX
         B4E/VaOBVCffLhCEyBpUQKPlHcn5f6KvGJkj0eihLH43RwyPcgLn9++z6lLltQVZ02Qd
         MlMSUcxazien7cv9pkNG4xZ6T1ARR5pr/b8ob06qREN59+WdyCgffcpWKcb1OJGnc0a/
         kfFAcAW4Ijw8TiONTjCwzfwAsNEnkLTxJGRCWi9UjfInxxhmkXhNc20MN5XA1+fMjdRR
         7ScatupMe70tOXujl2JePKNJjaCD2ffBp6UR74RPFb0ukP+dI7XTq1EZiNatfTgJqpfQ
         xBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R138qpb5V9GltpoHl9JfVzIFIBjpIQq4f7DuRdEpxfk=;
        b=hQT/m/4B2tqvdyMUWCY52n5jHEMElUQYV1R3wqhJ3m3NMqBkfc/nZDntiUTF106XZT
         MzuJO1JbPq3U96LKv7K05xbmqMqeoVmBtKDZwEe08olqkKhpmA2UoqbAVdGgiPcE47VP
         ko1g7Goea0COuVs+FtxKtJ2xJFmSvpx1HiZTFhRl7+cAJeybSGP1l0fVTaV44HDk45IU
         7pUk9N+5/9G5uHTZySWiCbTO7k6zyAQ/7VLfqyaQHHPOTkTnBkNbKXMt2Ai2eSQ4ou0S
         hG6FL/gMifGWxNLsIXZaGxpgqKxBN3Ja+isP+CDLC5+Qd/kteEr/ilWfR2i/DjlFzLuD
         8t4A==
X-Gm-Message-State: AOAM531gnIO0yt9n0LuUJEHyxmsnkskYaqzOSh4K/mF+KPSFTOTu5/BB
        u5OVJ6FpxbMUZIUYjgoq2v1xGi6IKYPCIJkoKPVBlg==
X-Google-Smtp-Source: ABdhPJyTJ2YT0EAPjvKbr/rujHX4DyzUM0IJbNxV+R0cyZT0MqNNxUEd1y8SxlqtpqBObK8ggzPxh3jPMm2rAP/4Gy4=
X-Received: by 2002:a0c:ed46:: with SMTP id v6mr1123035qvq.35.1625162963332;
 Thu, 01 Jul 2021 11:09:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210630003406.4013668-1-paulburton@google.com>
 <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com>
 <YN38D3dg0fLzL0Ia@google.com> <20210701140754.5847a50f@oasis.local.home>
In-Reply-To: <20210701140754.5847a50f@oasis.local.home>
From:   Joel Fernandes <joelaf@google.com>
Date:   Thu, 1 Jul 2021 14:09:12 -0400
Message-ID: <CAJWu+optxZYJ=RdmconCGMHQRgJqv=0k6NKAzEWui1smXieToA@mail.gmail.com>
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Paul Burton <paulburton@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 1, 2021 at 2:07 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 1 Jul 2021 10:31:59 -0700
> Paul Burton <paulburton@google.com> wrote:
>
> > I was tempted to just add the redundant checks anyway (pick your battles
> > and all) but for show() in particular it wound up making things seem
> > non-sensical to me ("display the value describing this non-NULL pointer
> > into tgid_map only if tgid_map is not NULL?").
>
> I agree with your assessment, and will actually take your first patch,
> as I don't think the comment is that helpful, not to mention, we don't
> use '//' comments in the kernel, so that would have to be changed.
>
> But for cases like this, I usually have something like:
>
>
>         if (WARN_ON_ONCE(!tgid_map))
>                 return -1;
>
> Because the logic is what makes tgid_map not being NULL, but as
> experience has taught me, the logic can sometimes be mistaken, at least
> as time goes by. And things that are protected by logic, deserve a
> WARN*() when it doesn't go as planned.
>
> We can always add that later, if needed.

Agreed, was thinking similar/same.

thanks,

-Joel
