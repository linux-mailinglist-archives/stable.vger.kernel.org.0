Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891BB3B6475
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbhF1PI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:08:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234885AbhF1PGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:06:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E755B61C82;
        Mon, 28 Jun 2021 14:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891456;
        bh=l8xIVzscZoiXeJLtkWgfbXmxS5FPm4sqJlwbpgvEvNU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f6T2RU+XRroYN17GYS5iHJ6ACK46Q/2zjffbEmz+PuebhcrPFv9t6S8ELE0RGQ23s
         VH6vHJSis7Epu7JeXq/6BzHKhFyfs12jBSaE+uxvs2uRGGSwIlwHpkcB+3qRCPabDE
         eiFivBPZ3PaItXbfakAsL+4Bkd3ua5E+aLveEgClieeODxw8KwiPQ4LmWLaH5X42as
         P8iJV6njt3flIsCC95389IrQWpZ2O5RY+3tbGC45aXST6fpvB8JyK5F50Z/qWQo/ZT
         ScI3aYvyF8krV9axcF5TTayV92ngSAUccvOpy3yj1tcPyqKm/yWd7g7I2zMzN9vfV4
         rJIu4fr41MKtw==
Message-ID: <3a993a4f2b302fd4fdb6f778f29f7f81db79adda.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: reduce contention in ceph_check_delayed_caps()
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Mon, 28 Jun 2021 10:44:14 -0400
In-Reply-To: <YNmQiP/Idf92tDDw@suse.de>
References: <20210625154559.8148-1-lhenriques@suse.de>
         <e427c4e5877e0b036c36eedbe40020047b02a85b.camel@kernel.org>
         <YNmQiP/Idf92tDDw@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-06-28 at 10:04 +0100, Luis Henriques wrote:
> On Fri, Jun 25, 2021 at 12:54:44PM -0400, Jeff Layton wrote:
> <...>
> > I'm not sure this approach is viable, unfortunately. Once you've dropped
> > the cap_delay_lock, then nothing protects the i_cap_delay_list head
> > anymore.
> > 
> > So you could detach these objects and put them on the private list, and
> > then once you drop the spinlock another task could find one of them and
> > (e.g.) call __cap_delay_requeue on it, potentially corrupting your list.
> > 
> > I think we'll need to come up with a different way to do this...
> 
> Ugh, yeah I see what you mean.
> 
> Another option I can think off is to time-bound this loop, so that it
> would stop after finding the first ci->i_hold_caps_max timestamp that was
> set *after* the start of the current run.  I'll see if I can come up with
> an RFC shortly.
> 

Sounds like a reasonable thing to do.

The catch there is that those caps may end up being delayed up to 5s
more than they would have, since schedule_delayed always uses a 5s
delay. That delay could be made more dynamic if it becomes an issue.

Maybe have the schedule_delayed callers calculate and pass in a timeout
and schedule the next run for that point in the future? Then
delayed_work could schedule the next run to coincide with the timeout of
the next entry on the list.
-- 
Jeff Layton <jlayton@kernel.org>

