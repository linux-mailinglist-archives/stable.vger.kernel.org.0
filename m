Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E8B21B78
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 18:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbfEQQT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 12:19:56 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35586 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbfEQQTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 12:19:55 -0400
Received: by mail-qt1-f193.google.com with SMTP id a39so8668889qtk.2
        for <stable@vger.kernel.org>; Fri, 17 May 2019 09:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gpiccoli-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQo9aBA95rp8OAvg+gFs24bz5ulMaCtimiFeAwP39GY=;
        b=EHpxwm3dHMfgR9agTnYXj6RWczAL0Tpdb+aDv35ZkbwI+JsZU8qVdWqK/TyHPVIbXA
         HYx5hUSSE3lhycSfKYN4fykntbOk+gCRvDtmboYN9bGghhCWMKW+BkPYJ4bv2FV8HrMU
         htxE4WfbdSwsT9WZQsjGcGSVr61CyxTRzQmTULtg8QkerJpzR8DsNe3Rm4DnvnZR5heC
         pvPsPiB6mwMOhbvQleHPXpbtLoe7jfr/9+FYFQewlY+bIuJqRbWq7/wPmhkEeHxurppM
         Q5n1gMcXf4WRsN3pyuPCgoWYJZ6o+EfDyh1jKfzFf4N3H1ntfv1S7WIKhYkl0eiwsVzY
         ENIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQo9aBA95rp8OAvg+gFs24bz5ulMaCtimiFeAwP39GY=;
        b=dzVx+WrKouihKgxTMPAL/C9tHAc5uAZHWZtmrXkZOE9l8vykqflVvRXrgduwWZ0q/j
         vphpg2WM6wLpjbNBgOqk2SkbsTEAyk3c14whOtznNVP8jPzbeQFx22l9wD0FECH2vEcA
         ciAc4Ei6UPn8HI4No/IY9xiei2CX13dcziWU5R//aH/zCXjQ0pnSFLGL5KmjISArn6dB
         hPWJrKPAhJIzWHtUFvtTPM6ND3lEpQ6Xlav0JPTFRnvqEnjg7DUJzip5IlRJ9U7GlEtu
         syEpAdmJwYXzIUzjUjkRX4gYg/O7gkMoymUuqEv8JOhCt52uLOxU2yRHzQrq3smNb4Vk
         2W1w==
X-Gm-Message-State: APjAAAXZS9LDKPWIS1c4wD/pDr2bAMBlG7dD9oL4kreDJ+xfuHJx2A6T
        7krDS/S9GftjVx7gcR2gyPMEHtATz/Wi3dQHrm+NUA==
X-Google-Smtp-Source: APXvYqzuMhcd/NW5WXkxDeszD4UNp2tVLZCrFZ1IXTfTd9VNsVKaISjWgeA88f5yiB7P8wqxG6PKWsPDuCucTzpWuzg=
X-Received: by 2002:ac8:1b0a:: with SMTP id y10mr46256762qtj.91.1558109995068;
 Fri, 17 May 2019 09:19:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com> <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com> <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
 <5CD2A172.4010302@youngman.org.uk> <0ad36b2f-ec36-6930-b587-da0526613567@gpiccoli.net>
 <5CD3096B.4030302@youngman.org.uk>
In-Reply-To: <5CD3096B.4030302@youngman.org.uk>
From:   "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Date:   Fri, 17 May 2019 13:19:18 -0300
Message-ID: <CALJn8nOTCcOtFJ1SzZAuJxNuxzf2Tq7Yw34h1E5XE-mbn5CUbg@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     Wols Lists <antlists@youngman.org.uk>,
        Song Liu <liu.song.a23@gmail.com>, axboe@kernel.dk
Cc:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Ming Lei <ming.lei@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jens / Song, any news in this one?

I think would be good to have this raid0 fix rather sooner than later
if possible - it's easy
to reproduce the crash.

Thanks,


Guilherme
