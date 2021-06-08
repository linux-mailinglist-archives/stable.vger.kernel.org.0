Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3113A0499
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhFHTpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbhFHToq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 15:44:46 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847A7C061574;
        Tue,  8 Jun 2021 12:39:19 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id b9so20969835ilr.2;
        Tue, 08 Jun 2021 12:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HJ8rnWqOEbeNiQiIKCMICozUoicUYyenJT1hlLOu16o=;
        b=b69NKJPlTlavMBJWWeaGIAN3zvAy7MACAIF5OyJUifBFnHsqtyfYkbl4pIvaOh0+Kg
         E/3RB1vlGyz3A2E7mt2JCJGe2oPA1lgIMT5svPoX57sSeFOIGcp0bp6MtsNrElTnBK29
         z/8llJcLB0V21tn3WJVBQ24D2XwVF5d4QaI50noBRZQ0PEuS5TcqRJ8ZBK+GPH9WJvQV
         2cBHH1u4etkWhDxMZbuhhpRwWtR+Tyd/p0VS/hgT/ZsdWWmaxTngVW5eMVuPtYUvBmUe
         JEEw/Nzwk5QAWU+pC8ywVrC3TgA23XhkLtltD3eIMSmDMMbEk9NZOrLdAfzJw4jiB9Kp
         9Qjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HJ8rnWqOEbeNiQiIKCMICozUoicUYyenJT1hlLOu16o=;
        b=uFcetPp/pw53kBKhM4OMKkopvpS2jCcFRIpB75K52IBZ0vKm0kF/mGhamZL/DTKxtf
         iMYkF9S1iUfZTNsDXchfm8dCeUKDDR0J2XAm3KOF3Fa6tx1T7pB64s/QPtgyhlwCGQI6
         rZxHKXv4NpQW/LfZOl5CkKbAqIoXBImqisImF52QhVxikBDyPnKaobB1OQKXj11scWq1
         HSc8mMjC0DTYFKMGUyCcBlUYPxMOBpTA42NNjC1DJtq6IHhNFr6WCwsGUXsh3Ls8jVRm
         9Vgz6zDTV7gKMNMp/8xmUxdLBKs+MU3+rVLH2yPC4smtZw4s/NIoLChX7yAijTdDlkqx
         LwMA==
X-Gm-Message-State: AOAM5337UKM6zRsa90mU7EUZGlbbjeTpThxwx4JW5Gkpk07zsycBFd2B
        A3bdQceZ+Hu+gFfAl9GhkzsUbVSYkRYwXpjblqWLYulztinq8w==
X-Google-Smtp-Source: ABdhPJx/ZlF2j/TPT9ioskBU5uYfBA+Oum4w1kJBYw2i4wbX6xIhatZJbYM9t3lCQdzd4b+tE1tvOob2pa8xznJfx3U=
X-Received: by 2002:a6b:287:: with SMTP id 129mr16340585ioc.182.1623181158977;
 Tue, 08 Jun 2021 12:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210608175945.476074951@linuxfoundation.org> <20210608175948.243493420@linuxfoundation.org>
 <CAOi1vP-B4A4bmd=ZbnwqEa14BizN-X8V4ktUMWGuEtXu8n2y-g@mail.gmail.com> <YL/D5ecAFFyPBXDF@sashalap>
In-Reply-To: <YL/D5ecAFFyPBXDF@sashalap>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 8 Jun 2021 21:39:18 +0200
Message-ID: <CAOi1vP9xOd+CfgjifZA6YecwkGT+E6H7TP=X9hsUtNW4_s7dGg@mail.gmail.com>
Subject: Re: [PATCH 5.12 083/161] libceph: dont set global_id until we get an
 auth ticket
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 8, 2021 at 9:24 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Jun 08, 2021 at 09:07:18PM +0200, Ilya Dryomov wrote:
> >On Tue, Jun 8, 2021 at 8:48 PM Greg Kroah-Hartman
> ><gregkh@linuxfoundation.org> wrote:
> >>
> >> From: Ilya Dryomov <idryomov@gmail.com>
> >>
> >> [ Upstream commit 61ca49a9105faefa003b37542cebad8722f8ae22 ]
> >>
> >> With the introduction of enforcing mode, setting global_id as soon
> >> as we get it in the first MAuth reply will result in EACCES if the
> >> connection is reset before we get the second MAuth reply containing
> >> an auth ticket -- because on retry we would attempt to reclaim that
> >> global_id with no auth ticket at hand.
> >>
> >> Neither ceph_auth_client nor ceph_mon_client depend on global_id
> >> being set ealy, so just delay the setting until we get and process
> >> the second MAuth reply.  While at it, complain if the monitor sends
> >> a zero global_id or changes our global_id as the session is likely
> >> to fail after that.
> >>
> >> Cc: stable@vger.kernel.org # needs backporting for < 5.11
> >> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> >> Reviewed-by: Sage Weil <sage@redhat.com>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> ---
> >>  net/ceph/auth.c | 36 +++++++++++++++++++++++-------------
> >>  1 file changed, 23 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/net/ceph/auth.c b/net/ceph/auth.c
> >> index eb261aa5fe18..de407e8feb97 100644
> >> --- a/net/ceph/auth.c
> >> +++ b/net/ceph/auth.c
> >> @@ -36,6 +36,20 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
> >>         }
> >>  }
> >>
> >> +static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
> >> +{
> >> +       dout("%s global_id %llu\n", __func__, global_id);
> >> +
> >> +       if (!global_id)
> >> +               pr_err("got zero global_id\n");
> >> +
> >> +       if (ac->global_id && global_id != ac->global_id)
> >> +               pr_err("global_id changed from %llu to %llu\n", ac->global_id,
> >> +                      global_id);
> >> +
> >> +       ac->global_id = global_id;
> >> +}
> >> +
> >>  /*
> >>   * setup, teardown.
> >>   */
> >> @@ -222,11 +236,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
> >>
> >>         payload_end = payload + payload_len;
> >>
> >> -       if (global_id && ac->global_id != global_id) {
> >> -               dout(" set global_id %lld -> %lld\n", ac->global_id, global_id);
> >> -               ac->global_id = global_id;
> >> -       }
> >> -
> >>         if (ac->negotiating) {
> >>                 /* server does not support our protocols? */
> >>                 if (!protocol && result < 0) {
> >> @@ -253,11 +262,16 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
> >>
> >>         ret = ac->ops->handle_reply(ac, result, payload, payload_end,
> >>                                     NULL, NULL, NULL, NULL);
> >> -       if (ret == -EAGAIN)
> >> +       if (ret == -EAGAIN) {
> >>                 ret = build_request(ac, true, reply_buf, reply_len);
> >> -       else if (ret)
> >> +               goto out;
> >> +       } else if (ret) {
> >>                 pr_err("auth protocol '%s' mauth authentication failed: %d\n",
> >>                        ceph_auth_proto_name(ac->protocol), result);
> >> +               goto out;
> >> +       }
> >> +
> >> +       set_global_id(ac, global_id);
> >>
> >>  out:
> >>         mutex_unlock(&ac->mutex);
> >> @@ -484,15 +498,11 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
> >>         int ret;
> >>
> >>         mutex_lock(&ac->mutex);
> >> -       if (global_id && ac->global_id != global_id) {
> >> -               dout("%s global_id %llu -> %llu\n", __func__, ac->global_id,
> >> -                    global_id);
> >> -               ac->global_id = global_id;
> >> -       }
> >> -
> >>         ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
> >>                                     session_key, session_key_len,
> >>                                     con_secret, con_secret_len);
> >> +       if (!ret)
> >> +               set_global_id(ac, global_id);
> >>         mutex_unlock(&ac->mutex);
> >>         return ret;
> >>  }
> >
> >Hi Greg,
> >
> >I asked Sasha to drop this patch earlier today.
>
> I've dropped it now, but I think I'm missing your previous request. Was
> it as a reply to the added-to mail? I just want to make sure I'm not
> missing your mails.

Yes, but it looks like it didn't make it to stable-commits mailing list
either.  Weird...

    MIME-Version: 1.0
    Date: Tue, 8 Jun 2021 11:13:08 +0200
    References: <20210608011339.51B0F6124C@mail.kernel.org>
    In-Reply-To: <20210608011339.51B0F6124C@mail.kernel.org>
    Message-ID:
<CAOi1vP9Ubs1Cu6sW43H-=dVXSzkFZBycfR_Af4b3vJ9mihkAzA@mail.gmail.com>
    Subject: Re: Patch "libceph: don't set global_id until we get an
auth ticket" has been added to the 5.12-stable tree
    From: Ilya Dryomov <idryomov@gmail.com>
    To: Sasha Levin <sashal@kernel.org>
    Cc: stable-commits@vger.kernel.org
    Content-Type: text/plain; charset="UTF-8"

Thanks,

                Ilya
