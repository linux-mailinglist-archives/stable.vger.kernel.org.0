Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087E4390070
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 13:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhEYL7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 07:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28669 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232200AbhEYL7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 07:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621943893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9XqClASc1VgY/Lq5XWzKrqFqoIizQQSNW1Cwkmm2Q/0=;
        b=RjfpyejdnsUNgSYwbLRdKgueg6Hc2HduVZOjByjJgtIr/8hgA4teEKemsY54VZaJ3ZR1q6
        onTqHVDORvaGS8EJb0co7p8s4gFsnkE6D22S6ovYXBk64SRRR6D0y9Na+suQ1lD1S9u3T2
        xoUiXY4tHlmybQDhPzq97R1riGwQ+1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-9X0EvVStOW6IDayaAxYmfQ-1; Tue, 25 May 2021 07:58:11 -0400
X-MC-Unique: 9X0EvVStOW6IDayaAxYmfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DE20801817;
        Tue, 25 May 2021 11:58:10 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB65510016F8;
        Tue, 25 May 2021 11:58:05 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 14PBw524015113;
        Tue, 25 May 2021 07:58:05 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 14PBw5Mo015109;
        Tue, 25 May 2021 07:58:05 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 25 May 2021 07:58:05 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Tokarev <mjt@tls.msk.ru>,
        Mike Snitzer <snitzer@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Patch regression - Re: [PATCH 5.10 070/104] dm snapshot: fix a
 crash when an origin has no snapshots
In-Reply-To: <YKzk/2aqQooFsI28@kroah.com>
Message-ID: <alpine.LRH.2.02.2105250754370.14946@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210524152332.844251980@linuxfoundation.org> <20210524152335.174655194@linuxfoundation.org> <alpine.LRH.2.02.2105250734180.13437@file01.intranet.prod.int.rdu2.redhat.com> <YKzk/2aqQooFsI28@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Tue, 25 May 2021, Greg Kroah-Hartman wrote:

> On Tue, May 25, 2021 at 07:36:57AM -0400, Mikulas Patocka wrote:
> > Hi Greg
> > 
> > I'd like to ask you to drop this patch from all stable branches.
> > 
> > It causes regression with snapshot merging and the regression is much 
> > worse than the bug that it fixes.
> 
> Sure, but is there a fix in Linus's branch for this that I should take
> instead, or is it reverted in linux-next already?
> 
> thanks,
> 
> greg k-h

There is no fix now - but the bug that this fixed is minor (it fixes a 
crash in a configuration that is never set by lvm2) - and the regression 
is major (snapshot merging doesn't work).

I'll work with Mike on reverting it a providing a proper fix.

Mikulas

