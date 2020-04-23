Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD41B578D
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 10:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDWI7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 04:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWI7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 04:59:14 -0400
X-Greylist: delayed 3598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Apr 2020 01:59:14 PDT
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72554C03C1AF;
        Thu, 23 Apr 2020 01:59:14 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jRXhP-00EmKj-Ey; Thu, 23 Apr 2020 10:59:11 +0200
Message-ID: <42e9ac2651c677e9143b019393d60c3254893ae0.camel@sipsolutions.net>
Subject: Re: Commit "mac80211: fix race in ieee80211_register_hw()" breaks
 mac80211 debugfs
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, stable <stable@vger.kernel.org>
Date:   Thu, 23 Apr 2020 10:59:09 +0200
In-Reply-To: <CAFA6WYMYQAnW0vKm4fxNn+nA6dYXvqaungBEYDpd-wrzaavr8A@mail.gmail.com> (sfid-20200423_105749_472578_D47E3801)
References: <c304ad9c-f404-d22e-de74-9398da3ebfc3@hauke-m.de>
         <CAFA6WYN3FbqTivGJTfXtHsMjXNPXW+P4MZWiCL14utF2sHkeYg@mail.gmail.com>
         <885ae3bffad315445be3fc70cccade9067ee6937.camel@sipsolutions.net>
         <CAFA6WYMYQAnW0vKm4fxNn+nA6dYXvqaungBEYDpd-wrzaavr8A@mail.gmail.com>
         (sfid-20200423_105749_472578_D47E3801)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-04-23 at 14:27 +0530, Sumit Garg wrote:

> > > +++ b/net/wireless/core.c
> > > @@ -473,6 +473,10 @@ struct wiphy *wiphy_new_nm(const struct
> > > cfg80211_ops *ops, int sizeof_priv,
> > >                 }
> > >         }
> > > 
> > > +       /* add to debugfs */
> > > +       rdev->wiphy.debugfsdir = debugfs_create_dir(wiphy_name(&rdev->wiphy),
> > > +                                                   ieee80211_debugfs_dir);
> > 
> > This cannot work, we haven't committed to the name of the wiphy yet at
> > this point.
> 
> Maybe I am missing something, can you please elaborate here?
> 
> Looking at the code, the default or requested wiphy name is configured
> just above this and the rename API "cfg80211_dev_rename()" takes care
> of renaming wiphy debugfs directory too.

Yes, but I think wiphy_register() can still fail at this point, due to
name clashes or so?

In any case, it'd be very strange to have a debugfs entry around when
the wiphy doesn't exist yet, and could possibly cause the same issue
that you fixed again, just through debugfs accesses?

Can you take a look at the patch I sent?

johannes

