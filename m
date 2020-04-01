Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F92519B74E
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 22:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732809AbgDAUzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 16:55:32 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44466 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbgDAUzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 16:55:32 -0400
Received: by mail-lf1-f67.google.com with SMTP id 131so863183lfh.11
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 13:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yuHnHVGl5Hl/LCLky/lKRjfVSplQ/H5ogoCU1HMx1e8=;
        b=WWbKUEBx25usiEQ2sOtMr/aJGGNl/SWad/qB+6BBXRmLdbbOPDw+0Em7vvCLC8KHwE
         L0cmqvLGhMWA3DKwcIP/ALfr/FFFkSk9t8gs4fHWuRB/MEmppOKWwLyW0SIfro25/I7O
         JCyragl/0Fvlx0Ib8Kr7EkEmR2XWHQ4+fVTn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yuHnHVGl5Hl/LCLky/lKRjfVSplQ/H5ogoCU1HMx1e8=;
        b=G1jriZj9KSx/+WyzJMpaWu0DTpi8vnBtD+3FpMc7uGUhgIom2l+11iIOg9fZ8RD0mD
         /1mMQ5VvWX2dOl668ARXb+msJsIgDHqDNbuYDhvAtsGXrYKQ6lBet/mw6XQIhYDalWag
         LiLInkZznf10oO2BmVM//w6sxlmIHHslU66P1Ss30xkpWaEPx+lsSZjdkY8Q40XTE7HU
         JaY18HkcK5QSyNgZ6urCWH/hvQmjiymTkWR8F/YG87yUm2h1GeQBON5COJLZ6/BDNxfn
         n1/ONHvc4w6IVh16Q0mZmX0fPxli4/b38J3bD+bMg5sR1AtL8xlGF5Npv+mNDkiyjoM9
         TA6A==
X-Gm-Message-State: AGi0PuY7HiYYk4PVLRDkeyi0NZ9g2kjKJmWCm2PODHkJ0kutvctnrRUq
        8Bv7wAMmXl6JsNgudlJ3vtVHHnZ8wgY=
X-Google-Smtp-Source: APiQypIu7onyUotHpeOKnyll4z954EHnJULlxpswHeXzGAGHzPDYbyvlIQ35DK4LI9VPsb8YlxZhXQ==
X-Received: by 2002:ac2:4307:: with SMTP id l7mr38733lfh.37.1585774529179;
        Wed, 01 Apr 2020 13:55:29 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id u7sm2380376lfb.84.2020.04.01.13.55.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 13:55:28 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id q19so927492ljp.9
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 13:55:28 -0700 (PDT)
X-Received: by 2002:a2e:8652:: with SMTP id i18mr62644ljj.265.1585774527625;
 Wed, 01 Apr 2020 13:55:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook> <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Apr 2020 13:55:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wihrtjjSsF6mGc7wjrtVQ-pha9ZAeo1rQAeuO1hr+i1qw@mail.gmail.com>
Message-ID: <CAHk-=wihrtjjSsF6mGc7wjrtVQ-pha9ZAeo1rQAeuO1hr+i1qw@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Adam Zabrocki <pi3@pi3.com.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 1, 2020 at 1:50 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> I have updated the update of exec_id on exec to use WRITE_ONCE
> and the read of exec_id in do_notify_parent to use READ_ONCE
> to make it clear that there is no locking between these two
> locations.

Ack, makes sense to me.

Just put it in your branch, this doesn't look urgent, considering that
it's something that has been around forever.

            Linus
