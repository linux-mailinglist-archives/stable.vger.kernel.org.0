Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5999A3A56
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 17:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfH3P2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 11:28:39 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38454 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbfH3P2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Aug 2019 11:28:39 -0400
Received: by mail-oi1-f195.google.com with SMTP id q8so5643545oij.5;
        Fri, 30 Aug 2019 08:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B1Q2BqumoNYvk6WifGnz+xcHOHCiOCp5B9d79WQzBHw=;
        b=DSrpRbP9d1acU3QmYWdquMKUpCXPywUvix1xGhVDgmjCgb+izHQsHFo6/yBa89Lks4
         zmAqJmihePVxZyJWC/gHN4vwDZSZzvnKTqzrk8ktU9Cis4Uefwa86eItITg31BpMXey6
         4bU8xarFXwBEKrVKLYEpUs5ufnJy/8gvIb38TdTrnb/npMcuYzhZn8E1IYch/+ePq10Y
         H9DiVtFkyCr0yCWQScdh9aJxSkquVU/cZXuLQ/Tm3Kz/P07yaWOcoOW4Qk/hqk9IRVI8
         lXlc+TUVfW/9rw1GKFsITTWApyDP6p/yrmlLNLSKvUXj7OF1ZS45R310At2aQ43D0K6e
         FtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B1Q2BqumoNYvk6WifGnz+xcHOHCiOCp5B9d79WQzBHw=;
        b=rb1Iv+Lb46CWUOqlsrsT4cyPUtFbnHP+gO4EX6g3MEC9RK/vWD67NMLBDW46Lk2GFT
         AM36n2r4Z8b/w7f3EVMqLMeYOpEDhpiQijcK3QKBHI1shbZB+S2bpYHq9Nk52I6HwUPK
         eBSXHib9Th8zwNikkYtTJDCLq6ezGJjfQVcRi54/u/XbrO9rpDyV+7Nlj81Usc5FbH7t
         5AuPeJArorUdYlMzkFX7IA29p4xe4ZYN98nJa0m6Sd6vlrJvQJilWlRtusFyfmiV/JWN
         xmfYv2qFC4zN0kQHP/ti14lwZbMuR7wzSQMfnyZDMwWH11/fYpIWJ6kYh2Dn9584uj5z
         0RSA==
X-Gm-Message-State: APjAAAUwnF3B/9QrilODDI2w+h+JgR8W3bbu87VO+v9hIXnjHHa9cPKp
        6v1q3Dhrin7bTt2clC6ElnM673TS
X-Google-Smtp-Source: APXvYqwMr23LibC2oi1ZhG0hihkBcEjgMgsg2+G4j4Lo4GTM/hXFHRdhmPQ0XCL6FMV/kzyRUX0YDg==
X-Received: by 2002:a05:6808:2c1:: with SMTP id a1mr1713813oid.124.1567178917888;
        Fri, 30 Aug 2019 08:28:37 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id o11sm1582620oti.7.2019.08.30.08.28.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:28:37 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Purge frame registrations on iftype change
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20190828211110.15005-1-denkenz@gmail.com>
 <5dc694c33759a32eb3796668a8b396c0133e1ebe.camel@sipsolutions.net>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <bb8d43d2-8383-1f7c-94f8-feecc29240f3@gmail.com>
Date:   Fri, 30 Aug 2019 01:32:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5dc694c33759a32eb3796668a8b396c0133e1ebe.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johannes,

On 8/30/19 3:53 AM, Johannes Berg wrote:
> On Wed, 2019-08-28 at 16:11 -0500, Denis Kenzior wrote:
>> Currently frame registrations are not purged, even when changing the
>> interface type.  This can lead to potentially weird / dangerous
>> situations where frames possibly not relevant to a given interface
>> type remain registered and mgmt_frame_register is not called for the
>> no-longer-relevant frame types.
> 
> I'd argue really just "weird and non-working", hardly dangerous. Even in
> the mac80211 design where we want to not let you intercept e.g. AUTH
> frames in client mode - if you did, then you'd just end up with a non-
> working interface. Not sure I see any "dangerous situation". Not really
> an all that important distinction though.

Fair enough, I'm happy to drop / reword this language.  It seemed fishy 
to me since the unregistration operation was not called at all, and the 
driver does go to some lengths to set up the valid frame registration 
types.

> 
> Depending on the design, it may also just be that those registrations
> are *ignored*, because e.g. firmware intercepts the AUTH frame already,
> which would just (maybe) confuse userspace - but that seems unlikely
> since it switched interface type and has no real need for those frames
> then.

There might be corner cases where userspace gets confused and doesn't 
update the frame registrations properly.  For example, wpa_s/hostap does 
not listen to SET_INTERFACE events that I can tell.  So if some external 
app sets the mode (particularly on a 'live' interface) then all kinds of 
unexpected things might happen.  This is one of the motivations for 
restricting certain NL80211 commands to interface SOCKET_OWNER.

So really this patch is intended more as a hot-fix / backport to stable 
to make sure the older kernels can deal with some of these situations.

> 
>> The kernel currently relies on userspace apps to actually purge the
>> registrations themselves, e.g. by closing the nl80211 socket associated
>> with those frames.  However, this requires multiple nl80211 sockets to
>> be open by the userspace app, and for userspace to be aware of all state
>> changes.  This is not something that the kernel should rely on.
> 
> I tend to agree with that the kernel shouldn't rely on it.
> 
>> This commit adds a call to cfg80211_mlme_purge_registrations() to
>> forcefully remove any registrations left over prior to switching the
>> iftype.
> 
> However, I do wonder if we should make this more transactional, and hang
> on to them if the type switching fails. We're not notifying userspace
> that the registrations have disappeared, so if type switching fails and
> it continues to work with the old type rather than throwing its hands up
> and quitting or something, it'd make a possibly bigger mess to just
> silently have removed them already.

I do like that idea, not sure how to go about implementing it though? 
The failure case is a bit hard to deal with.  Something like 
NL80211_EXT_FEATURE_LIVE_IFTYPE_CHANGE would help, particularly if 
nl80211/cfg80211 actually checked it prior to doing anything (e.g. 
disconnecting, etc).  That would then take care of the majority of the 
'typical' failure paths.  I didn't add such checking in the other patch 
set since I felt you might find it overly intrusive on userspace.  But 
maybe we really should do this?

So playing devil's advocate, another argument might be that by the time 
we got here, we've already tore down a bunch of state.  E.g. 
disconnected the station, stopped AP, etc.  So we've already 
side-effected state in a bunch of ways, what's one more?

> 
> I *think* it should be safe to just move this after the switching
> succeeds, since the switching can pretty much only be done at a point
> where nothing is happening on the interface anyway, though that might
> confuse the driver when the remove happens.
> 

I would concur as that is what happens today.  But should it?

> Also, perhaps it'd be better to actually hang on to those registrations
> that *are* still possible afterwards? But to not confuse the driver I
> guess that might require unregister/re-register to happen, all of which
> requires hanging on to the list and going through it after the type
> switch completed?

Yes, I had those exact thoughts as well.

It isn't currently clear to me if there are any guarantees on the driver 
operation call sequence that cfg80211 provides.  E.g. can the driver 
expect rdev_change_virtual_intf to be called only once all the old 
registrations are purged and the new registrations are performed after 
the fact?  Or should it expect things to just happen in any order?

> 
> What do you think?
> 

A big part of me thinks that just wiping the slate clean and having 
userspace set it up from scratch isn't that much to ask and it might 
want to do that anyway.  It might (a big maybe?) also make the driver's 
life easier if it can rely on certain guarantees from cfg80211.  E.g. 
that all invalid registrations are purged.

I have seen wpa_s perform a bunch of register commands which bounce off 
with an -EALREADY.  So it may already be erring on the side of caution 
and assuming that it needs to reset the state fully?  Not sure.

But if the kernel wants to be nice and spends some cycles figuring out 
which frame registrations to keep and re-register them, that is also 
fine with me.

Regards,
-Denis
