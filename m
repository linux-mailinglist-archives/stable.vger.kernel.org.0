Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C461C2937
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 02:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgECAaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 20:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgECAaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 20:30:11 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53357C061A0C
        for <stable@vger.kernel.org>; Sat,  2 May 2020 17:30:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so4292303wmk.5
        for <stable@vger.kernel.org>; Sat, 02 May 2020 17:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V2nT+jmzW6uK6j6RNvaRunaFhSFW7qRx5cWISy3xtsQ=;
        b=E1AEkHox21046/Jzv0H2sg0BIzJvXI5WKdhrIfyzhtFbc0BBr2Jbbo4W/cz61zuCWi
         N7wfdgGQbbeddGO74JguUI2EXq4+V2iEf/49y27rGKNWMBfesVlzBgPOzVPeBAWsDjVi
         MwfyIgQ4sj5GybFYWk26pinWgUjQkfCWZ6xmmDA/YANZdJExvY+1eHRU0qsu08dgxRg4
         yba0Fz8wK4DVM4JNI9vneWIr8MwO1iTNEI1j2c8OtrlAD2zgZyVuN0UPndhOvADA09K0
         oGD9E7oaU2Xm77LaL1nDwVx5b0TQ2W5oTxfvUMvijPlQLM0HQwCdOkQFHHjX+VELIOiy
         0BvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V2nT+jmzW6uK6j6RNvaRunaFhSFW7qRx5cWISy3xtsQ=;
        b=ImRvN/LQzCZMcOtU6jQ0ZjZnp+T1ncDLJmCChxoxrzmkZDofERhVGbSLw7BSiIskti
         o4UFiYQo9yFSH98Lzyr8OM2gUiWxIMAIBYndY8H3dSiDBJrEX5v5IFmX81Roq7avg3Pi
         mZQNWjpIf4Vil/jQjdhYtE4KcGNsDTKOWGykM1tgW/I12vW7vnUQ02wi8YwL85AR/AaY
         4OXaNn/GiJmuMD5B4hTmbS6Bf0TFi41nCJt/jr588j07F/A9V+MJFojvGi9azPY40/hV
         7xE15PFJfoqkMtvcO7e5WQ5Wzn1RCaQFsWo+mH1aeeAQcxrEk/3Os0CZQe3Q7EnJKTt5
         ExsA==
X-Gm-Message-State: AGi0Pubefhi2NTfahylAWP5hd3xtzpsV4JU/rPiaf/+gMTa3+foBOguJ
        Bfb8XHSmQufm7iIIQAIOXvMDcQ6LDgM/uRpr3eKV5Ntp
X-Google-Smtp-Source: APiQypK033BSVa5j3+ZhThYcEUFkwS26U4I4SJPdSG0fksA6GljM8v6NbCEY+NCeISjVSggtF2WxUBXyAZEAOTUxbUM=
X-Received: by 2002:a1c:4186:: with SMTP id o128mr6735406wma.21.1588465809902;
 Sat, 02 May 2020 17:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
 <1962EE67-8AD1-409D-963A-4F1E1AB3B865@amacapital.net> <3908561D78D1C84285E8C5FCA982C28F7F60EBB6@ORSMSX115.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7F60EBB6@ORSMSX115.amr.corp.intel.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Sat, 2 May 2020 17:29:57 -0700
Message-ID: <CALCETrW5zNLOrhOS69xeb3ANa0HVAW5+xaHvG2CA8iFy1ByHKQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Tsaur, Erwin" <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 1, 2020 at 7:09 AM Luck, Tony <tony.luck@intel.com> wrote:
>
> > Now maybe copy_to_user() should *always* work this way, but I=E2=80=99m=
 not convinced.
> > Certainly put_user() shouldn=E2=80=99t =E2=80=94 the result wouldn=E2=
=80=99t even be well defined. And I=E2=80=99m
> >  unconvinced that it makes much sense for the majority of copy_to_user(=
) callers
> >  that are also directly accessing the source structure.
>
> One case that might work is copy_to_user() that's copying from the kernel=
 page cache
> to the user in response to a read(2) system call.  Action would be to che=
ck if we could
> re-read from the file system to a different page. If not, return -EIO. Ei=
ther way ditch the
> poison page from the page cache.
>

I think that, before we do too much design of the semantics of just
the copy function, we need a design for the whole system.
Specifically:

When the kernel finds out that a kernel page is bad (via #MC or via
any other mechanism), what does the kernel do?  Does it unmap it?
Does it replace it with a dummy page?  Does it leave it there?

When a copy function hits a bad page and the page is not yet known to
be bad, what does it do?  (I.e. the page was believed to be fine but
the copy function gets #MC.)  Does it unmap it right away?  What does
it return?

When a copy function hits a page that is already known to be bad
because the kernel got the "oh crap, bad page" notification earlier,
what does it do?  Return -EIO?  Take some fancier action under the
assumption that it's called in a preemptible, IRQs-on context, whereas
the original #MC or other hardware notification may have come at a
less opportune time?
