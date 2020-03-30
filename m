Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752A6197EBD
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 16:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgC3Oqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 10:46:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33297 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgC3Oqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 10:46:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so22026571wrd.0
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 07:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tpz3hcUinCwP2DWU0+Otg3a4kmarez+oM4RdYnuHgZ8=;
        b=Xg8Zh0NT42H/6GvxmHujZ3EoDU6alYlIB1UP0hgn3lJd6J/cGDJyGQPSHJLDsffMKQ
         cCfgM2guOg3YS9xaZNkjRZcPMxsbzK5OyQQUH8xvUyyFv5rZl8yZ3if4J5tifsqlIeca
         /uVoX4+XcE2YLxjicjghx+54pQ9GPrQgFAE7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tpz3hcUinCwP2DWU0+Otg3a4kmarez+oM4RdYnuHgZ8=;
        b=N/T96uCGYTw3FY/Llu1D5AxHnK4T1C35ntbuanY+rSladRI2XQ0XZHSnxbQFK2NKDi
         5a1clT7GHqr+WdH7DHx5qoN0jpYQpPfHVt2tX99uO/Q/ke3dQr7WTRHjiaOFA69MUhR7
         /UhlKoljiU0TRUgdS1AhUk8CRPFRso2vfxec95WLU4PX0PCsrGcBE3kroi94bnsY6CNe
         Q/KmFql5IYZ34YhT82G+LUPX4vVi/7r5ItF1h+gZ5YM8Z82fE7TuyUbC3KOmPyRxe17+
         PtpVJ3nkdUmGCZe2qPVjLxtnO2ClIP8pjb5CQ39lkl/MtHHZ79CQBs7bYbSrNHgszrmB
         11Ww==
X-Gm-Message-State: ANhLgQ1NwFvE7o+vSCJcELko0ZolOTplou+UXqOFAgRTvl8NKINjqAS+
        up0Lo6svKQRgLlWDE1dq4s5ARw==
X-Google-Smtp-Source: ADFU+vuifVDYMdzZofr1X+74yfPXUSfi61+tN8zpZ+l2OdZihgFOzAzKaJnywRgN+CQR/eW2eYm0fw==
X-Received: by 2002:adf:fac7:: with SMTP id a7mr15711731wrs.191.1585579589077;
        Mon, 30 Mar 2020 07:46:29 -0700 (PDT)
Received: from chatter.i7.local (tor-exit-1.zbau.f3netze.de. [185.220.100.252])
        by smtp.gmail.com with ESMTPSA id g2sm23189735wrs.42.2020.03.30.07.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 07:46:28 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:46:20 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Karel Zak <kzak@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        ndfont@gmail.com, pbadari@us.ibm.com,
        Rafael Wysocki <rafael@kernel.org>, rcj@linux.vnet.ibm.com,
        stable <stable@vger.kernel.org>, steve.scargall@intel.com
Subject: Re: [patch 2/5] drivers/base/memory.c: indicate all memory blocks as
 removable
Message-ID: <20200330144620.latd7lgfgzkmyfay@chatter.i7.local>
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
 <20200329021719.MBKzW0xSl%akpm@linux-foundation.org>
 <CAHk-=wgs1mfvk8pwefSD2A4=RgH6td50x9D-yn3Axm7icp5Xag@mail.gmail.com>
 <b80d7cea-a8f7-11c9-66fa-bdc272bdf099@redhat.com>
 <20200329194354.xrbzlvlbjimy3pzz@chatter.i7.local>
 <CAHk-=wheAem=MzY=F0ox7tuxFR47SgUj7zB+2S_KOhEB49zsPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wheAem=MzY=F0ox7tuxFR47SgUj7zB+2S_KOhEB49zsPA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 12:55:09PM -0700, Linus Torvalds wrote:
> On Sun, Mar 29, 2020 at 12:43 PM Konstantin Ryabitsev
> <konstantin@linuxfoundation.org> wrote:
> >
> > It would appear that the workflow Andrew uses to queue up patches from
> > you isn't expecting quoted-printable formatting, which is why when Linus
> > gets them, they are mangled.
> 
> I don't think that's the case.
> 
> Why? Because I see _proper_ handling of MIME and quoted-printable from
> Andrew all the time.

Hmm... You are correct. I see that Naohiro Aota's original patch was 
also QP-encoded. I'm just as confused as everyone, then. :) As far as I 
can tell, there is no meaningful difference between David's emails and 
Naohiro's:

https://lore.kernel.org/linux-mm/20200206090132.154869-1-naohiro.aota@wdc.com/raw
https://lore.kernel.org/linux-mm/20200128093542.6908-1-david@redhat.com/raw

David's original patch is well-formed and the only notable difference 
between the two is that there's a line of ==== in Nahorio's email that 
makes it immediately obvious that the message needs to be decoded before 
it can be used.

-K
