Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44ABAF980
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfIKJvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:51:43 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34792 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKJvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 05:51:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i7zHm-0003Eu-Q0; Wed, 11 Sep 2019 11:51:38 +0200
Message-ID: <ea9a895d18a34b876c440e6272b1d55d27c8a419.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Purge frame registrations on iftype change
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Wed, 11 Sep 2019 11:51:37 +0200
In-Reply-To: <bb8d43d2-8383-1f7c-94f8-feecc29240f3@gmail.com> (sfid-20190830_172839_535654_F8184AE6)
References: <20190828211110.15005-1-denkenz@gmail.com>
         <5dc694c33759a32eb3796668a8b396c0133e1ebe.camel@sipsolutions.net>
         <bb8d43d2-8383-1f7c-94f8-feecc29240f3@gmail.com>
         (sfid-20190830_172839_535654_F8184AE6)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, 2019-08-30 at 01:32 -0500, Denis Kenzior wrote:
> Hi Johannes,
> 
> On 8/30/19 3:53 AM, Johannes Berg wrote:
> > On Wed, 2019-08-28 at 16:11 -0500, Denis Kenzior wrote:
> > > Currently frame registrations are not purged, even when changing the
> > > interface type.  This can lead to potentially weird / dangerous
> > > situations where frames possibly not relevant to a given interface
> > > type remain registered and mgmt_frame_register is not called for the
> > > no-longer-relevant frame types.
> > 
> > I'd argue really just "weird and non-working", hardly dangerous. 

I think I may just have found a way that's sort of "dangerous" in the
sense of breaking all of our tests, but hey.

> > Even in
> > the mac80211 design where we want to not let you intercept e.g. AUTH
> > frames in client mode - if you did, then you'd just end up with a non-
> > working interface. Not sure I see any "dangerous situation". Not really
> > an all that important distinction though.
> 
> Fair enough, I'm happy to drop / reword this language.  It seemed fishy 
> to me since the unregistration operation was not called at all, and the 
> driver does go to some lengths to set up the valid frame registration 
> types.

Sure.

> > However, I do wonder if we should make this more transactional, and hang
> > on to them if the type switching fails. We're not notifying userspace
> > that the registrations have disappeared, so if type switching fails and
> > it continues to work with the old type rather than throwing its hands up
> > and quitting or something, it'd make a possibly bigger mess to just
> > silently have removed them already.
> 
> I do like that idea, not sure how to go about implementing it though? 
> The failure case is a bit hard to deal with.  Something like 
> NL80211_EXT_FEATURE_LIVE_IFTYPE_CHANGE would help, particularly if 
> nl80211/cfg80211 actually checked it prior to doing anything (e.g. 
> disconnecting, etc).  That would then take care of the majority of the 
> 'typical' failure paths.  I didn't add such checking in the other patch 
> set since I felt you might find it overly intrusive on userspace.  But 
> maybe we really should do this?

As I just said on the other patch, I think we probably should do that
there, if just to be able to advertise a correct set of interface types
that you can switch between there. I don't see how it'd be more
intrusive to userspace than failing later? :-)

> So playing devil's advocate, another argument might be that by the time 
> we got here, we've already tore down a bunch of state.  E.g. 
> disconnected the station, stopped AP, etc.  So we've already 
> side-effected state in a bunch of ways, what's one more?

True, fair point.

> > I *think* it should be safe to just move this after the switching
> > succeeds, since the switching can pretty much only be done at a point
> > where nothing is happening on the interface anyway, though that might
> > confuse the driver when the remove happens.
> > 
> 
> I would concur as that is what happens today.  But should it?

Well, dunno, what should happen? If you ask drivers they might want to
remove & re-register after, for those registrations that are still
possible.

> It isn't currently clear to me if there are any guarantees on the driver 
> operation call sequence that cfg80211 provides.  E.g. can the driver 
> expect rdev_change_virtual_intf to be called only once all the old 
> registrations are purged and the new registrations are performed after 
> the fact?  Or should it expect things to just happen in any order?

Well, evidently it cannot rely on anything today, and for the most part
I guess this is implemented in the software paths where it doesn't
really matter (the same way that mac80211 implements it).

But it probably should be defined better.

> > What do you think?
> > 
> 
> A big part of me thinks that just wiping the slate clean and having 
> userspace set it up from scratch isn't that much to ask and it might 
> want to do that anyway.  It might (a big maybe?) also make the driver's 
> life easier if it can rely on certain guarantees from cfg80211.  E.g. 
> that all invalid registrations are purged.

Yeah, fair point.

> I have seen wpa_s perform a bunch of register commands which bounce off 
> with an -EALREADY.  So it may already be erring on the side of caution 
> and assuming that it needs to reset the state fully?  Not sure.

I'm pretty sure that it does in fact go through a full reset (re-setup)
after switching things around.

> But if the kernel wants to be nice and spends some cycles figuring out 
> which frame registrations to keep and re-register them, that is also 
> fine with me.

Let's not then.

I've applied this patch now.

johannes

