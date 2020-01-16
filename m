Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF8513DB1E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 14:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgAPNHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 08:07:05 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39062 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgAPNHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 08:07:05 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so21624072ioh.6;
        Thu, 16 Jan 2020 05:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q7w3Z5zhPTl+MR4lc0eaFPoPD5VGPMbv1ThobG/2rJA=;
        b=R6irsvylaAmcRarBifg51aVsBug2CzMDmQYFxn2wmIfJzPQk3AHG3U6T2d9uI+1En5
         YlL4vBS9TH96uSkgf0QWuYG1D6uapC57qS431r1owCyaawwTXxSRmZfxC/qu2z6z9eWi
         4+jAm9FqU9INieHvOnczQfzKYp3jRkllIrRaV+9pTXEMXkugygKDEg4zSg6gGK1cWgUg
         nFdGUf5aTrIamcQRRgkY+l4IvpRcIYM2wItvlmRwUsZpjvdl/Bvjmzzg4nPm7xHKMJ2A
         8MP9vzRm9adcD9G6cYVuB9r1UqHZfr8DVW5rret9w7Fr82IQlec50Di+/MJHTG+JeCMQ
         pAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q7w3Z5zhPTl+MR4lc0eaFPoPD5VGPMbv1ThobG/2rJA=;
        b=TlvzvC4nBg4AxGBZP85Q0Tq6BMJcJQ8Zk5QWSHO3iYSBE1dogdxm7KLBLYBzVvGzKc
         4OzgtNVeZIzvW+aedo+He0vBGYXBvkliFujyCQigcCmfMGeh7SHGH+0m2KsgzxwTOZoj
         vxp0cgUeN+aaGx44Y7LKQROk8drAV4YhgibtCib62cW8kvjVwOFSpk6zW9ffcmiJc494
         3DdQECJBf1GyRjmJ0zTuzaFuxalvj4YBCev03ZeLeZnCyowNYaqg9gzM7V31315JBJtX
         LBrJCrK/zbcgOBpNskw45f0WP0Fc7duRqkIUMK/3LXdZtF5umJKnLZ1tO3yJEiSD7YBg
         ry9g==
X-Gm-Message-State: APjAAAVUDbLbgRmib91XN7qrDlzr0+O+3CXnZ/EXhuQFAqTEvkUSQZzW
        y55en9aCy+bCEApTV5omKl3t2fGGDPzBGuES9wc=
X-Google-Smtp-Source: APXvYqxCf/BbBEvuekae9GypmpFkf0hOIUvRZ0aZFaj0Aq/R3jZpSRw/HzEA4qYXFwOQ1slQLQk6wmhPapqil/cpFF4=
X-Received: by 2002:a5e:cb47:: with SMTP id h7mr24937162iok.33.1579180024240;
 Thu, 16 Jan 2020 05:07:04 -0800 (PST)
MIME-Version: 1.0
References: <20200116094707.3846565-1-masami256@gmail.com> <20200116100925.GA157179@kroah.com>
In-Reply-To: <20200116100925.GA157179@kroah.com>
From:   Masami Ichikawa <masami256@gmail.com>
Date:   Thu, 16 Jan 2020 22:06:53 +0900
Message-ID: <CACOXgS-0MXkbUQd9vAaXraW2cfc7A10HhoGfcMKy0irrrezmCA@mail.gmail.com>
Subject: Re: [PATCH] tracing: Do not set trace clock if tracefs lockdown is in effect
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     rostedt@goodmis.org, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 7:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jan 16, 2020 at 06:47:06PM +0900, Masami Ichikawa wrote:
> > When trace_clock option is not set and unstable clcok detected,
> > tracing_set_default_clock() sets trace_clock(ThinkPad A285 is one of
> > case). In that case, if lockdown is in effect, null pointer
> > dereference error happens in ring_buffer_set_clock().
> >
> > Link: https://bugzilla.redhat.com/show_bug.cgi?id=1788488
> > Signed-off-by: Masami Ichikawa <masami256@gmail.com>
> > ---
> >  kernel/trace/trace.c | 5 +++++
> >  1 file changed, 5 insertions(+)
>
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>

Sorry, I'll resend patch without stable mailing list.


-- 
Masami Ichikawa
