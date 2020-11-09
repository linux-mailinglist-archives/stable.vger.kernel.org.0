Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C4B2AB76B
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 12:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgKILo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 06:44:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58560 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727311AbgKILo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 06:44:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604922267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h6TYroRXtCD628XhupjpJPqcGpnszR5hhlavErGBPkk=;
        b=fY4a8QiMplWZTRVh9/E6s/PQpjJ5fLmPsXleEEcZtJqdpAn1ele60zxiBnm09xhmd7Od15
        NcdFe8mdIzswVeValuaOx5pGWAVMSWW3dAn5VozfNzCu4/gd5m6Aj1oI25uHdzqQ4NOJAL
        nzcnHe9HZkFcFt5gj3DxokaioFsYPeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-K7_EuLKJNACMG2lfTf7Yrg-1; Mon, 09 Nov 2020 06:44:25 -0500
X-MC-Unique: K7_EuLKJNACMG2lfTf7Yrg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 649D1188C122;
        Mon,  9 Nov 2020 11:44:24 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.116])
        by smtp.corp.redhat.com (Postfix) with SMTP id 694EA60DA0;
        Mon,  9 Nov 2020 11:44:23 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon,  9 Nov 2020 12:44:24 +0100 (CET)
Date:   Mon, 9 Nov 2020 12:44:22 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [PATCH] fork: fix copy_process(CLONE_PARENT) race with the
 exiting ->real_parent
Message-ID: <20201109114421.GA30446@redhat.com>
References: <20201107064722.GA139215@arch-e3.localdomain>
 <CAHk-=whjyOuO-xwov7UWidBOkWyZv84TVA18hBb01V-hiML+yg@mail.gmail.com>
 <CAHk-=wgukcYn0xpqJ+Vda1Zw9wxPCxV0L_ZX6AmpgapT9Lp2mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgukcYn0xpqJ+Vda1Zw9wxPCxV0L_ZX6AmpgapT9Lp2mw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/08, Linus Torvalds wrote:
>
> But it does look like a real data race, and the fix looks small and
> obvious enough that I think it's stable material.

Agreed, the patch looks fine for -stable. I don't think that
cgroup_can_fork() could ever use thread_group_leader() or anything
else which checks ->exit_code...

And I see that Greg has already sent the patches with the correct
modifications for the case when we need "clone_flags & CSIGNAL"
rather than args->exit_signal.

Thanks Greg,

Oleg.

