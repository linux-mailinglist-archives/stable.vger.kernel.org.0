Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42E8C2944
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 00:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfI3WEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 18:04:16 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34562 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbfI3WEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 18:04:15 -0400
Received: by mail-qk1-f196.google.com with SMTP id q203so9319064qke.1
        for <stable@vger.kernel.org>; Mon, 30 Sep 2019 15:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9iin0gJR528W5g0jWTS9HSd8at8s87+NF0eywiHCFfo=;
        b=YqPXUgon+HjVegYUs9truqIxP4OeBTdmRhRxsSn9QnGAfLr0bvy1k6JM88cp/ixcRi
         cDAJxitl7M3YcsWmB1HP3zw1iYgVrzMwMNHtNf3C0z6r8y6NBo5yRMRfBhYPIw0Cdn3e
         tSOp25EZ6ri99ORX0O6oWGGiPl2mVRCXn0grE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9iin0gJR528W5g0jWTS9HSd8at8s87+NF0eywiHCFfo=;
        b=OOPCSvT+ykUaJBn0mCLv+M0HAZRl+LQSVbeM8iF17BvRriQFDCHmtN9b3X6wBReLce
         Z8M4bAa21DtJSIFFfPjN3CGRqbTaEGJmEBLbZ24Dm1cQXU1Ohyz5THfcTt9PC41OTDug
         pAzqOokkGG+HcbQSNQsmH0CYN4+lvNC+P3gVfmGx6qubOvkpGHI5cNU/ZsnZp9ZXsPkJ
         4AenimJKHgMeA8UE5ipl39PHE/anfTTAyWuUmhAnyYIAtdSedgkyb2Gs6RUxNgrTzObR
         XVhkYWHV3/CxEjV24PhPitk2dAoxM4wZR2s9rADRakRTvvOWTAwAMIG/lzJuLypH5nb2
         Li6g==
X-Gm-Message-State: APjAAAXgJGCzSQ2aSMogliGBc4BFsOwCxpLWB5Eq2utJQwIvaWeUbBTG
        /yQ8L6cEh8LioDHD5fBfJynlBpy9MPU=
X-Google-Smtp-Source: APXvYqzKKkkotrd0tw2o5YRE0LDLgpnRjDZDWhEBTjcD75KPuGZk/EtxlPsF+7Knw2kM9LfN5PSRXg==
X-Received: by 2002:a37:883:: with SMTP id 125mr2584927qki.478.1569881053483;
        Mon, 30 Sep 2019 15:04:13 -0700 (PDT)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com. [209.85.160.180])
        by smtp.gmail.com with ESMTPSA id q49sm10851497qta.60.2019.09.30.15.04.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 15:04:12 -0700 (PDT)
Received: by mail-qt1-f180.google.com with SMTP id o12so19088746qtf.3
        for <stable@vger.kernel.org>; Mon, 30 Sep 2019 15:04:12 -0700 (PDT)
X-Received: by 2002:ac8:f1c:: with SMTP id e28mr27107637qtk.161.1569881051791;
 Mon, 30 Sep 2019 15:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190930214522.240680-1-briannorris@chromium.org>
In-Reply-To: <20190930214522.240680-1-briannorris@chromium.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 30 Sep 2019 15:04:00 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOkLKqs_Uo4vdHre6JWCsjucgntDEF7T=_eXt2a-A-voA@mail.gmail.com>
Message-ID: <CA+ASDXOkLKqs_Uo4vdHre6JWCsjucgntDEF7T=_eXt2a-A-voA@mail.gmail.com>
Subject: Re: [PATCH] firmware: google: increment VPD key_len properly
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hung-Te Lin <hungte@chromium.org>,
        stable <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 2:45 PM Brian Norris <briannorris@chromium.org> wrote:
> Fixes: 4b708b7b1a2c ("firmware: google: check if size is valid when decoding VPD data")
> Cc: <stable@vger.kernel.org>

Perhaps I should have modified the subject to note the urgency (e.g.,
[PATCH 5.4]). The above regression was recently shipped to v4.14.146
and v4.19.75.

Brian
