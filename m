Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9989D13FC64
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 23:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387527AbgAPWrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 17:47:17 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43135 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729261AbgAPWrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 17:47:17 -0500
Received: by mail-wr1-f68.google.com with SMTP id d16so20840212wre.10
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 14:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zz0v2Mo/daZYkZwGjb2xSqQ1lz9vMHmlSDOGKHldj+Q=;
        b=pfWmSxJlOau+G4lzYR0qQdksl5kLiV3NZgjFVaNi79FMAsGsNHNYKFHVEk1ZCkEnwJ
         OsMOXndSVH9wXc9bvMc8F1BNNWCfkr3eiCozpWzc+2NDtMKouv2sBlLUrx6G7hETgso1
         f8TublLo+iNwAQOxA7sskIJaxCF+qUJtC0Z/QPjvbGkxF7JXIk5hOEwqv55wLQalmiJl
         8Y4gidbVTFZ8K8oQeEVoGr4G1ZXhiI08NFuK/PDGvlfVT+rcXJn95vlTrHNEmjVvlJCA
         D9IWRrRO0ax/q5Txe4dYTBsyaK+y2YvCbfCVEfhNRs43MBMCM2NL3hOU2wVJ1UDtbP1o
         urqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zz0v2Mo/daZYkZwGjb2xSqQ1lz9vMHmlSDOGKHldj+Q=;
        b=Z4PBFH+6oZoyqhPzgPcc8PWdC5nqIR2Ou5A4jnt4tf4sYiZ3Mmk3dj6CBlVYefQqjm
         lbd/IeRIEMXnECGx8i75iG1nv4apIz0pr/0TMbucJZS1I8BIStFFEO3TIqZYA3jtLM86
         k+GSaIMrG44b8j3JvXSvgs7Ce5+sP0KL+H9a/wmklMBXj8nfUCAcf+s9Esp766KV/sg1
         PQpAxaEPIXeJFXsNlhE0FmJUD1d1J/2zb9NUd1uocW0qEfnBAdCcni5ARv2Ky0cIqBQB
         L3Ha4zIH7G0k4FqJhabQYzmAdxH57N7/sdzf25e+xQm33qLIPvq9MyhJllvrx/t67anx
         x6xQ==
X-Gm-Message-State: APjAAAWvoku2dijY8jVbixizntFx329LN9P/bW63SR8ytjriTU7mCE0Z
        BPEZPdNOl2pRlLekSv8Rjg7HNwsEoEerEZmZ2zU=
X-Google-Smtp-Source: APXvYqxEyiwgWRg2PdTKpSKjsE3Jpbm2McamfODiL0fmySi+CP0lnBCpevOuK8C6S+ih4FSkHlNJrZ5gP+JBOo2Y/D0=
X-Received: by 2002:a5d:6441:: with SMTP id d1mr5589794wrw.93.1579214835154;
 Thu, 16 Jan 2020 14:47:15 -0800 (PST)
MIME-Version: 1.0
References: <20191204100958.19938-1-s.hauer@pengutronix.de>
In-Reply-To: <20191204100958.19938-1-s.hauer@pengutronix.de>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Thu, 16 Jan 2020 23:47:04 +0100
Message-ID: <CAFLxGvyv=OMOSQSymMo0NTWpgGq_xnhGZgjyaXHeGtDsrwsYFQ@mail.gmail.com>
Subject: Re: [PATCH] ubifs: Fix wrong memory allocation
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Naga Sureshkumar Relli <nagasure@xilinx.com>,
        stable <stable@vger.kernel.org>, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 4, 2019 at 11:10 AM Sascha Hauer <s.hauer@pengutronix.de> wrote:
>
> In create_default_filesystem() when we allocate the idx node we must use
> the idx_node_size we calculated just one line before, not tmp, which
> contains completely other data.
>
> Fixes: c4de6d7e4319 ("ubifs: Refactor create_default_filesystem()")
> Cc: stable@vger.kernel.org # v4.20+
> Reported-by: Naga Sureshkumar Relli <nagasure@xilinx.com>
> Tested-by: Naga Sureshkumar Relli <nagasure@xilinx.com>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  fs/ubifs/sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied. Thank you, Sascha!

-- 
Thanks,
//richard
