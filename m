Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2487196FC2
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 21:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgC2Tn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 15:43:58 -0400
Received: from mail-qv1-f43.google.com ([209.85.219.43]:41777 "EHLO
        mail-qv1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbgC2Tn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 15:43:58 -0400
Received: by mail-qv1-f43.google.com with SMTP id t4so3644807qvz.8
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 12:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+F/1eq0glJBSgOqHvm+SW54/FWudeTuarptdC7xXAjA=;
        b=cc3P7x8oPHL/CuqU9bpPr8SM3zkgTgO8IYDFdRrBWA0VeLMTTvAHpK0o274nd0v8ps
         F9PGmx0rp9Lr4XLGBIsFBzbZz33K7pNcpotPVG2Q6RnrWkxKNurB0JwtMpnM/0qabb3j
         rqfupWw+UgFQH7qr/COofFab5I9JhDQYIwJ2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+F/1eq0glJBSgOqHvm+SW54/FWudeTuarptdC7xXAjA=;
        b=X22DAD8r7ZB1EIbpEB825UTuw7Vdp/SEfPKMtnfzW72fN5xTHx/SUKlDCkIXtaXOEO
         caUips1XgiuJIkPr4pKZ/oNttCzzt5GGKSROQl35BwVCAYkt43PIdjMkqHg0AE9MhRJv
         Vzj71RGTzmUvj5w2T2lxMRao+GQlQKebghK8/lMvyCxmt4szPw8IylLdlcsO4ubcIjSa
         Da6qF9sMdxYmhBiY58HbdqwbzZNZdMtsT2jQ6Myn31cL57DVEovxYFeItf0OizlvchJX
         zX7uz2fIzesh8NT7Oce2VIBJ1nafk/Qz2KwpMh+kfHswltzl3KaRVVPc1IDhUPDK0aHK
         8W8A==
X-Gm-Message-State: ANhLgQ2+QwGCJoZoo5cAb4NKbaaHCAK7AanJ0riiL2E5+MkbDZ+ZKu9f
        4xMYbHb9NpLyFutP+a4bW8xosQ==
X-Google-Smtp-Source: ADFU+vvrFak0yNjfI3wzHYmW3kYUVx5/pW6kx4nv2AG5hL1Og3+kURVvxBhI5WP/+f9AMsC+3koNdA==
X-Received: by 2002:a0c:e610:: with SMTP id z16mr6389956qvm.49.1585511036729;
        Sun, 29 Mar 2020 12:43:56 -0700 (PDT)
Received: from chatter.i7.local (107-179-243-71.cpe.teksavvy.com. [107.179.243.71])
        by smtp.gmail.com with ESMTPSA id w18sm8541708qkw.130.2020.03.29.12.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 12:43:56 -0700 (PDT)
Date:   Sun, 29 Mar 2020 15:43:54 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20200329194354.xrbzlvlbjimy3pzz@chatter.i7.local>
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
 <20200329021719.MBKzW0xSl%akpm@linux-foundation.org>
 <CAHk-=wgs1mfvk8pwefSD2A4=RgH6td50x9D-yn3Axm7icp5Xag@mail.gmail.com>
 <b80d7cea-a8f7-11c9-66fa-bdc272bdf099@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b80d7cea-a8f7-11c9-66fa-bdc272bdf099@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 08:03:52PM +0200, David Hildenbrand wrote:
> > Please, David H - whatever you do with email is WRONG.
> > 
> > Fix your completely broken email client. Stop doing this.

To butt in uninvited into this conversation, it doesn't look like 
there's anything really wrong with what David sends, except for the 
quoted-printable formatting, which is probably converted automatically 
by one of Red Hat's relay MTAs.

> What I received via the mailing list (e.g., linux-mm@kvack.org)
> 
> Message-Id: <20200128093542.6908-1-david@redhat.com>
> MIME-Version: 1.0
> X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
> X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
> Sender: owner-linux-mm@kvack.org
> Precedence: bulk
> X-Loop: owner-majordomo@kvack.org
> List-ID: <linux-mm.kvack.org>
> [...]
> X-Mimecast-Spam-Score: 1
> Content-Type: text/plain; charset=US-ASCII
> Content-Transfer-Encoding: quoted-printable
> X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
> [...]
> 
> And a lot of this MIME crap.
> 
> I have no idea if such a conversion is expected to be done.

In theory, it doesn't really matter, as mail clients are supposed to be 
properly undoing all this 7-bit legacy madness. When we run that thread 
through "b4 am" to get things back into 8bit, everything looks just 
fine. You can try it yourself:

b4 am 20200128093542.6908-1-david@redhat.com

> Unless I am missing something important, the issue is not in mail client
> setup, but there is something in the mailing infrastructure horribly
> messing with my mails. Red Hat has recently switched to Mimecast and
> there have been plenty of issues, maybe this is one of these.
> 
> I guess the only thing I can do is sending mails via a different mail
> server / different email address?

It would appear that the workflow Andrew uses to queue up patches from 
you isn't expecting quoted-printable formatting, which is why when Linus 
gets them, they are mangled.

We would either need to switch Andrew to a set of tools that handle 7bit 
legacy formats better, or figure out how you can send things via MTAs 
that won't convert from 8bit to quoted-printable. Maybe you can convince 
Red Hat to set up their relays to always preserve 8bit?

-K
