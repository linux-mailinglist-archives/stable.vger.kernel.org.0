Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4664C3046FC
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 19:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbhAZRRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 12:17:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:37182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbhAZHEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 02:04:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95337AD4E;
        Tue, 26 Jan 2021 07:03:17 +0000 (UTC)
Date:   Mon, 25 Jan 2021 23:03:11 -0800
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     dsterba@suse.cz, Su Yue <l@damenly.su>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Erhard F <erhard_f@mailbox.org>, dave@stgolabs.net
Subject: Re: [PATCH] btrfs: fix lockdep warning due to seqcount_mutex_init()
 with wrong address
Message-ID: <20210126070311.wusdu3sfi6ywdrzb@offworld>
References: <20210121113910.14681-1-l@damenly.su>
 <20210121170756.GE6430@twin.jikos.cz>
 <h7n9tvwl.fsf@damenly.su>
 <20210125165346.GM1993@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210125165346.GM1993@twin.jikos.cz>
User-Agent: NeoMutt/20201120
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Jan 2021, David Sterba wrote:

>IMO it's not, though some kind of annotation could be useful. The patch
>introducing the seqcount mutex does not mention any warning so it's
>probably meant only for clarity of the lock nesting or maybe real-time
>related as there are some comments regarding that in seqlock.h.

That lockdep_assert_held() is just to verify the writer side is properly
serialized. The real-time aspects here does not apply in that the mutex
is always preemptible.

>
>Even for a dynamic allocation we'd need a way to synchronize setting the
>variable, it could be possible, but the lockdep report needs to be
>fixed. Right now I don't see another way than the revert.

Agreed, let's revert this until a proper workaround is found.

Thanks,
Davidlohr
