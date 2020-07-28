Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD1622FE76
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 02:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgG1AYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 20:24:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48002 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726196AbgG1AYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 20:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595895861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qrrh0VWxhUYOFWXxBgOdHjYFk6pK4h+BN24GbsiZyec=;
        b=d9BzcXSk3Q4kf22BCqo/tEBJg5oEWo7zVksLX5TFwSEpI878hCXuPJ8HXJAHHdeOmlvO3M
        H4khVpLUDnLuOf2OiEjPIyOehE5PPFPw8ohoygnSMnAeogeA+N2q2hjgsrdbTbSGUxf6fY
        ixCzIqE8xowPmN+M8eYGN6aX3tBVc9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-2Lh-TjSvPJ69YeoO6jxvfw-1; Mon, 27 Jul 2020 20:24:18 -0400
X-MC-Unique: 2Lh-TjSvPJ69YeoO6jxvfw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B49928005B0;
        Tue, 28 Jul 2020 00:24:17 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F5FB5D9E8;
        Tue, 28 Jul 2020 00:24:17 +0000 (UTC)
Date:   Mon, 27 Jul 2020 20:24:16 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 84/86] dm integrity: fix integrity recalculation
 that is improperly skipped
Message-ID: <20200728002416.GB28830@redhat.com>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134918.614819996@linuxfoundation.org>
 <20200727205635.t23z72lkdofoewi3@duo.ucw.cz>
 <20200727233135.GL406581@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727233135.GL406581@sasha-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27 2020 at  7:31pm -0400,
Sasha Levin <sashal@kernel.org> wrote:

> On Mon, Jul 27, 2020 at 10:56:35PM +0200, Pavel Machek wrote:
> >Hi!
> >
> >>From: Mikulas Patocka <mpatocka@redhat.com>
> >>
> >>commit 5df96f2b9f58a5d2dc1f30fe7de75e197f2c25f2 upstream.
> >>
> >>Commit adc0daad366b62ca1bce3e2958a40b0b71a8b8b3 ("dm: report suspended
> >>device during destroy") broke integrity recalculation.
> >>
> >>The problem is dm_suspended() returns true not only during suspend,
> >>but also during resume. So this race condition could occur:
> >>1. dm_integrity_resume calls queue_work(ic->recalc_wq, &ic->recalc_work)
> >>2. integrity_recalc (&ic->recalc_work) preempts the current thread
> >>3. integrity_recalc calls if (unlikely(dm_suspended(ic->ti))) goto unlock_ret;
> >>4. integrity_recalc exits and no recalculating is done.
> >>
> >>To fix this race condition, add a function dm_post_suspending that is
> >>only true during the postsuspend phase and use it instead of
> >>dm_suspended().
> >>
> >>Signed-off-by: Mikulas Patocka <mpatocka redhat com>
> >
> >Something is wrong with signoff here...
> 
> Heh, and the same thing happened with the stable tag:
> 
> 	Cc: stable vger kernel org # v4.18+
> 
> But given that this is the way the upstream commit looks like we can't
> do much here.

Hmm, not sure what happened on the Signed-off-by and Cc for commit
5df96f2b9f.  Sorry about this!

