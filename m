Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8CC267852
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 08:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgILGrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 02:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgILGrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 02:47:16 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53912C061573;
        Fri, 11 Sep 2020 23:47:16 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j2so13453663wrx.7;
        Fri, 11 Sep 2020 23:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7nD/VaObHAeyrLefzOwE6wmeihoCl1D26CpOc/uRRug=;
        b=TEkKIx09OQ+Lmc5ndk/XboKZOxYsNbDLhNYTrRz/4n5fa7+ZexhYo1ud2EjS2Km7+W
         nZV7N76qIWGjAb8pz0L/lH0UpCdoaC4VFGa2WSW0hq4raGLG4tf/m1Fp/ksYqyYHL4X+
         zCfSjCWBPRHnzGuIi5MnHDeaDKO+kHqoRcY0OHClicpOt85dQJd+4XkiyTOTZVVYM8iS
         hC098KO5I8FI3OMWgZ+7i88/Rm8+0fKqAAXdH1BkH6LP/Em4qWET6WZyVWk7i+5WWSAB
         oXzYQIy29GejLYLx7l9791DxUlAnPV1y2aaHqqQTX5dLiSSKta3E4AEYJLu2PS78XZ+1
         GY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7nD/VaObHAeyrLefzOwE6wmeihoCl1D26CpOc/uRRug=;
        b=t1s8D6OjY35nFa78pgXkL6iX9Wn9AYh70F9liGU2Hc7BbecftjkosXkNAH7Bq5Cgl+
         g0x5gJmEyE94xBp+qMLDgtjPs+p6zbY+/hQgHyw9AGPnIuN1Ykt7sGPZyqMSf2EkVN2c
         OSqD0GSuDIcu2+fBOYJIP+3GJFGnjpd5826g7dTXJeHqdMSt+zL0qdoxFcAgc98BEoHD
         kfbd1EGxDjdtPIiTRtG9HLZcJuCY0zrpVB4226la6FaqkIBKY8SevaExPehrHp/jF5Qn
         ukUfwpjrUovXfgXwGyu3JlKllEzOjR0HI1Rhe4914GPrkUh0UQnHUu6SgT/RBp8RwY3D
         f6uQ==
X-Gm-Message-State: AOAM533+tOGu5pda6Y8is+hiGW2/qXIrpdu1eVTlA9alq8eXHihwmLKx
        5HNgEgLl46vTWn3kRuqD/WhnLJ8bFLPepQ==
X-Google-Smtp-Source: ABdhPJzJis/Ysz+nIhjBe42SqyNBJykcYw/moA9a/RZRxrMEkUjq5Z81S5ref+Xgiz0jQBFu1n7Jwg==
X-Received: by 2002:a5d:5404:: with SMTP id g4mr5314662wrv.134.1599893235056;
        Fri, 11 Sep 2020 23:47:15 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id y1sm8426815wmi.36.2020.09.11.23.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 23:47:14 -0700 (PDT)
Date:   Sat, 12 Sep 2020 08:47:13 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Bob Peterson <rpeterso@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Craig <Daniel.Craig@csiro.au>,
        Nicolas Courtel <courtel@cena.fr>
Subject: Re: [PATCH 4.19 142/206] gfs2: fix use-after-free on transaction ail
 lists
Message-ID: <20200912064713.GA291675@eldamar.local>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195323.968867013@linuxfoundation.org>
 <20200910194319.GA131386@eldamar.local>
 <20200911115816.GB3717176@kroah.com>
 <942693093.16771250.1599826115915.JavaMail.zimbra@redhat.com>
 <20200911122024.GA3758477@kroah.com>
 <1542145456.16781948.1599828554609.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542145456.16781948.1599828554609.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bob, hi Greg,

On Fri, Sep 11, 2020 at 08:49:14AM -0400, Bob Peterson wrote:
> ----- Original Message -----
> > On Fri, Sep 11, 2020 at 08:08:35AM -0400, Bob Peterson wrote:
> > > ----- Original Message -----
> > > > On Thu, Sep 10, 2020 at 09:43:19PM +0200, Salvatore Bonaccorso wrote:
> > > > > Hi,
> > > > > 
> > > > > On Tue, Jun 23, 2020 at 09:57:50PM +0200, Greg Kroah-Hartman wrote:
> > > > > > From: Bob Peterson <rpeterso@redhat.com>
> > > > > > 
> > > > > > [ Upstream commit 83d060ca8d90fa1e3feac227f995c013100862d3 ]
> > > > > > 
> > > > > > Before this patch, transactions could be merged into the system
> > > > > > transaction by function gfs2_merge_trans(), but the transaction ail
> > > > > > lists were never merged. Because the ail flushing mechanism can run
> > > > > > separately, bd elements can be attached to the transaction's buffer
> > > > > > list during the transaction (trans_add_meta, etc) but quickly moved
> > > > > > to its ail lists. Later, in function gfs2_trans_end, the transaction
> > > > > > can be freed (by gfs2_trans_end) while it still has bd elements
> > > > > > queued to its ail lists, which can cause it to either lose track of
> > > > > > the bd elements altogether (memory leak) or worse, reference the bd
> > > > > > elements after the parent transaction has been freed.
> > > > > > 
> > > > > > Although I've not seen any serious consequences, the problem becomes
> > > > > > apparent with the previous patch's addition of:
> > > > > > 
> > > > > > 	gfs2_assert_warn(sdp, list_empty(&tr->tr_ail1_list));
> > > > > > 
> > > > > > to function gfs2_trans_free().
> > > > > > 
> > > > > > This patch adds logic into gfs2_merge_trans() to move the merged
> > > > > > transaction's ail lists to the sdp transaction. This prevents the
> > > > > > use-after-free. To do this properly, we need to hold the ail lock,
> > > > > > so we pass sdp into the function instead of the transaction itself.
> > > > > > 
> > > > > > Signed-off-by: Bob Peterson <rpeterso@redhat.com>
> > > > > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > (snip)
> > > > > 
> > > > > In Debian two user confirmed issues on writing on a GFS2 partition
> > > > > with this commit applied. The initial Debian report is at
> > > > > https://bugs.debian.org/968567 and Daniel Craig reported it into
> > > > > Bugzilla at https://bugzilla.kernel.org/show_bug.cgi?id=209217 .
> > > > > 
> > > > > Writing to a gfs2 filesystem fails and results in a soft lookup of the
> > > > > machine for kernels with that commit applied. I cannot reporduce the
> > > > > issue myself due not having a respective setup available, but Daniel
> > > > > described a minimal serieos of steps to reproduce the issue.
> > > > > 
> > > > > This might affect as well other stable series where this commit was
> > > > > applied, as there was a similar report for someone running 5.4.58 in
> > > > > https://www.redhat.com/archives/linux-cluster/2020-August/msg00000.html
> > > > 
> > > > Can you report this to the gfs2 developers?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Hi Greg,
> > > 
> > > No need. The patch came from the gfs2 developers. I think he just wants
> > > it added to a stable release.
> > 
> > What commit needs to be added to a stable release?
> > 
> > confused,
> > 
> > greg k-h
> 
> Sorry Greg,
> 
> It's pretty early here and the caffeine hadn't quite hit my system.
> The problem is most likely that 4.19.132 is missing this upstream patch:
> 
> cbcc89b630447ec7836aa2b9242d9bb1725f5a61
> 
> I'm not sure how or why 83d060ca8d90fa1e3feac227f995c013100862d3 got
> put into stable without a stable CC but cbcc89b6304 is definitely
> required.
> 
> I'd like to suggest Salvatore try cherry-picking this patch to see if
> it fixes the problem, and if so, perhaps Greg can add it to stable.

I can confirm (Daniel was able to test): Applying cbcc89b63044 ("gfs2:
initialize transaction tr_ailX_lists earlier") fixes the issue. So
would be great if you can pick that up for stable for those series
which had 83d060ca8d90 ("gfs2: fix use-after-free on transaction ail
lists") as well.

Regards,
Salvatore
