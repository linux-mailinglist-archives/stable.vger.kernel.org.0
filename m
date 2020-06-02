Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677321EBE70
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 16:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgFBOsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 10:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgFBOsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 10:48:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED12C08C5C0;
        Tue,  2 Jun 2020 07:48:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id h185so4147127pfg.2;
        Tue, 02 Jun 2020 07:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M/pQ6/V+iIwxJgJX2XQUS9GZhFyupAHE1/NbSCr2rNA=;
        b=UGYI0vDbfA2lLdAecfHXB6CsdyXOhyZGzBnrvjQQLMRxG9OTlewAjJ3OBimlkOu0e0
         yb2hMRxrBmY9zZvmY9JphcOHZG/URyrAqOzwj20zlOg7ljEHkcuUkHAtypxZc4Wqclyn
         zuddNyrhXbutdSvrAg4q2YYfQ8iTgobPVb0xoZ60ZNbcboT8/F/VOKMpFmG7JajS7pKg
         qB4fHZr0SWwvTf4VD7mKKCWEFTHJhO4QfkzdER4U4nb37cRiqpeujdlapg2a9meKAa9a
         n5kfaghXZLybcCKp3QGGcE6UqSv1dEGQ6A5rq70zw/v5zK7ZwNn8FTPxyE7dMx5G1sGC
         hdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M/pQ6/V+iIwxJgJX2XQUS9GZhFyupAHE1/NbSCr2rNA=;
        b=DtDZ87+yxsb3w8vOTVk5M81qrjIz47niMqGS0WDoAr1+n5KAzm3fdluWvyftEjucOi
         xLBFXlsajbuGA+joLX5tXmQIDfVjbHjjY5hsySflavdQZaRiRSCcOdsg0FftH9fNpyVD
         DApy7D8jOJeg4RHT9QHrmW0VyNs426DpDz9H+7RtwuMXOPWoh3DdR2hxUqQh0aCmcqnE
         URj6X5kzvhu4A3AKZWLuAe2FEJdH9V20W8fofLPJnx1Y3R+Iv0Zj/HBocWr83VUwoluV
         oi/+mgrY570cRnsfUxDNE0drjS/u8My5ATlbyybau0BiT39Thj/cNO1aro0e+YxG2f9b
         XoxQ==
X-Gm-Message-State: AOAM533mBmmK6OR6yJpjMZWGk47qDr9qpxR8zCYBwzwqCEe+XAafaE8G
        Qf9cXznOqX/uyHvOeJrfJ4F08pDXxYomuwUN2wI=
X-Google-Smtp-Source: ABdhPJxyrRgrMBYC2nBmyIsXSR3S/B7csWevLL534lz2naW6/7vfXOMm7ZBhbW4ZMJezZvzG3Cka9xuailmbdxkZu0I=
X-Received: by 2002:a63:ff52:: with SMTP id s18mr8270132pgk.203.1591109320582;
 Tue, 02 Jun 2020 07:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200602140058.3656-1-johan@kernel.org> <20200602140058.3656-3-johan@kernel.org>
In-Reply-To: <20200602140058.3656-3-johan@kernel.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 2 Jun 2020 17:48:29 +0300
Message-ID: <CAHp75VeXYn46wQ5EXkk_MOQ49ybtyTeoQS6BS1X9DkC6hbeF-w@mail.gmail.com>
Subject: Re: [PATCH 2/4] serial: core: fix broken sysrq port unlock
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 2, 2020 at 5:03 PM Johan Hovold <johan@kernel.org> wrote:
>
> Commit d6e1935819db ("serial: core: Allow processing sysrq at port
> unlock time") worked around a circular locking dependency by adding
> helpers used to defer sysrq processing to when the port lock was
> released.
>
> A later commit unfortunately converted these inline helpers to exported
> functions despite the fact that the unlock helper was restoring irq
> flags, something which needs to be done in the same function that saved
> them (e.g. on SPARC).

I'm not familiar with sparc, can you elaborate a bit what is ABI /
architecture lock implementation background?

-- 
With Best Regards,
Andy Shevchenko
