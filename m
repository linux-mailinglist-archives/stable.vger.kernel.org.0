Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94ED4820D3
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 00:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhL3XOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 18:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhL3XOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 18:14:53 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC28C06173E
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 15:14:52 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id j6so103046458edw.12
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 15:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MvbY16E8oyZuQmwhENSd6ZR/AetXrgDul+iMAR9/AXs=;
        b=gsA1hbhaKjRlq/54Zv3QJKllmFQb5RPA+G1TyRwBsE4AzpCgAo/4F3ioK+1ebe/okE
         4HQ3TvTmGY4Afv+EqtL6dlSH5k52i3ITIF93hq69VFAoKVpFih4aZ/xyH5P9SfjjeuyC
         L3ZChkTaAXYVV1/AVuj2/5QthCNYPd85oz6MY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MvbY16E8oyZuQmwhENSd6ZR/AetXrgDul+iMAR9/AXs=;
        b=2u0QADoQCc9ZqhXEWP6owB8CKt9FbX5ChJ0h+B2qDZYSEtQE2W6yBK8XBRVHgQ2pm4
         /kr0i4B6DT8M5iVl33IpEmo4AwiX11bASWHxN4a3bazj8BDzg4pUV6NkljqrU2DhRQEF
         ELfbUDOVERQYCj1RXJKaiI+4dVwXwFmJHmFd9HEXQAbfCDg3lGIXHIMQE/xZBN2AygLL
         g/3Oh1xGpruVKI7OXD/UI8oF1cUtTAV//kLx+CMArnXYdiTNM+qldWroXVa+oUn3jPq5
         8ALYe/SwwbBpH6AJBL/pVuLH4NIuZZrCq9FlbMJN5wVRZE+Jcvb0CBHq/S784s7AIOjs
         BDmQ==
X-Gm-Message-State: AOAM5338RYk3d/7PBU8P6WEdREa9YEUZtANz7MEF/jfM436Q03yGXMsC
        G0JpCroJ2NCjgAuoHTLIpc4cQUxVjFdvEfKm
X-Google-Smtp-Source: ABdhPJznxKggz7Pn+oK4JVtFOqbnihX5cnQJzRzhJ9IIbZTUEk5rduLKATtURGemoiL6D9f14AQ5lA==
X-Received: by 2002:a17:907:948c:: with SMTP id dm12mr25603960ejc.551.1640906090621;
        Thu, 30 Dec 2021 15:14:50 -0800 (PST)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id k21sm9858753edo.87.2021.12.30.15.14.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Dec 2021 15:14:50 -0800 (PST)
Received: by mail-wr1-f52.google.com with SMTP id e5so53040684wrc.5
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 15:14:49 -0800 (PST)
X-Received: by 2002:adf:d1a6:: with SMTP id w6mr26006959wrc.274.1640906089307;
 Thu, 30 Dec 2021 15:14:49 -0800 (PST)
MIME-Version: 1.0
References: <20211230192309.115524-1-christian.brauner@ubuntu.com>
In-Reply-To: <20211230192309.115524-1-christian.brauner@ubuntu.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 30 Dec 2021 15:14:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=winoYrnz+KQA5Mqrw9f=PeyvKT2SsyAx=ZCUoBxm4kDpA@mail.gmail.com>
Message-ID: <CAHk-=winoYrnz+KQA5Mqrw9f=PeyvKT2SsyAx=ZCUoBxm4kDpA@mail.gmail.com>
Subject: Re: [PATCH] fs/mount_setattr: always cleanup mount_kattr
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 30, 2021 at 11:23 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> Would you be ok with applying this fix directly? I

Done.

That said, I would have liked a "Fixes:" tag, or some indication of
how far back the stable people should take this..

I assume it's 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP"), and
that's what I added manually to it as I applied it, but relying on me
noticing and getting things right can be a risky business..

              Linus
