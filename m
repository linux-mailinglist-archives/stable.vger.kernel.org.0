Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7302614C153
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 20:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgA1T7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 14:59:48 -0500
Received: from mail-lj1-f177.google.com ([209.85.208.177]:33057 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgA1T7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 14:59:48 -0500
Received: by mail-lj1-f177.google.com with SMTP id y6so16061099lji.0
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 11:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=FCDy/PUcgGUzw+QZ++RNfT9CZygl81KTsTPP5F6CsZA=;
        b=TYoNF/9FADZR0mjsUzzEBKKxT4SNaxpQKPq3bzFl+QApvwBdH329rYbLgbK5S8CJbO
         th6OKloTieN7/w88L6u//o0Hu9tgk6FFEpphDN5jZa/TQgHj1fyvQwJ/tFJHEPxZuUbp
         d/5OAcFUlEa66ZNy+iIDNnpNjgdafGj/N9ZTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=FCDy/PUcgGUzw+QZ++RNfT9CZygl81KTsTPP5F6CsZA=;
        b=bTX2285oWypxjKvTDSrDa3tPwTKXpft0sBlBqPxvJDj97qB5uKNOydqI/NjcFmqjns
         D3ekFGghToS5GqQSzqCdPPGep/GVIFeINxYDpta6MOCjVMFIadpNxWoInpn6szrzsIgZ
         4ucFtC2u93o3vZ/TDA7wpJMX9RXsLw4mERgq1oV32SHY+Y3IZIuB00cSxolplQz1wjqs
         /f7WLNQi2kK7UpIs65tJPYaYsbvl3g1Umst3uBBovivGpEPedaPb3UTaytRDAr8I5qeG
         1sobnK1c/liuVD4sMHm1Aczq3+eDMKsM+7TDVEowII5xERLVml9xYe9H8Pf+KgGe3lHI
         BEFQ==
X-Gm-Message-State: APjAAAV4SAlA3jiiY7Hjasab9H2MOtwoOr9H4Aj499UDVIWqcvOTzFsW
        Vi5mlWGD9aWfG5FG81Pp7HU79X60T6c=
X-Google-Smtp-Source: APXvYqw/80fvJUg3gwExuUztpnSB4/LHMKyR/N67lebptjpjnr1Tkz4wU4MQ/2qpNDoYtWeh6MtvOw==
X-Received: by 2002:a2e:81c7:: with SMTP id s7mr14310305ljg.3.1580241585453;
        Tue, 28 Jan 2020 11:59:45 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id m3sm10323798lfl.97.2020.01.28.11.59.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 11:59:44 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id q8so15968694ljj.11
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 11:59:44 -0800 (PST)
X-Received: by 2002:a2e:461a:: with SMTP id t26mr14259922lja.204.1580241584210;
 Tue, 28 Jan 2020 11:59:44 -0800 (PST)
MIME-Version: 1.0
References: <20200127230214.GC25530@morgul.net> <20200128075223.GD2105706@kroah.com>
 <20200128193437.GA18426@morgul.net>
In-Reply-To: <20200128193437.GA18426@morgul.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 28 Jan 2020 11:59:28 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiqQcpwh6iC0RpAQHOksSVQiq0SOU30DMecOJn_wrXzPg@mail.gmail.com>
Message-ID: <CAHk-=wiqQcpwh6iC0RpAQHOksSVQiq0SOU30DMecOJn_wrXzPg@mail.gmail.com>
Subject: Re: Please apply 50ee7529ec45 ("random: try to actively add entropy
 rather than passively wait for it") to 4.19.y
To:     Noah Meyerhans <noahm@debian.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 11:34 AM Noah Meyerhans <noahm@debian.org> wrote:
>
> Added torvalds and tytso to the CC list.  Linus and Ted, what do you
> think of the idea of applying 50ee7529ec45 ("random: try to actively add
> entropy rather than passively wait for it") to the 4.19.y and 4.14.y
> kernels?

By now I suspect it's the right thing to do. Nobody has complained
about it, and it fixed real issues during boot.

Some of those real issues may have ended up being just unnecessary
delays rather than complete lockups, but still..

               Linus
