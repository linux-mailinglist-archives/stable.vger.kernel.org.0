Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F23CA3323
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 10:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfH3IxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 04:53:04 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33018 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfH3IxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Aug 2019 04:53:04 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i3ceU-0001rQ-4I; Fri, 30 Aug 2019 10:53:02 +0200
Message-ID: <5dc694c33759a32eb3796668a8b396c0133e1ebe.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Purge frame registrations on iftype change
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Fri, 30 Aug 2019 10:53:01 +0200
In-Reply-To: <20190828211110.15005-1-denkenz@gmail.com> (sfid-20190828_231636_661927_AAE3C4AB)
References: <20190828211110.15005-1-denkenz@gmail.com>
         (sfid-20190828_231636_661927_AAE3C4AB)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-08-28 at 16:11 -0500, Denis Kenzior wrote:
> Currently frame registrations are not purged, even when changing the
> interface type.  This can lead to potentially weird / dangerous
> situations where frames possibly not relevant to a given interface
> type remain registered and mgmt_frame_register is not called for the
> no-longer-relevant frame types.

I'd argue really just "weird and non-working", hardly dangerous. Even in
the mac80211 design where we want to not let you intercept e.g. AUTH
frames in client mode - if you did, then you'd just end up with a non-
working interface. Not sure I see any "dangerous situation". Not really
an all that important distinction though.

Depending on the design, it may also just be that those registrations
are *ignored*, because e.g. firmware intercepts the AUTH frame already,
which would just (maybe) confuse userspace - but that seems unlikely
since it switched interface type and has no real need for those frames
then.

> The kernel currently relies on userspace apps to actually purge the
> registrations themselves, e.g. by closing the nl80211 socket associated
> with those frames.  However, this requires multiple nl80211 sockets to
> be open by the userspace app, and for userspace to be aware of all state
> changes.  This is not something that the kernel should rely on.

I tend to agree with that the kernel shouldn't rely on it.

> This commit adds a call to cfg80211_mlme_purge_registrations() to
> forcefully remove any registrations left over prior to switching the
> iftype.

However, I do wonder if we should make this more transactional, and hang
on to them if the type switching fails. We're not notifying userspace
that the registrations have disappeared, so if type switching fails and
it continues to work with the old type rather than throwing its hands up
and quitting or something, it'd make a possibly bigger mess to just
silently have removed them already.

I *think* it should be safe to just move this after the switching
succeeds, since the switching can pretty much only be done at a point
where nothing is happening on the interface anyway, though that might
confuse the driver when the remove happens.

Also, perhaps it'd be better to actually hang on to those registrations
that *are* still possible afterwards? But to not confuse the driver I
guess that might require unregister/re-register to happen, all of which
requires hanging on to the list and going through it after the type
switch completed?

What do you think?

johannes

