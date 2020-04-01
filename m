Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4044C19AEC8
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 17:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732798AbgDAPeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 11:34:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40638 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732758AbgDAPeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 11:34:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id u10so559190wro.7
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 08:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IRUg0hA1e247QwMuszVydu3aXauAhNYqzTUWhR1ZsfM=;
        b=KWjCAkOTIMC/u3q7xHamXNlFeoK3t/UGkJwkqfA1UFlDboFUOH/GLEWa830+o/noCn
         5kA1nlg9157X9IBCMZZlZIJNyY0KzgChLa0j/tHW74mOdLEJMEHo5qpV6sPyLWWJRSgc
         mUEyurj9+61oXBGbGDdgcVoMLR5n8LX8dK11Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IRUg0hA1e247QwMuszVydu3aXauAhNYqzTUWhR1ZsfM=;
        b=eUVncnOw9/Q/da1+3nyiL2HTBpUpY4+j6KWKfm8FKI0iKaWJ29mS1BXF/IenRPHX7S
         xussWYFgyDKeWtcX0kzBXbjojcoUeHhDUVyUAFCgxVmO+6BJXXuMIEz4HoVIdfZVLDUb
         jJCobBRymgPtUCx3n1fFo/Rjvte3jzoXMTNjAxXs8nHY0NCkxXUuHumtFXrGGO+vMT1N
         kX1mVk4rLYixBQ6yg8zNTF5JhvJwaZ8iTX83/6uKEkfFLumO2RHoB9ndWJqV0rLfs+Uh
         rbU5e12MRgHmUnyoR+oSPuE3nwkcvAZ2q+5c0lRt7Fi24b6g6MhGHNkdZj9Oga59nm0g
         jjjA==
X-Gm-Message-State: ANhLgQ1yk8/6Wj1m5Zy3bQJ70kf2tpRt2eOxNeG6uYYTKOyiSTmnTtUd
        MdqjidK25HVw2YbdJyC9kO4tew==
X-Google-Smtp-Source: ADFU+vtALpjrQ2uHpS/k4qVG+qKl2d3sDtWmY7S723FiyR+47+uF3+5pELZASehIb4kJF2KxAp1dBA==
X-Received: by 2002:a5d:460f:: with SMTP id t15mr26615724wrq.413.1585755248749;
        Wed, 01 Apr 2020 08:34:08 -0700 (PDT)
Received: from chatter.i7.local (tor-exit-16.zbau.f3netze.de. [185.220.100.243])
        by smtp.gmail.com with ESMTPSA id b199sm3364710wme.23.2020.04.01.08.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 08:34:07 -0700 (PDT)
Date:   Wed, 1 Apr 2020 11:33:59 -0400
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
Message-ID: <20200401153359.bh5vsko6d7ph7y7r@chatter.i7.local>
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
 <20200329021719.MBKzW0xSl%akpm@linux-foundation.org>
 <CAHk-=wgs1mfvk8pwefSD2A4=RgH6td50x9D-yn3Axm7icp5Xag@mail.gmail.com>
 <b80d7cea-a8f7-11c9-66fa-bdc272bdf099@redhat.com>
 <20200329194354.xrbzlvlbjimy3pzz@chatter.i7.local>
 <bdab60f6-2755-3aff-49a0-86ffc7f79fb1@redhat.com>
 <0c7d6011-714e-adb9-5826-4f3088a8826b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0c7d6011-714e-adb9-5826-4f3088a8826b@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 03:35:01PM +0200, David Hildenbrand wrote:
> >> We would either need to switch Andrew to a set of tools that handle 
> >> 7bit legacy formats better, or figure out how you can send things 
> >> via MTAs that won't convert from 8bit to quoted-printable. Maybe 
> >> you can convince Red Hat to set up their relays to always preserve 
> >> 8bit?
> > 
> > I'll give it a try, but I think it's rather unlikely ... :)
> 
> So, people are looking into. Literally any mail that goes via Mimecast
> servers (at least sent by me!) is converted *for whatever reason* to
> quoted-printable.

I mean, it's not *wrong* to do that -- older mail standards required 
that all MTA-to-MTA communication should be done in 7bit. But we're 
literally talking previous-century legacy protocols here. Forcefully 
converting all mail to 7bit is about the most 90s thing you can do these 
days, short of being really into mullets and Arsenio Hall.

> E.g., patches I punched out today via "git send-email" even have the
> line continuations thingy again (they disappeared for a while, maybe
> there are different MTAs involved and it's like playing the lottery)

Those show up when your lines are longer than 76 characters. Because, 
you know, otherwise the message would be too wide to fit through the 
ethernet cable.

https://en.wikipedia.org/wiki/Quoted-printable#Quoted-Printable_encoding

Best regards,
-K
