Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41CF4A5BE9
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 13:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbiBAMKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 07:10:52 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59134 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237799AbiBAMKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 07:10:51 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 739D6212CC;
        Tue,  1 Feb 2022 12:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643717450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u81yjtGgwbF764LyCgpsfndB5V+V815DjFHEVDCtnLk=;
        b=gOTYVS85sYoQl61zNk8ZPC6pAokZuK2Dx+EIIepx2g7fHcUNYuGWmgeYr3dnYXM24BmPe9
        +CdVFfiqf/L5o9jExG1tHnHhmQeJmN/vHo4evxcxs9ef5LmimGnb01OaxodO3armhAL7Vp
        p8xfHfsb4Sj1cJbBDMgTdSvXfiKBxvk=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5BBFDA3B8B;
        Tue,  1 Feb 2022 12:10:50 +0000 (UTC)
Date:   Tue, 1 Feb 2022 13:10:50 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v1] drivers/base/memory: add memory block to memory group
 after registration succeeded
Message-ID: <YfkjSj59otaREsfi@dhcp22.suse.cz>
References: <20220128144540.153902-1-david@redhat.com>
 <20220131170123.42d7f46ecea0da1cb1579113@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131170123.42d7f46ecea0da1cb1579113@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 31-01-22 17:01:23, Andrew Morton wrote:
> On Fri, 28 Jan 2022 15:45:40 +0100 David Hildenbrand <david@redhat.com> wrote:
> 
> > If register_memory() fails, we freed the memory block but already added
> > the memory block to the group list, not good. Let's defer adding the
> > block to the memory group to after registering the memory block device.
> > 
> > We do handle it properly during unregister_memory(), but that's not
> > called when the registration fails.
> > 
> 
> I guess this has never been known to happen.  So I queued the fix for
> 5.18-rc1, cc:stable.

I do not think this is worth stable backporting. Chances of a failure
are pretty small and I am not aware of any existing report.

-- 
Michal Hocko
SUSE Labs
