Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF49314331A
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 21:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgATU4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 15:56:03 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53608 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726586AbgATU4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 15:56:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579553761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wv/Fjk78GKCs8CouSMuVcVYhTpS0P1OVpV9pRb50wH8=;
        b=DrlzpDD3YTapuCP5Er/U7RQ9SWyCVj7KM5hqf3tI2yCZGjX4L2pufG8/asZhadKtlHe+db
        HULDkl8YwcUJh03w5+nWZ89pD4ZwncwEdL+Ynce4NFlA073vgSbPaR3SSyRCRsfmKql6zP
        DM+JLACGiPMIoQpytWRonMzdIJD8Trw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-WzxAsMgcNBKS3U-_JioN3w-1; Mon, 20 Jan 2020 15:55:57 -0500
X-MC-Unique: WzxAsMgcNBKS3U-_JioN3w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84019107ACCA;
        Mon, 20 Jan 2020 20:55:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B7475D9C5;
        Mon, 20 Jan 2020 20:55:56 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id F1E9E503A4;
        Mon, 20 Jan 2020 20:55:55 +0000 (UTC)
Date:   Mon, 20 Jan 2020 15:55:55 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     Cyril Hrubis <chrubis@suse.cz>
Cc:     Rachel Sibley <rasibley@redhat.com>, Jianwen Ji <jiji@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Message-ID: <270741803.2885047.1579553755871.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200116153741.GA558@rei>
References: <cki.FA900DB853.LBD049H627@redhat.com> <84944fa0-3c18-f8a4-47ca-7627eb4e0594@redhat.com> <20200116153741.GA558@rei>
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.4.13-rc1-7f1b863.cki
 (stable)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.17.25, 10.4.195.2]
Thread-Topic: ??? FAIL: Test report for kernel 5.4.13-rc1-7f1b863.cki (stable)
Thread-Index: Nvu5TPY5hzSZxc/NJ6UqtiNI5lAyWw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> Hi!
> > > One or more kernel tests failed:
> > > 
> > >      ppc64le:
> > >       ??? LTP
> > 
> > Hi, I see max_map_count failed on ppc64le:
> > https://artifacts.cki-project.org/pipelines/385189/logs/ppc64le_host_2_LTP_mm.run.log
> 
> That's strange, we do attempt to map 65536 mappings but we do not touch
> them, so these shouldn't be faulted in, so there is no real reason why
> mmap() in the child process should stop prematurely at 65532.
> 

We do not touch them, but the test is setting OVERCOMMIT_NEVER since ~2012.
It tries to estimate number of pages that can be used with global CommitLimit
and Committed_AS.

But we sporadically fail at __vm_enough_memory() on a percpu counter:
... 
        if (percpu_counter_read_positive(&vm_committed_as) < allowed)
                return 0;
which can be presumably increased by anything else running on system.

Comments say this is to avoid certain bad OOM behaviour, but given its age,
it might be long invalid.

Regards,
Jan





