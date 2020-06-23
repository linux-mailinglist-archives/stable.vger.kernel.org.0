Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157AF2066E7
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 00:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388448AbgFWWIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 18:08:09 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:34881 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388380AbgFWWIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 18:08:05 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b2ba8d0f;
        Tue, 23 Jun 2020 21:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=YSFKerWeIpnzuDylmioR1V2+TSU=; b=Kt0tqi
        F6r57b524H9M0JGLVhw0zW4S/vyTJHooCpjd9T4pd/Ip9xybj+Z8+4fm3PfLOvNo
        NBjyvolTRE0wKdU3BAE+A8n86vs+KAaMzWyNSbKW8R+M+LLNg2CQ9Jgx5AeTJYnw
        qlIwfdz+4vTNS/LDj2GmHX5UGQQvq9bAgYkm3l3hSpKNxySUsr5lsFFgmn0v7h1g
        LoE2XazbIOB3eSwMzOlWzV5aL0vRZwuK5G6YCW8mDXhqiig9T7jfUF6FUnJsWxVI
        XhQLIsdx8FTMzRs9yaIx2g7qihk2/4xNYahHuM0rUfa/FBhcorZ86oRbAl+iOLQT
        oTW3PJ91PYsL5JGw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 67dc8c4c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 23 Jun 2020 21:49:06 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id l9so216153ilq.12;
        Tue, 23 Jun 2020 15:08:02 -0700 (PDT)
X-Gm-Message-State: AOAM5310yJRDjRde3C0/wbO89OvDUrWE4CuVA0R0tZOkV1pQ+WY+jQpp
        U3BCyCXKpSIkkIEgU811iCHwagWTofdTns1NszA=
X-Google-Smtp-Source: ABdhPJyrViZN9sUWFqUPSrqGarMBs8nitnv9OMM7/D6GSQDQMBqN6ICkonNlORp6pHCwHJC1n0qKJKhvi/NXp4dfYpk=
X-Received: by 2002:a05:6e02:605:: with SMTP id t5mr25663486ils.231.1592950081670;
 Tue, 23 Jun 2020 15:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191003154533.590915454@linuxfoundation.org> <20191003154533.875309419@linuxfoundation.org>
In-Reply-To: <20191003154533.875309419@linuxfoundation.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 23 Jun 2020 16:07:50 -0600
X-Gmail-Original-Message-ID: <CAHmME9oNODYeVZZdgEqy+foSKZcBY51ZEujYCwymL0sU+R-5LA@mail.gmail.com>
Message-ID: <CAHmME9oNODYeVZZdgEqy+foSKZcBY51ZEujYCwymL0sU+R-5LA@mail.gmail.com>
Subject: Re: [PATCH 5.2 003/313] ipv6: do not free rt if FIB_LOOKUP_NOREF is
 set on suppress rule
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I realize 5.2 has long since sunsetted, and I really missed the boat
on speaking up about this many many months ago, but in case any
distros or organizations have a 5.2.x stable series, this should
probably be reverted from 5.2. The reason is that 7d9e5f422 was added
to 5.3, and introduced a UaF, which this commit then fixed. But
without 7d9e5f422, this commit adds a memory leak.

Anyway, not worth spending too much brain cycles on this, considering
5.2 isn't even mentioned on kernel.org any more, but in case it helps
for somebody doing something strange in years to come, voila.
