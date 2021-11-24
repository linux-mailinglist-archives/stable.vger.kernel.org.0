Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4D545CBCF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 19:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350345AbhKXSJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 13:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351280AbhKXSI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 13:08:57 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A70C06139A
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 10:04:42 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id t5so14480964edd.0
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 10:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o4pcYLzRiFXgODRmqJpRApo0JQqGz6PeqKc5/Q3/c2Y=;
        b=NmEPfl2wDAhDoFRA7Rl3HPVjtun+4o2+Ufli0ATYaUg3efHOQDitlgMJqmgkznje/U
         1Ta2cgQtZesQxOMsoNSHMhw6isOA09i+536PIzDrtONWqDATLj55KdAGQFUamXnvSxI9
         zLT2q2xcLkdpeVYnfNoOP6NDMvcf3lpyEqs94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o4pcYLzRiFXgODRmqJpRApo0JQqGz6PeqKc5/Q3/c2Y=;
        b=uKAHUhDH9xBST3/ht4EW9wiLs18tiFsC/DenQmLPypt55hHIRZSN14BkN9K9ziAiaS
         J1Y9Z6PRHoin4p2jBigF6lZDBaE7n/wyxJlFTcHzbHjEN8lm0u/3zSgbBnSwemNMWLg8
         J02g2dPpushpcj6U1TE5Hv1OH1Daw/9jVYDEZEuZrlAeL18TMymcS4ixMwt2ZbJbPXA4
         oQaxPaoS1rhPbxqp/mP9W0xAIYAzPnu5EyG21yUMW/bVMDpeH/B9oJIQsRVP0FqfbH0R
         FAHE4TBIgeLgbxVh2HGzVrVcl+fm36RfnmAQYK/wwiDNGx4wKmt6m79IJ1fvCVkSwkTV
         L1jg==
X-Gm-Message-State: AOAM530AYUC/aAr2IU+dfdPVaFWz4A09EV8E+Ym+wnL2rwfLzxE8mULg
        inYI5Y1V70ZiSA7n2SX2gKHxRfNNxmEmcBiJumKl+w==
X-Google-Smtp-Source: ABdhPJzpcafQIlNcLwu3OzPBZJUzh8rDyCni+prznPFIY3EHy28pXMGu4oXxA14zxwjFPMfFFBe0hn7gIEkQupjhBng=
X-Received: by 2002:a17:906:4e42:: with SMTP id g2mr22798958ejw.230.1637777078574;
 Wed, 24 Nov 2021 10:04:38 -0800 (PST)
MIME-Version: 1.0
References: <20211115165428.722074685@linuxfoundation.org> <20211115165430.669780058@linuxfoundation.org>
 <CAFxkdAqahwaN0u6u34d4CrMW7rYL=6TpWk1CcOn+uGQdEgkuTQ@mail.gmail.com>
 <CAOssrKd4gHrKNNttZZey9orZ=F+msx4Axa6Mi_XgZw-9M39h-Q@mail.gmail.com>
 <CAFxkdAqU0peBNm_SB3En99bU+o=a+05t-Bwyds0AUFb+2W=CFw@mail.gmail.com> <CAOssrKez1mnF4rWRvWgk4LJ2iDfX8xkpMKvgprFt+-ARs83=nA@mail.gmail.com>
In-Reply-To: <CAOssrKez1mnF4rWRvWgk4LJ2iDfX8xkpMKvgprFt+-ARs83=nA@mail.gmail.com>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 24 Nov 2021 12:04:26 -0600
Message-ID: <CAFxkdApnvRNRU6vZ6qxtuCW78RoLuOMqaxSv+BXj9dX5DXxQyw@mail.gmail.com>
Subject: Re: [PATCH 5.15 056/917] fuse: fix page stealing
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Frank Dinoff <fdinoff@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 3:23 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> On Wed, Nov 24, 2021 at 1:40 AM Justin Forbes <jmforbes@linuxtx.org> wrote:
> > Thanks, did a scratch build for that and dropped it in the bug. Only
> > one user has reported back, but the report was that it did not fix the
> > issue.  I have also gotten confirmation now that the issue is occuring
> > with 5.16-rc2.
>
> Okay.
>
> Morning light brings clarity to the mind.  Here's a patch that should
> definitely fix this bug, as well as the very unlikely race of the page
> being truncated from the page cache before pipe_buf_release() is
> called.
>
> Please test.

Thanks, did a scratch build. and multiple users have reported back
saying that this patch does in fact fix the issue.

Justin
