Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481541C9B3C
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 21:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgEGThG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 15:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728451AbgEGThF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 15:37:05 -0400
Received: from nibbler.cm4all.net (nibbler.cm4all.net [IPv6:2001:8d8:970:e500:82:165:145:151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992EFC05BD09
        for <stable@vger.kernel.org>; Thu,  7 May 2020 12:37:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id 59F0EC0280
        for <stable@vger.kernel.org>; Thu,  7 May 2020 21:37:04 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at nibbler.cm4all.net
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 8nk1PbkjERdc for <stable@vger.kernel.org>;
        Thu,  7 May 2020 21:37:04 +0200 (CEST)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id 38BB9C0240
        for <stable@vger.kernel.org>; Thu,  7 May 2020 21:37:04 +0200 (CEST)
Received: (qmail 6409 invoked from network); 7 May 2020 22:53:21 +0200
Received: from unknown (HELO rabbit.intern.cm-ag) (172.30.3.1)
  by zero.intern.cm-ag with SMTP; 7 May 2020 22:53:21 +0200
Received: by rabbit.intern.cm-ag (Postfix, from userid 1023)
        id 052D9461450; Thu,  7 May 2020 21:37:04 +0200 (CEST)
Date:   Thu, 7 May 2020 21:37:03 +0200
From:   Max Kellermann <mk@cm4all.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>, Max Kellermann <mk@cm4all.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
Message-ID: <20200507193703.GA16367@rabbit.intern.cm-ag>
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
 <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
 <20200507192903.GG23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507192903.GG23230@ZenIV.linux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/05/07 21:29, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Again, resolving the descriptor more than once in course of syscall
> is almost always a serious bug;

.. and that is what Linux currently does for those three operation,
and yes, it's buggy.  The generic preparation code looks up the fd,
but later in the implementation, only the numeric fd is used.

My patch removes this duplication, by removing the first lookup.

Max
