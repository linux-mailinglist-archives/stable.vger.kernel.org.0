Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97F0495DD
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 01:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfFQXaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 19:30:13 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37209 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFQXaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 19:30:13 -0400
Received: by mail-lj1-f196.google.com with SMTP id 131so11094332ljf.4
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 16:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TSlnrikhmcgad5C0n4qp/v4MF0qr179vLd3WTKmDTCM=;
        b=BxpvYJ+agSNLwq4y9NHDYqRZrmep21oIT9drwkiIH2vfs5ZeeuU6IKHLuxX9G306a4
         4mMlrj/9OewJMlCd2mOEFWBGl+lmtDoa19iHj8blbUjKhIUwxNFWEzt6rRvmSEdNkivr
         WGZut+frZ7Ro5jVpYWitT+690GF3d6LM1mkuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TSlnrikhmcgad5C0n4qp/v4MF0qr179vLd3WTKmDTCM=;
        b=et6vYN7QKK0I0DfrFnKI9ZFHKTvx9aL0Uk4T+PogQW5thWFP5cTyov9uJeDar8xJk8
         RWJhZrkKRZzWY++BfaXRU8aQjh4TrJRplVJbWLzyVuenSB/n5V0UwajFkv1QFy60fgRd
         txtZav5IS6E9cxiK5LknSufkwHRLxgsHj4l+MH3SzPJ2JDUcsb9Tp7CLKwGwmbPkn1o3
         W++gqmXYPj8dXVyDqBgRfMg32Nnk0ZLt6W2RhTE33CeZn8UKaVkaubMkfBf8KoZ1bgKA
         eLiklO92kB+GqHyAmRqAhU6oRXpoJmdZ5qMh8dErr7NUTyG7hSyafAnX9f3Yf7NQd1YL
         HZjQ==
X-Gm-Message-State: APjAAAVUluRrsOIm3e3tdWG0IH4RIUUZbJCg9kb3RgAcymT8W56UP+W7
        +CwQe76/nua4EPz0U/OmHpREEUgVAU0=
X-Google-Smtp-Source: APXvYqwzo1zhuVwl6F9/Z+Q1Kjsi579z4q/CZkgpB8Ym/KAGBGJffsCG2kQlvhTReo/pCcn1nUsb2w==
X-Received: by 2002:a2e:124b:: with SMTP id t72mr52795620lje.143.1560814211371;
        Mon, 17 Jun 2019 16:30:11 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id n10sm1955561lfe.24.2019.06.17.16.30.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 16:30:10 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id b11so7825762lfa.5
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 16:30:10 -0700 (PDT)
X-Received: by 2002:ac2:4565:: with SMTP id k5mr544968lfm.170.1560814210085;
 Mon, 17 Jun 2019 16:30:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190617212214.29868-1-christian@brauner.io> <20190617213211.GV17978@ZenIV.linux.org.uk>
In-Reply-To: <20190617213211.GV17978@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 Jun 2019 16:29:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=whvURjNyBUx_V7z3ukSeHN6A5jbQF5c53X40undQy8v9w@mail.gmail.com>
Message-ID: <CAHk-=whvURjNyBUx_V7z3ukSeHN6A5jbQF5c53X40undQy8v9w@mail.gmail.com>
Subject: Re: [PATCH v1] fs/namespace: fix unprivileged mount propagation
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christian Brauner <christian@brauner.io>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 2:32 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Applied.  Linus, if you want to apply it directly, feel free to add my
> Acked-by.  Alternatively, wait until tonight and I'll send a pull request
> with that (as well as missing mntget() in fsmount(2) fix, at least).

I've pulled it from you. Thanks,

                   Linus
