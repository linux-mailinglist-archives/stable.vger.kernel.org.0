Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F122F1B7E
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 17:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfKFQmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 11:42:05 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33072 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbfKFQmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 11:42:04 -0500
Received: by mail-lf1-f68.google.com with SMTP id y9so2459773lfy.0
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 08:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w3gb3P2HSHZ+uOjDkAzERapZeMR9/2van371GJtAxmA=;
        b=Yy9LsNBTWfa3r0IWIO+Fb3FHQXiwlJY807p6iV4m1gCt4Q7e53ezbT8kyt3W0H4kC+
         Qx48sYyNhwmo4smJc82H2aGGon/cUfLuRe93IVoC0PANKlIQX5xloCLEAEbTr9HoS3PV
         ZKVCKCTJuAfKz1OWVSurkAv7QYRuTGsxdQdMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w3gb3P2HSHZ+uOjDkAzERapZeMR9/2van371GJtAxmA=;
        b=oWii8QOa7N9nMznB5GHocqla/hHUbnB7MUQ4/aHErR3vyf6U0jAE4UoNCK9EqB4ds4
         /beGqAg+7745x4Kf+NNwL1dEIfFVY8W7iw2uOmxMAJMvxBdRPe7dC6hImN+v14WcZRVf
         ++t0tXhkOIIk9yAw87rYOaUwMxgQIacjeYocBrGj/XIs92jj3Qo8gB0JOuUiw9Vet+vX
         7war39fuYlH6nZy1cQ+5OilBh6H4h66Vrc4YfX35w/L+tydrkdgfPPyc2Giuxa9vc/lP
         oH58CxBi366vIEPjk7SJCpoEXCAfG4La0G8ipXalNg1ZMT57srGZe3m2wWWh3xFAqCA0
         rjwA==
X-Gm-Message-State: APjAAAVx6Z70lnoxn2sO/FWxcVE2PMdri1ouaqLvYZEJ2Hh/0Ur2/D9I
        TXcMDnZ5vi5F3/xn0d4GCc9QyG7Fj2I=
X-Google-Smtp-Source: APXvYqxsSS1YXQbIHdGovLoU1d4I+TfITHkp8cauR/ihFPipeVAtaZAtIWVf9xjAYkorWccOclJ8JA==
X-Received: by 2002:ac2:50d6:: with SMTP id h22mr25687977lfm.155.1573058522509;
        Wed, 06 Nov 2019 08:42:02 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id g5sm9826157ljn.101.2019.11.06.08.42.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 08:42:01 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id m6so2406075lfl.3
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 08:42:01 -0800 (PST)
X-Received: by 2002:a19:fc1c:: with SMTP id a28mr25233519lfi.170.1573058520643;
 Wed, 06 Nov 2019 08:42:00 -0800 (PST)
MIME-Version: 1.0
References: <20191106051634.IwGqLbBvh%akpm@linux-foundation.org>
In-Reply-To: <20191106051634.IwGqLbBvh%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 6 Nov 2019 08:41:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgZvzmijNca0rX+jcZZPPAdD8RSR0=5=vDB+1zUhHYD+w@mail.gmail.com>
Message-ID: <CAHk-=wgZvzmijNca0rX+jcZZPPAdD8RSR0=5=vDB+1zUhHYD+w@mail.gmail.com>
Subject: Re: [patch 05/17] ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com,
        jlbec@evilplan.org, junxiao.bi@oracle.com,
        Linux-MM <linux-mm@kvack.org>, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable <stable@vger.kernel.org>, sunny.s.zhang@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 5, 2019 at 9:16 PM <akpm@linux-foundation.org> wrote:
>
> From: Shuning Zhang <sunny.s.zhang@oracle.com>
> Subject: ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()
>
> When the extent tree is modified, it should be protected by inode cluster
> lock and ip_alloc_sem.
>
> The extent tree is accessed and modified in the
> ocfs2_prepare_inode_for_write, but isn't protected by ip_alloc_sem.

This patch results in a new warning for me:

  fs/ocfs2/file.c:2101:12: warning: =E2=80=98ocfs2_prepare_inode_for_refcou=
nt=E2=80=99
defined but not used [-Wunused-function]
   2101 | static int ocfs2_prepare_inode_for_refcount(struct inode *inode,
        |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

and I'm wondering why nobody seems  to have noticed that or fixed
things? Because it does look like this removed the only use of that
function, and everybody who compiled this should have seen this
warning?

Was this not tested at all?

              Linus
