Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63C9CDF67
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 12:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfJGKd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 06:33:26 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36744 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfJGKdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 06:33:25 -0400
Received: by mail-lj1-f196.google.com with SMTP id v24so13057316ljj.3;
        Mon, 07 Oct 2019 03:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oNNig/APpXlzsgQf4/4zikU/t/X44sqLM8yD3yPV7Z4=;
        b=a6/c32y8W+2OO4I6umBjXsfYmAjr1wzq5ZHhKiIZm4Em48taC2TXmnilorIClfKHaO
         RSmxzvD8Xs9fFNWqWqMrgleX8F0IxuyIxwH1d9TyD7vMeV3yPBJehBnUP3Lfh7mprb3c
         9b8wzQwf0QnO24TOfK2zUJKNaulHRMaWc2qN787jm9FNi2sc5hlCzXobCuA0HVTyK12D
         /qqGSIztyF/WpWSBLhqXD9Sb1XwyKVK4uiix35kPRM7S4UaTzPcREo0x+u1WhX1lhin8
         EI/ymKpfMHY/b8ZnavARPa21x+ufuCtjZ2NegaQj+mZGtpsQyVbXypQS5qliNRaaQqn5
         Dy+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oNNig/APpXlzsgQf4/4zikU/t/X44sqLM8yD3yPV7Z4=;
        b=AUTF1YmG9s9Nvjq8lV+7TqUEuF/PkGD6i/Z2zZt/Zqdq3Xik3ii0IgAADIU/x8Ozk7
         /Xquw4J/G2O0tWl2+ijCV+/tPKs/+gxTIBQxaWEtFmRH/6tpIe1rJbsJL1D0VZuDvhuH
         f276mGqh3tGAFEIhZ5i3n5cedSQI2+1Iv/pZsDGt/iqyRHUqIglGBJGtQUqttPYqGwiZ
         vjlxDyhclYgyIMZBiz3W8GM2p33RIxLZFxh94ayf7VOQNa2Ylp4ONTQk0Gn1DyMHFBLO
         gmfBTnT1SMnki+Ki+tJ8V8paStNyfAkI5VOJkJffzaOi/8mi9jIO84zU+VNR1RPWqSEA
         r+0A==
X-Gm-Message-State: APjAAAV7TNNNnRZUZ59sqMpnGelwTtMUOxATEt7UZU/5ZAaopfKEmPRT
        cCEnu9IKAatZ51nc1dVf1pQ+hofjdQMIPtXtWlw=
X-Google-Smtp-Source: APXvYqxSWwZ3uEPxII3m5erP4rL+4mMFDIzGpozY/SmRULvAvFf0dEbcTOqNDO98GfiRUqXydlHQYNsktRgveYZyj2U=
X-Received: by 2002:a2e:9854:: with SMTP id e20mr17397616ljj.72.1570444403274;
 Mon, 07 Oct 2019 03:33:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <1570024819.4999.119.camel@linux.ibm.com> <20191003114119.GF8933@linux.intel.com>
In-Reply-To: <20191003114119.GF8933@linux.intel.com>
From:   Janne Karhunen <janne.karhunen@gmail.com>
Date:   Mon, 7 Oct 2019 13:33:11 +0300
Message-ID: <CAE=NcrY3BTvD-L2XP6bsO=9oAJLtSD0wYpUymVkAGAnYObsPzQ@mail.gmail.com>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 3, 2019 at 2:41 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:

> > At what point during boot is the kernel random pool available?  Does
> > this imply that you're planning on changing trusted keys as well?
>
> Well trusted keys *must* be changed to use it. It is not a choice
> because using a proprietary random number generator instead of defacto
> one in the kernel can be categorized as a *regression*.
>
> Also, TEE trusted keys cannot use the TPM option.
>
> If it was not initialized early enough we would need fix that too.

Note that especially IMA and fs encryptions are pretty annoying in
this sense. You probably want to keep your keys device specific and
you really need the keys around the time when the filesystems mount
for the first time. This is very early on..


--
Janne
