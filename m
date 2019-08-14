Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0488DF10
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 22:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfHNUmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 16:42:05 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41937 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfHNUmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 16:42:04 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so122394pls.8
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 13:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25bZMoN1J19HNgoNs1wqy3SUjO/HDM/a7dQTZAOSu/U=;
        b=l4F6sP+vza4dzjkvW+AeSjG1woz7wi4IF0+ep3s12ZI6H8P+du4Oedhn9MiagGfBbY
         jLhgWbDGzEgFg9NVsQ9GTmlyAEpRmHv7NHw/+jCbxrMAWc053U0yMG5vnRhswrxzG/lw
         w3dmmvAfFHbkqNwoBpa2/T5X5T3gw9cthPq1OwohuSEkREEWYfQfhoYuKt6c7/oJSHqH
         P5JBKwlfXJqekDShfb+VFgYHYaR6/hYTYBEAROmurzR92jmj4TO+5sgIYT0NiP+NIYSn
         K8r2lfJxz/1ku9t5nn1IawDwCzqx2Tm341JpuEe7j7IGcEzHH5wRCR7X5TdP+H9sKPjx
         LyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=25bZMoN1J19HNgoNs1wqy3SUjO/HDM/a7dQTZAOSu/U=;
        b=pZ4qlaLPSfwmX7g6VK13fPLOpfCy8udUwsAL7pBl9I6kRWdXsqQibEhr0LUzuSJvv7
         6HW+9dyJo+sJeXwK8KA+HS271a8BDcm0lYhxZi8zSOLmoiNv2FfR3Powy8pq18Rm5I1h
         DuJuFm/94bGWB6V4xMdozLWHqLL+0UI2PWgxICb/qc7meG2VCXZ9mSBmYBZu5uDwc0lI
         M3V7fQhty3NQ3axNEbGq0jBFfk7hhDrgheC+sDDsH16vBz9lTnjP3cKDqhRIcS23V9md
         Zpc/eNYZcakIEmffxXcT+1iz00mPMFskCY+ocmBbrq0yMyaQxboRCqzrHjqUz3+kg1kb
         CXKQ==
X-Gm-Message-State: APjAAAWC7V6R9NofoTwEPd4o4GLw8SwExMYTaH6oW8ivEYbvp7k2vmUC
        7NYuZk60roDgc4fbvfeu/jOXGSEV+wzmhQ8I2hPL5Q==
X-Google-Smtp-Source: APXvYqzGq4K1KtQWmToR03iQ5jr+htyN1i7UivjA7k2K0T3A9gSW0al7A0a2hIutOQ4oWKGZMeYs3y8/Y6DEwNGp92g=
X-Received: by 2002:a17:902:a9c3:: with SMTP id b3mr1132120plr.179.1565815323703;
 Wed, 14 Aug 2019 13:42:03 -0700 (PDT)
MIME-Version: 1.0
References: <1565721608151140@kroah.com> <20190813211930.42094-1-ndesaulniers@google.com>
 <20190814080439.GA28460@kroah.com>
In-Reply-To: <20190814080439.GA28460@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 14 Aug 2019 13:41:52 -0700
Message-ID: <CAKwvOd=th2mVRTvS6Nr-DzT2sC4oUzh=ZGoBmhdsTFFpQkTcTg@mail.gmail.com>
Subject: Re: [4.19 PATCH] x86/purgatory: Do not use __builtin_memcpy and __builtin_memset
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alistair Delva <adelva@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 1:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 13, 2019 at 02:19:30PM -0700, Nick Desaulniers wrote:
> > Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
> So the Fixes: tag does not mean this should be backported to anything
> older?  It implies this bug has been in the kernel since the 3.17
> release.

Ah yeah sorry, I should have dropped the fixes tag from the backport,
as I only cared about supporting 4.19+.

-- 
Thanks,
~Nick Desaulniers
