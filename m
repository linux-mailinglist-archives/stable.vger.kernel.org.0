Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28B91ED39E
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 17:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgFCPnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 11:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgFCPnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 11:43:22 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB953C08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 08:43:22 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a13so2964600ilh.3
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 08:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=juliacomputing-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XQbYzBqHd6jJYDLCXZzMSLx/VOPPQ+/JM52BSm06Khw=;
        b=kR24IwKs6C5MsSrcmrJi23tYiZsApz6W4JuZntvUW+Z72bCRQGi9OXJxq6GkXQcqMo
         K0yBHD6VrsKzeJwm/OHRwDKK3y0tc0PYhWdM4gL5OuRa35rrEsUiHaV+k9M8wSl8cI77
         QVsvWaCn4VdB6NVbpTHn0MYDTqbRtm4gR6ZRajVWU3WCKVEa6Zgt1h1oA32dxZuJfZHX
         FuGzbmTG1EwRT0kIXgBSEODZ8E4GzyBZEnzNqgKkk1FlCA5fJTCr8uCOhzFzKXGYOvnM
         kzRRIRnBTF90sJtf/Se9TJCGRqLw9AjbNLOtLW0Oz/Q6AFVgvG9+4ii0GuiPp9hQpB2e
         jELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XQbYzBqHd6jJYDLCXZzMSLx/VOPPQ+/JM52BSm06Khw=;
        b=hGyyr7cJ/Xha3FFeIkbwkSoQ0XLcGv2XMvtVI0Pm7v5cvcNZgYIvqShfiYYKGbhUuH
         j7hb1yeysjZHxq2VfVrI2qFX9+WuRGFRtdmCXTKLHopOtnUqNrzEGQuUVXzfndYw5+mS
         4DIvK2IU+C2P2eG2/urpik+q+Yeh+IIvtfs5pjgZ510fbdpKojse0ifmU3O+Xocb0n6A
         GPlN8vXQRiVoSxaUsFTwojxLtN4vCKToicDCRXeX/wQNcTidh0g28kpsTa/R/D0yoUzF
         pn1UefPaoUbbaBUJ8fzvbjbm/hYS1/wZCwb+sJRO4uXzjL9M/ahtaVgkUDQpwfydmU8f
         XAlA==
X-Gm-Message-State: AOAM532ZEUKwpVBYZWk7r0+6BodA8thTBST9J1rP/4fR5FA1nxVlu9SD
        C6cJs6zfAHN43TNxKfjXMMt/oLn/BSgZD6iOURuwwA==
X-Google-Smtp-Source: ABdhPJya98ydpzdbIHuypWDOMkgFr4jwmMtfJqaVMFUo2vtfck5eQQwpncsi30RLEiAI8s52Ru2C9dGxWf9+urZCItQ=
X-Received: by 2002:a92:d3d0:: with SMTP id c16mr116133ilh.181.1591199002077;
 Wed, 03 Jun 2020 08:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200603151033.11512-1-will@kernel.org> <20200603151033.11512-2-will@kernel.org>
In-Reply-To: <20200603151033.11512-2-will@kernel.org>
From:   Keno Fischer <keno@juliacomputing.com>
Date:   Wed, 3 Jun 2020 11:42:46 -0400
Message-ID: <CABV8kRwrnixNc074-jQhZzeucGHx9_e5FnQmBS=VuL=tFGjY-Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: Override SPSR.SS when single-stepping is enabled
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        Mark Rutland <mark.rutland@arm.com>,
        Luis Machado <luis.machado@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 3, 2020 at 11:10 AM Will Deacon <will@kernel.org> wrote:
>
> Luis reports that, when reverse debugging with GDB, single-step does not
> function as expected on arm64:
>
>   | I've noticed, under very specific conditions, that a PTRACE_SINGLESTEP
>   | request by GDB won't execute the underlying instruction. As a consequence,
>   | the PC doesn't move, but we return a SIGTRAP just like we would for a
>   | regular successful PTRACE_SINGLESTEP request.
>
> The underlying problem is that when the CPU register state is restored
> as part of a reverse step, the SPSR.SS bit is cleared and so the hardware
> single-step state can transition to the "active-pending" state, causing
> an unexpected step exception to be taken immediately if a step operation
> is attempted.

We saw this issue also and worked around it in user-space [1]. That said,
I think I'm ok with this change in the kernel, since I can't think of
a particularly useful usecase for this feature.

However, at the same time as changing this, we should probably make sure
to enable the syscall exit pseudo-singlestep trap (similar issue as the other
patch I had sent for the signal pseudo-singlestep trap), since otherwise
ptracers might get confused about the lack of singlestep trap during a
singlestep -> seccomp -> singlestep path (which would give one trap
less with this patch than before).

Keno

[1] https://github.com/mozilla/rr/blob/36aa5328a2240dc3d794c14926e0754f66ee28e0/src/Task.cc#L1352-L1362
