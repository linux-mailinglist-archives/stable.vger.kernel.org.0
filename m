Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ACF4516B2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 22:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244671AbhKOVkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 16:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349719AbhKOV2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 16:28:47 -0500
X-Greylist: delayed 527 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Nov 2021 13:10:50 PST
Received: from defensec.nl (markus.defensec.nl [IPv6:2001:985:d55d::123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CA2C04318D
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 13:10:48 -0800 (PST)
Received: from brutus (brutus.lan [IPv6:2001:985:d55d::438])
        by defensec.nl (Postfix) with ESMTPSA id D8B2CFC07DE;
        Mon, 15 Nov 2021 22:01:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=defensec.nl;
        s=default; t=1637010084;
        bh=A6OsKbMGlKs/PRhZow1b3F+L7cUVLjmydEocv5Yo6h0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jUBci85URiGebm0MqE9lhbe/yxUaXoqet6YJBFFDBTc8ffOzUV9vCSYNoAdAwEj/3
         dQz5tMl8ph9HnPpzw/OQzdIxOMLlxEF0wyLNBJ4fADAhhlmPA2X4fH4qLNyOueVryJ
         4s4M9k1sSulivKzN2o+aMV6K4LJewC4I2ZFKfg3g=
From:   Dominick Grift <dominick.grift@defensec.nl>
To:     Alistair Delva <adelva@google.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
References: <20211115173850.3598768-1-adelva@google.com>
        <CAFqZXNvVHv8Oje-WV6MWMF96kpR6epTsbc-jv-JF+YJw=55i1w@mail.gmail.com>
        <CANDihLEFZAz8DwkkMGiDJnDMjxiUuSCanYsJtkRwa9RoyruLFA@mail.gmail.com>
Date:   Mon, 15 Nov 2021 22:01:23 +0100
In-Reply-To: <CANDihLEFZAz8DwkkMGiDJnDMjxiUuSCanYsJtkRwa9RoyruLFA@mail.gmail.com>
        (Alistair Delva's message of "Mon, 15 Nov 2021 11:08:48 -0800")
Message-ID: <87sfvxp1zw.fsf@defensec.nl>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alistair Delva <adelva@google.com> writes:

> On Mon, Nov 15, 2021 at 11:04 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>>
>> On Mon, Nov 15, 2021 at 7:14 PM Alistair Delva <adelva@google.com> wrote:
>> > Booting to Android userspace on 5.14 or newer triggers the following
>> > SELinux denial:
>> >
>> > avc: denied { sys_nice } for comm="init" capability=23
>> >      scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
>> >      permissive=0
>> >
>> > Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
>> > better compatibility with older SEPolicy, check ADMIN before NICE.
>>
>> But with this patch you in turn punish the new/better policies that
>> try to avoid giving domains CAP_SYS_ADMIN unless necessary (using only
>> the more granular capabilities wherever possible), which may now get a
>> bogus sys_admin denial. IMHO the order is better as it is, as it
>> motivates the "good" policy writing behavior - i.e. spelling out the
>> capability permissions more explicitly and avoiding CAP_SYS_ADMIN.
>>
>> IOW, if you domain does CAP_SYS_NICE things, and you didn't explicitly
>> grant it that (and instead rely on the CAP_SYS_ADMIN fallback), then
>> the denial correctly flags it as an issue in your policy and
>> encourages you to add that sys_nice permission to the domain. Then
>> when one beautiful hypothetical day the CAP_SYS_ADMIN fallback is
>> removed, your policy will be ready for that and things will keep
>> working.
>>
>> Feel free to carry that patch downstream if patching the kernel is
>> easier for you than fixing the policy, but for the upstream kernel
>> this is just a step in the wrong direction.
>
> I'm personally fine with this position, but I am curious why "never
> break userspace" doesn't apply to SELinux policies. At the end of the
> day, booting 5.13 or older, we don't get a denial, and there's nothing
> for the sysadmin to do. On 5.14 and newer, we get denials. This is a
> common pattern we see each year: some new capability or permission is
> required where it wasn't required before, and there's no compatibility
> mechanism to grandfather in old policies. So, we have to touch
> userspace. If this is just how things are, I can certainly update our
> init.te definitions.

User space is not broken? If you just ignore this AVC denial then it
will pass on cap_sys_admin. In other words everything still works, you
only get a AVC denial for cap_sys_nice now.

>
>> > Fixes: 9d3a39a5f1e4 ("block: grant IOPRIO_CLASS_RT to CAP_SYS_NICE")
>> > Signed-off-by: Alistair Delva <adelva@google.com>
>> > Cc: Khazhismel Kumykov <khazhy@google.com>
>> > Cc: Bart Van Assche <bvanassche@acm.org>
>> > Cc: Serge Hallyn <serge@hallyn.com>
>> > Cc: Jens Axboe <axboe@kernel.dk>
>> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > Cc: Paul Moore <paul@paul-moore.com>
>> > Cc: selinux@vger.kernel.org
>> > Cc: linux-security-module@vger.kernel.org
>> > Cc: kernel-team@android.com
>> > Cc: stable@vger.kernel.org # v5.14+
>> > ---
>> >  block/ioprio.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/block/ioprio.c b/block/ioprio.c
>> > index 0e4ff245f2bf..4d59c559e057 100644
>> > --- a/block/ioprio.c
>> > +++ b/block/ioprio.c
>> > @@ -69,7 +69,7 @@ int ioprio_check_cap(int ioprio)
>> >
>> >         switch (class) {
>> >                 case IOPRIO_CLASS_RT:
>> > -                       if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
>> > +                       if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
>> >                                 return -EPERM;
>> >                         fallthrough;
>> >                         /* rt has prio field too */
>> > --
>> > 2.34.0.rc1.387.gb447b232ab-goog
>> >
>>
>> --
>> Ondrej Mosnacek
>> Software Engineer, Linux Security - SELinux kernel
>> Red Hat, Inc.
>>

-- 
gpg --locate-keys dominick.grift@defensec.nl
Key fingerprint = FCD2 3660 5D6B 9D27 7FC6  E0FF DA7E 521F 10F6 4098
Dominick Grift
