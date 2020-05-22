Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC281DF24F
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 00:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbgEVWrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 18:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731223AbgEVWrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 18:47:43 -0400
X-Greylist: delayed 14775 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 May 2020 15:47:42 PDT
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7A1C061A0E;
        Fri, 22 May 2020 15:47:42 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A09F323058;
        Sat, 23 May 2020 00:47:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590187659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ro0g+nfdSzpiSpOPcqJ5ROkYdHy3LEOX64jL+fQHoBg=;
        b=eHp9O03JxajOaJl36Do3Si6ZSb7cH9m87Nzh0+KGeUhvnZM7bULl4v9fkGjzsu56tLmuxt
        aHafxKZIWK2OoqJiIWyrkHL2nKlua+C7AvG+JrVM8YKKIR9ndOQurHUZgxhtaf8XY01rJ3
        9D5bZRQSGTIrcZHP2HQb6k08Ww1OT3A=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 23 May 2020 00:47:39 +0200
From:   Michael Walle <michael@walle.cc>
To:     Saravana Kannan <saravanak@google.com>
Cc:     stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] driver core: Fix SYNC_STATE_ONLY device link
 implementation
In-Reply-To: <CAGETcx85trw=rCM1+dmemMGKstFCq=Nn7HR2fyDyV0rTTQYtEQ@mail.gmail.com>
References: <20200518080327.GA3126260@kroah.com>
 <20200519063000.128819-1-saravanak@google.com>
 <20200522204120.3b3c9ed6@apollo>
 <CAGETcx85trw=rCM1+dmemMGKstFCq=Nn7HR2fyDyV0rTTQYtEQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <41760105c011f9382f4d5fdc9feed017@walle.cc>
X-Sender: michael@walle.cc
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2020-05-23 00:21, schrieb Saravana Kannan:
> On Fri, May 22, 2020 at 11:41 AM Michael Walle <michael@walle.cc> 
> wrote:
>> 
>> Am Mon, 18 May 2020 23:30:00 -0700
>> schrieb Saravana Kannan <saravanak@google.com>:
>> 
>> > When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
>> > core: Add device link support for SYNC_STATE_ONLY flag"),
>> > device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
>> > device link to the supplier's and consumer's "device link" list.
>> >
>> > This causes multiple issues:
>> > - The device link is lost forever from driver core if the caller
>> >   didn't keep track of it (caller typically isn't expected to). This
>> > is a memory leak.
>> > - The device link is also never visible to any other code path after
>> >   device_link_add() returns.
>> >
>> > If we fix the "device link" list handling, that exposes a bunch of
>> > issues.
>> >
>> > 1. The device link "status" state management code rightfully doesn't
>> > handle the case where a DL_FLAG_MANAGED device link exists between a
>> > supplier and consumer, but the consumer manages to probe successfully
>> > before the supplier. The addition of DL_FLAG_SYNC_STATE_ONLY links
>> > break this assumption. This causes device_links_driver_bound() to
>> > throw a warning when this happens.
>> >
>> > Since DL_FLAG_SYNC_STATE_ONLY device links are mainly used for
>> > creating proxy device links for child device dependencies and aren't
>> > useful once the consumer device probes successfully, this patch just
>> > deletes DL_FLAG_SYNC_STATE_ONLY device links once its consumer device
>> > probes. This way, we avoid the warning, free up some memory and avoid
>> > complicating the device links "status" state management code.
>> >
>> > 2. Creating a DL_FLAG_STATELESS device link between two devices that
>> > already have a DL_FLAG_SYNC_STATE_ONLY device link will result in the
>> > DL_FLAG_STATELESS flag not getting set correctly. This patch also
>> > fixes this.
>> >
>> > Lastly, this patch also fixes minor whitespace issues.
>> 
>> My board triggers the
>>   WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
>> 
>> Full bootlog:
[..]

> Thanks for the log and report. I haven't spent too much time thinking
> about this, but can you give this a shot?
> https://lore.kernel.org/lkml/20200520043626.181820-1-saravanak@google.com/

I've already tried that, as this is already in linux-next. Doesn't fix 
it,
though.

-michael
