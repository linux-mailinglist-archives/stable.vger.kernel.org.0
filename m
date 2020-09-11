Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939A4266108
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIKOPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgIKNPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 09:15:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AFBC06179F;
        Fri, 11 Sep 2020 06:14:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y15so4779884wmi.0;
        Fri, 11 Sep 2020 06:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/efAOxEKJ1gyh5Ctf4uoo0Fx5OP5sMJt3oXFDgabHlE=;
        b=avWKSyQOZCAvSDawpwBR7yLERjv59XVDoNB9eAiquv1P8esR4wWhvOXA76HT2Y/6yl
         DLtkOoroDkKjMOXiU06TnkM7lM1fsbjDDlHLHmgyMIpWarcUdXMKWG6oh2OnOpj9xG3H
         O1k7WIqQ5TzNHeccCINdPRq2WGAChjBK716FjlnBSPhEv+t5N1aG5Hslmd+ARwxBaZbL
         ii9RiG+vvUn0GPx4ZtnG1jXYToGgu3QMFg/NcTCNqyBkepsgCFzqgRp1GZk0rzsU0ufh
         tS73Gq7S/4t7zx1/xy7Br+FKWfddFpjbq5+hKoWkOXjVrWd/vr7eQ7NxXYPk+PYeWOz3
         iJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/efAOxEKJ1gyh5Ctf4uoo0Fx5OP5sMJt3oXFDgabHlE=;
        b=BNf0T4/vJ+Bmx2Wlktuw3v2cMs9nQPLGejGmkHMCbPYW1vgQMWviKdha31MSifxrBF
         oHQLoveWIIjqKTEvmPA9yi0RDYUsSrydnllI/yNdzHBq93WTaydZd6tNttHHaI4Hv653
         9Oi7Sf1/2ZCJtwTtRqQw2sjQQfBIS+ChgbM6DkJrIiUdq9TIDCoNS/Q3G4QecZJpF1aj
         7efPXdUG2SMloXsksQeCaEKiNvvKoYTIuag9v/dB9bz+SUTe479TxS5SFTNXFJVMc3QA
         T4lK9NfEmpDQ0X9BjcANlhAE9AO+gjR9PVxzQYkQ/cM1PLSO6uBpf5Zk704pBmw3e5mm
         EaIA==
X-Gm-Message-State: AOAM532bNohpQ4A8RkyrG1fI9BrtJywY1B2cOPJYHZ8RJ4qhNHs9Q46D
        7NkHTvjGNfTiyvR0caPhxG0=
X-Google-Smtp-Source: ABdhPJwS69+FdwpeSP58WAGR07FcTh6IGlFlNydBjaMRoYEJ+oqSvi/UBIHLqCaod13r7CARFfUG1Q==
X-Received: by 2002:a05:600c:c5:: with SMTP id u5mr2154668wmm.14.1599830051694;
        Fri, 11 Sep 2020 06:14:11 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id b11sm4641568wrt.38.2020.09.11.06.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 06:14:10 -0700 (PDT)
Date:   Fri, 11 Sep 2020 15:14:08 +0200
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
Message-ID: <20200911131408.GA242456@eldamar.local>
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

Hi Bob,

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

Thanks I will ask the affected users if they can test this (because as
said I cannot myself in this case).

If it is true that we need to cherry-pick as well
cbcc89b630447ec7836aa2b9242d9bb1725f5a61, then all of v4.14.y,
v4.19.y, v5.4.y would need to have it included as well
(83d060ca8d90fa1e3feac227f995c013100862d3 was applied down to
v4.14.186, v4.19.130, v5.4.49, v5.7.6 (EOL)).

Regards,
Salvatore
