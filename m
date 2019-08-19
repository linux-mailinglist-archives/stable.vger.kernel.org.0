Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4459227C
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 13:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfHSLfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 07:35:32 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:37092 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfHSLfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 07:35:32 -0400
Received: by mail-qt1-f181.google.com with SMTP id y26so1459996qto.4;
        Mon, 19 Aug 2019 04:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9W3L9b/U8JxoJLmXpqGAvG2NyOslHh74rCFw2ZZqrms=;
        b=THpp9RtykhrmnyEqz8oSrYolEwqgDI9/XL0adg9POJt7tGXU9246wpnmw7vCkUvPav
         kS4mnnmdaTrw35mUm9wOJ1nKstbrb3Q0YG0QdrL/HxV+K2DNCO20hYMpmzLifNU6vKTQ
         tJVywhptluxsPUC0PDPyGma5ZG7t8G64jaDny7KzQmTf6Mh66dhNyaei9kvji80xeYxY
         lcBZ9/bX91N3SPkyIly3FzvXeDlGaHP5umzquoFTMmbMVtuA03NLWrVjlliSr1vGq0dy
         x7f5qmIK1B+YaBUO92/FESzcaYzI9jUq0JDuctsG3mu3shpvxdS5m+zwZpomLaxq1UuE
         IE8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9W3L9b/U8JxoJLmXpqGAvG2NyOslHh74rCFw2ZZqrms=;
        b=fCmGB7axJ1+PsTjUy/LnoxrfjyUwLwVG0jxiREpjp637sNYdxybTgrBpxmUg3cmn/R
         TkQaIIFAI9Y/tIdNlTbCxl46xWb8D5pWSpd1ZNFKE+uGzs7bMZWb/LnA183lm5j1T+m7
         ZJRqCggAmIA+EsQPp3R98Pdmf1XB3B525w7yExlJ8W0MsvyFd3RjeXUUcvQbdDGaLmFi
         O/AF10uSCMsp0WMWHzkdaaDZ9inAW57IcvY4WFNPd/Rh/kBynsDbOgMgjoQGPVZGBP2u
         8x1mkSayF1Wm3Kv6z1vxNyBiwk6WWOll4/pDA92Cb0kqQeNNtDdRIP1SIfCQZYEVykyk
         JMdw==
X-Gm-Message-State: APjAAAX7cZNs9Nq4N+dfZaOE3gAoPx33O+z+1Lr9uxVoFGR/NKD5P9mK
        wCEe1CvngOixOBCa02acQpoS7ia+0knFtdxrWnrFiw==
X-Google-Smtp-Source: APXvYqxnY8W9Loqh/HMLJtf6n/kIiaQfdwrFj+wvuSo+pp1w4O2FgUkPqabr1fE02ssYr1lmlFF3Hv1scmZmjs1xTdI=
X-Received: by 2002:ac8:4a8f:: with SMTP id l15mr20875401qtq.29.1566214530804;
 Mon, 19 Aug 2019 04:35:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190322110515.21499-1-ianwmorrison@gmail.com>
 <b5a7b895-e08d-f432-8606-4d8c776d4a8a@redhat.com> <CAFXWsS9UYYz0HaYPgLAUZ0OaUE9gb25bT0+PSuexY9Nn05rY8Q@mail.gmail.com>
 <c144cbd0-1773-14cd-62c9-6f41eab5894a@redhat.com>
In-Reply-To: <c144cbd0-1773-14cd-62c9-6f41eab5894a@redhat.com>
From:   Ian W MORRISON <ianwmorrison@gmail.com>
Date:   Mon, 19 Aug 2019 21:35:19 +1000
Message-ID: <CAFXWsS83PqmqNOO22bktuAw+H7-X8RvNOgUnV--bWpTMkD7OPA@mail.gmail.com>
Subject: Re: [PATCH] Skip deferred request irqs for devices known to fail
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     benjamin.tissoires@redhat.com, mika.westerberg@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        bgolaszewski@baylibre.com, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans and everyone,

On Mon, 19 Aug 2019 at 04:59, Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi Ian, et. al.,
>
> As such I guess we may need to go with the blacklist patch you suggested
> which sucks, but having these devices not boot sucks even harder.
>
> I guess this problem did not magically fix it self in the mean time
> (with newer kernels) ?
>

Unfortunately it didn't 'self-fix' with later kernels.

> Can you resubmit your patch with Andy's review remarks addressed?
>
> In case you've lost Andy's reply I will reproduce the review remarks
> below.
>
> Regards,
>
> Hans
>

Resubmitted as requested.

Many thanks and best regards,
Ian
