Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5735949D2EE
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 20:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiAZT6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 14:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiAZT6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 14:58:40 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEFAC06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 11:58:40 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d18so573466plg.2
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 11:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=epiW7EOJDtCxAnePBLYcB/dsG4ABauHMGQc+aHTZ3nU=;
        b=YP4Atk8A6QOHE6yKgxHwvv98aqnpitZZJ04nawZm/fg1pufFSNHMRiSou+FwIASga2
         mhqGC0T6cDKKo0TKVksBquQg2k4k1a0Jd9Y/z8ZJrfDQoZBA5TE0Nx5TNlEhDMlLLd7o
         QApbenrmidG6D6VtYMw0VJ+32+MD0iBsapx/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=epiW7EOJDtCxAnePBLYcB/dsG4ABauHMGQc+aHTZ3nU=;
        b=ET/kDgm9YCyKWs4WBwb88ECq0eEG8QylO2PoqBeYow0wkzdsArfs258/R/ds7eiFSG
         hIqgZfVI16YdHUUiXOnyzTqeKZEpm23ZYUI7NC/HyhCyHjde0O3Y5MHRCJECyJUHcLsO
         kHT+7G+FEKHSisdfXphvMPMjfPp9RcwFB0pFQQZiPNFU7CvZgu74nL8QaFMFs8JDvWl8
         f5paPcRZ2tP+pvyUOYOhCk3V/yNClpo76z1StFWJCqAKEYEbWT3L6Zfc6BhhB0L4LPxX
         1GW2jz0BkK3t4lx6cf8jpJC1hMZhDFWx4L7iGVpizVp10ed5n/yO61dCMtBoNETMBws5
         R7xg==
X-Gm-Message-State: AOAM531h+tBWKIXi+sk2RH9i0eE0+142IK8ANM//ds37DX+7AlRTuKeo
        iA2lbX25sG1Ap1g3gB9avtRizQ==
X-Google-Smtp-Source: ABdhPJzOGPebWPhaQa0apJ6b7tVgV8+Ymfm8RN1iwAGvb9pUIsBUswXMnGAejBH+nZ8lNcJQGR6Jhg==
X-Received: by 2002:a17:903:1109:: with SMTP id n9mr158953plh.163.1643227119920;
        Wed, 26 Jan 2022 11:58:39 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n4sm5682138pjf.0.2022.01.26.11.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 11:58:39 -0800 (PST)
Date:   Wed, 26 Jan 2022 11:58:39 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jann Horn <jannh@google.com>
Cc:     Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] fs/binfmt_elf: Add padding NULL when argc == 0
Message-ID: <202201261157.9C3D3C36@keescook>
References: <20220126175747.3270945-1-keescook@chromium.org>
 <CAG48ez3hN8+zNCmLVP0yU0A5op6BAS+A-rs05aiLm4RQvzzBpg@mail.gmail.com>
 <a89bb47f-677f-4ce7-fd-d3893fe0abbd@dereferenced.org>
 <CAG48ez3iEUDbM03axYSjWOSW+zt-khgzf8CfX1DHmf_6QZap6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3iEUDbM03axYSjWOSW+zt-khgzf8CfX1DHmf_6QZap6Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 08:50:39PM +0100, Jann Horn wrote:
> On Wed, Jan 26, 2022 at 7:42 PM Ariadne Conill <ariadne@dereferenced.org> wrote:
> > On Wed, 26 Jan 2022, Jann Horn wrote:
> > > On Wed, Jan 26, 2022 at 6:58 PM Kees Cook <keescook@chromium.org> wrote:
> > >> Quoting Ariadne Conill:
> > >>
> > >> "In several other operating systems, it is a hard requirement that the
> > >> first argument to execve(2) be the name of a program, thus prohibiting
> > >> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
> > >> but it is not an explicit requirement[1]:
> > >>
> > >>     The argument arg0 should point to a filename string that is
> > >>     associated with the process being started by one of the exec
> > >>     functions.
> > >> ...
> > >> Interestingly, Michael Kerrisk opened an issue about this in 2008[2],
> > >> but there was no consensus to support fixing this issue then.
> > >> Hopefully now that CVE-2021-4034 shows practical exploitative use[3]
> > >> of this bug in a shellcode, we can reconsider."
> > >>
> > >> An examination of existing[4] users of execve(..., NULL, NULL) shows
> > >> mostly test code, or example rootkit code. While rejecting a NULL argv
> > >> would be preferred, it looks like the main cause of userspace confusion
> > >> is an assumption that argc >= 1, and buggy programs may skip argv[0]
> > >> when iterating. To protect against userspace bugs of this nature, insert
> > >> an extra NULL pointer in argv when argc == 0, so that argv[1] != envp[0].
> > >>
> > >> Note that this is only done in the argc == 0 case because some userspace
> > >> programs expect to find envp at exactly argv[argc]. The overlap of these
> > >> two misguided assumptions is believed to be zero.
> > >
> > > Will this result in the executed program being told that argc==0 but
> > > having an extra NULL pointer on the stack?
> > > If so, I believe this breaks the x86-64 ABI documented at
> > > https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf - page 29,
> > > figure 3.9 describes the layout of the initial process stack.
> >
> > I'm presently compiling a kernel with the patch to see if it works or not.
> >
> > > Actually, does this even work? Can a program still properly access its
> > > environment variables when invoked with argc==0 with this patch
> > > applied? AFAIU the way userspace locates envv on x86-64 is by
> > > calculating 8*(argc+1)?
> >
> > In the other thread, it was suggested that perhaps we should set up an
> > argv of {"", NULL}.  In that case, it seems like it would be safe to claim
> > argc == 1.
> >
> > What do you think?
> 
> Sounds good to me, since that's something that could also happen
> normally if userspace calls execve(..., {"", NULL}, ...).
> 
> (I'd like it even better if we could just bail out with an error code,
> but I guess the risk of breakage might be too high with that
> approach?)

We can't mutate argc; it'll turn at least some userspace into an
infinite loop:
https://sources.debian.org/src/valgrind/1:3.18.1-1/none/tests/execve.c/?hl=22#L22

-- 
Kees Cook
