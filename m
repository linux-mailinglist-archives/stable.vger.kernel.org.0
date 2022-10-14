Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8505FEC2E
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 11:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJNJ4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 05:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJNJ4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 05:56:37 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E401C3E77
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 02:56:35 -0700 (PDT)
Received: from quatroqueijos.cascardo.eti.br (unknown [179.110.172.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7D1BA3FE2B;
        Fri, 14 Oct 2022 09:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1665741394;
        bh=IC6cTy9anrFmidMw4xwdKiwL8YOj7V7HiMr+UScxZo4=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=i5pbcN7vMytP5Ns0P3hzHaiyBiQVnwoAkN1OKfSjokTt4x0zFRshGd0u1dZ7BriW5
         Wm6zjIGxUunknmdPsExaYJDzym6PNrnLXG1oTdLJBNRIUDjXg24MEZijWUZfA/N0tA
         FHKGzhMAgQImf8DaJEPbsyQre7IaMs808iteV28Py3Jy8gZ6GzaTozxAcDhbdm0exX
         37ge9w50U23JsxHU0RkOVhd14xZaWOoA0YQcJA0FNl7MK+NNadtG3UfkOB2I6jUVGu
         Bu6w+H81/L3hpLK5+nHcXEsZT2KNFQh0RE8mWLTEzE24I3lt0MAEYG6V9o0YLuWQ4J
         46NCKYctzdLJQ==
Date:   Fri, 14 Oct 2022 06:56:28 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Felix Fietkau <nbd@nbd.name>, stable@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: [PATCH 5.15 1/6] mac80211: mesh: clean up rx_bcn_presp API
Message-ID: <Y0kyTNju0rwqojrH@quatroqueijos.cascardo.eti.br>
References: <20221013181601.5712-1-nbd@nbd.name>
 <Y0kLsThZoDPPENhI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0kLsThZoDPPENhI@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 09:11:45AM +0200, Greg KH wrote:
> On Thu, Oct 13, 2022 at 08:15:56PM +0200, Felix Fietkau wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > commit a5b983c6073140b624f64e79fea6d33c3e4315a0 upstream.
> > 
> > We currently pass the entire elements to the rx_bcn_presp()
> > method, but only need mesh_config. Additionally, we use the
> > length of the elements to calculate back the entire frame's
> > length, but that's confusing - just pass the length of the
> > frame instead.
> > 
> > Link: https://lore.kernel.org/r/20210920154009.a18ed3d2da6c.I1824b773a0fbae4453e1433c184678ca14e8df45@changeid
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/mac80211/ieee80211_i.h |  7 +++----
> >  net/mac80211/mesh.c        |  4 ++--
> >  net/mac80211/mesh_sync.c   | 26 ++++++++++++--------------
> >  3 files changed, 17 insertions(+), 20 deletions(-)
> 
> Many thanks for this series.  Will this also work in 5.4.y and 5.10.y?
> 

Not sure about 5.10, but that won't work as is on 5.4. We are considering some
other approach for 5.4, but not sure yet. But simply taking dozens of clean
cherry picks did not strike as a good option to me.

Cascardo.

> greg k-h
