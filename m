Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71221113349
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbfLDSQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:16:19 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:36101 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731475AbfLDSNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 13:13:19 -0500
Received: by mail-io1-f65.google.com with SMTP id l17so637689ioj.3
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 10:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KbjMhMLQ8ZXCsns4nZuVxnFXeq+4FdUf6xW1nrBKHDw=;
        b=Rvfdm8IAQbF27G90nuZjBxEtcEwJxiB+bs/eGLAXjvZ3cwULZ8T/egv/YLoZKttmIj
         o1UWTzyXjGfnAMRtOhBpUqnTaJP57qFcUyVVwmBiTDAs5V6Zhw8PuczWhc03XzKEtNSZ
         8vJVYsZKIQpZn4jXmdJBTjqCcmM6WRAm+LTyZvla3DgF+BexG/WPMWfQNgP9XBWhEGRC
         SR+miCcfuOkXH+qpUZ4L3/+E0wZ2WHflhUTlS7EgoOwhWMSiNhnpwRLi7xOZKojlV4Kw
         2QzONISlvHJdT/DQE+/uFSGIvTNWqGVS/y/1LKJr/wxuCC8AU3AavkB4gcEpPngiZ5Rg
         jBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KbjMhMLQ8ZXCsns4nZuVxnFXeq+4FdUf6xW1nrBKHDw=;
        b=m+amy9Je/e9PQEKKGWMPXJ7v8uFOS/dFNCeYbKT6W3XD6Nznxcaz8mIL4SrTM91cbZ
         QAoGw55lxDJuoY60ERudXlVNqHxWgN2I9hZpY01dLdMZZ6mvE/wCPcMaF8gAk0u6iXDZ
         DSlK3gNvlQE2OSusUJSj4DEZTDtYYFiLzZxphT4wlgxlaBRjTGSHVWB2dum+wI/RXOA5
         GpsxayAq0xPA2qpQmEwX0no060t9mPe/hgHmQKf/32EZjmpUlAnsLgF3jKoyrQFw737C
         rEkNXw8uFsv4YVlmJmPK0uBaXFXYH6cE0o9Sxnja3L07B+CRJOYthzkwfWBG/lJBAsXu
         /R/w==
X-Gm-Message-State: APjAAAUHnwEChxQuW3c/vIwD5C63DaIYH8RnpOYkPDN0l9mmMOdBtVf3
        Z/WDlV6xrV/rCoesA6L7VXsod481G31jGsqTOKdKhg==
X-Google-Smtp-Source: APXvYqxckBA87s67w7YakD4b8GgZOryNfAxTyy+qPNdE82bEdoxtjPjZlJ/tt5IIpRik/K/Mqv7mj95v0hKcPAjDjZo=
X-Received: by 2002:a02:3309:: with SMTP id c9mr4378013jae.52.1575483198285;
 Wed, 04 Dec 2019 10:13:18 -0800 (PST)
MIME-Version: 1.0
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
 <20191128165002.6234-7-mathieu.poirier@linaro.org> <20191203194330.GA2847072@kroah.com>
In-Reply-To: <20191203194330.GA2847072@kroah.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Wed, 4 Dec 2019 11:13:05 -0700
Message-ID: <CANLsYkyBBp_bAjsEuS=ZDY=Qza67PrwyWJUaDdBHTe1ZM1=2jw@mail.gmail.com>
Subject: Re: [stable 4.19][PATCH 06/17] remoteproc: fix rproc_da_to_va in case
 of unallocated carveout
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "# 4 . 7" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Dec 2019 at 12:43, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 28, 2019 at 09:49:51AM -0700, Mathieu Poirier wrote:
> > From: Loic Pallardy <loic.pallardy@st.com>
> >
> > commit 74457c40f97a98142bb13153395d304ad3c85cdd upstream
> >
> > With introduction of rproc_alloc_registered_carveouts() which
> > delays carveout allocation just before the start of the remote
> > processor, rproc_da_to_va() could be called before all carveouts
> > are allocated.
> > This patch adds a check in rproc_da_to_va() to return NULL if
> > carveout is not allocated.
> >
> > Fixes: d7c51706d095 ("remoteproc: add alloc ops in rproc_mem_entry struct")
>
> This commit only shows up in 4.20, not 4.19, so why is this patch
> relevant for 4.19?

Your scripts are better than mine...

>
> thanks,
>
> greg k-h
