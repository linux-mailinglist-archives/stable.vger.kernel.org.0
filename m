Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD82F14009C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 01:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgAQAMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 19:12:45 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46064 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgAQAMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 19:12:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so20959537wrj.12;
        Thu, 16 Jan 2020 16:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sW9GJJtS3r0rfOsE2akR9nsq8uqRMddnQuBnai/zpRI=;
        b=PQHzcFEwi5iLVrwpmxazY2ThTMGpLLwC4m7PDRdFQtZGFhCba1u9oC1PIa67JWhHul
         pLJyFZcXKRpiZXUyU1RHMJPg7TUAgVVfSmomJ0qfGu03Z0OLfSEaYtLMzUP9F9cpFWsn
         Y6cv3w9fWX3BPig4xuGPaBb0r37gd862zYucDfWVRE4pRwaxo2wDAQ6HPWzLJQre862v
         q7dX6iLP/ksN0K8TRtqXz97pFcB3QfEqZ7CyWGUqVHPeWPUDlEL1pSbKwSUbs3TJBo05
         GSGw8PSFfmiJ4G8VHcEPHqu+RrqohRi+f8DQ1tsSvIQdQCZhtQiID2lZdkHIYf1v/L4m
         2juA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sW9GJJtS3r0rfOsE2akR9nsq8uqRMddnQuBnai/zpRI=;
        b=E1yjgxrwdcV7cXL/PpT2qBoQhaqW1f9O4srh93hPD7dkNdJMu93qQ+0pKPN7X5pcZm
         y9yEbeCxQcNhgM6ScBaS+y5KKDFMOO3R94Ldgs3puNl7En76C7LpXMrSH+Ku+dqjKPqB
         jeSC52S335zaOAvx4+f/RSI0DpwJjZ7J8jlJxPWZzsHwxAomaxz/uE+tkOiYegv+rjdy
         9fJxE1tR1sTSjfah01ZWj7XowiOsPpV/ibHwI9V8/mykp/+jaPUyZyXf42OT+PB5S245
         4cBzWoihC81C6NlGQp3OEhTUM55+AguvTLoY74p0vndZ56q9+uvT/UkE1xCbcvF/42TA
         /wWA==
X-Gm-Message-State: APjAAAVP6fyQh0LU8uzke/0yYNOGN12h1jbSm1FCjFoti/TbxCQyrjMy
        A5lMeTMKVLwfAFTiz3UuEByr26+WFUKGXuxxjak++azr
X-Google-Smtp-Source: APXvYqwUVxhK4jEa+K7rSVVi3aq0FsMfm+MgOSUONxJBcrdtupdYV50S839f2RHgMLFxGa1B6+kmgdGwSk5kg+DvQnw=
X-Received: by 2002:a5d:494b:: with SMTP id r11mr35538wrs.184.1579219962503;
 Thu, 16 Jan 2020 16:12:42 -0800 (PST)
MIME-Version: 1.0
References: <20200102172413.654385-1-amanieu@gmail.com> <20200104123928.1048822-1-amanieu@gmail.com>
 <20200105151928.qrmhnwer3r5ffc77@wittgenstein> <20200107123548.5fzu4v6czrlhrhmh@wittgenstein>
In-Reply-To: <20200107123548.5fzu4v6czrlhrhmh@wittgenstein>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Fri, 17 Jan 2020 01:12:31 +0100
Message-ID: <CAFLxGvzG4DJH5a7cAV6U+wPBqHUOJ6XQmy-u2ibawM3jsQXQBw@mail.gmail.com>
Subject: Re: [PATCH] um: Implement copy_thread_tls
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "Amanieu d'Antras" <amanieu@gmail.com>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        stable <stable@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 7, 2020 at 1:36 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Sun, Jan 05, 2020 at 04:19:28PM +0100, Christian Brauner wrote:
> > On Sat, Jan 04, 2020 at 01:39:30PM +0100, Amanieu d'Antras wrote:
> > > This is required for clone3 which passes the TLS value through a
> > > struct rather than a register.
> > >
> > > Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> > > Cc: linux-um@lists.infradead.org
> > > Cc: <stable@vger.kernel.org> # 5.3.x
> >
> > Thanks. I'm picking this up as part of the copy_thread_tls() series.
> > (Leaving the patch in tact so people can Ack right here if they want to.)
> > If I could get an Ack from one of the maintainers that would be great;
> > see
> > https://lore.kernel.org/lkml/20200102172413.654385-1-amanieu@gmail.com
> > for more context.
> >
> > Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
>
> I've this up as part of the series link in above ^^ and moved it into
> https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=clone3_tls
>
> If I hear no objections I'll merge into into my fixes tree today or
> tomorrow.
>
> An Ack from one of the maintainers would still be appreciated.

For sure too late, but better than nothing? ;-)

Acked-by: Richard Weinberger <richard@nod.at>

-- 
Thanks,
//richard
