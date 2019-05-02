Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6D912505
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 01:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfEBXVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 19:21:16 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37917 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfEBXVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 19:21:16 -0400
Received: by mail-ot1-f68.google.com with SMTP id b1so3745393otp.5
        for <stable@vger.kernel.org>; Thu, 02 May 2019 16:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0i5+J/OZLL+JOOwALn6I5uwFawiDlG+N57qbnmaBmtk=;
        b=sWawHLNMKR0Z8Wcp0xOaPFpIrQ6QpmbbM6zigcIzNj1WJvbeh+Sjw9n6tIJoHgDaA6
         GgHltRLQSt1agn1TOVUOGI46HUvE24ww/7wBYRHYRdNKiWzKHHbf5etMXZ20pnRvnGIT
         QxTurydSSdEyMyi2Qabh03VR59K4+NgTK148H0EFCAUUYSf8o8pEDxzDGjdTWBY4TUca
         UWHAuYyxKgs+/C5mYh4EOm/HxHdIMEG82VoybqBmlv5jAXSswdNp6xkxYFfh4c5dXIip
         rrOFS4TWce+QrFAoelxpv3OXDps3RdQeyQdRCaSHgv7pxXJ8hfmeq4/ufkrHiwBWMeqm
         VKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0i5+J/OZLL+JOOwALn6I5uwFawiDlG+N57qbnmaBmtk=;
        b=YvUg+208vLBY4Gc0bfnMoTusLGfczDxzVoqjAWmNGhLZY4Bm8d6j/GGP42MCDs3CLh
         U1pB6OvVzBjHErWFTZwk8jqYIp6TghgP2TyupKEIGoX2HyejIdPzHWVQQRA/TOarD/LB
         cTSyu4DQZtG35BhDsDIwmh3LldMHVPAt60iSO3gEJ6DY/bqTAM8coy4sUqtG3aag6Qyv
         nAmuXyabCrmdUsz+WITNgewqaVF+uQBVLuI1Sipp7M/LHaY0b2UtnBRlBB7ARekIhDXj
         0SgAcSxXuP6R9ZXyZKGN+8GcIA3KhZqdZo1pP3DmWajgGhs7gPkPGABgEMeYmOfNRfqU
         mqmw==
X-Gm-Message-State: APjAAAXY0JIl3H3zSRUV8dQJgRDy1ZwbT40O/BlBbxzdJv6IaTjXN4sy
        Z3qUGYZ1Ddra4PzFo+d191PNxDwIZ0uHW+Y0DspYbnMaDdUMxg==
X-Google-Smtp-Source: APXvYqw0TgWpuTZRL+SCcmgsjTeKduMjL6fHbHh+v1JzAjaquiFt8e1uuHJEKU0m3H+lLNeHniLWZoNoGl8pEH0sriQ=
X-Received: by 2002:a9d:222c:: with SMTP id o41mr4495514ota.353.1556839275827;
 Thu, 02 May 2019 16:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+CK2bBT=goxf5KWLhca7uQutUj9670aL9r02_+BsJ+bLkjj=g@mail.gmail.com> <CAPcyv4gWZxSepaACiyR43qytA1jR8fVaeLy1rv7dFJW-ZE63EA@mail.gmail.com>
In-Reply-To: <CAPcyv4gWZxSepaACiyR43qytA1jR8fVaeLy1rv7dFJW-ZE63EA@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 2 May 2019 16:21:05 -0700
Message-ID: <CAPcyv4j1221GA6xQww741v-RdZame5D0q60qcxO5u=tv9MDoRw@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] mm: Sub-section memory hotplug support
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Toshi Kani <toshi.kani@hpe.com>,
        Jeff Moyer <jmoyer@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        stable <stable@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 2, 2019 at 4:20 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, May 2, 2019 at 3:46 PM Pavel Tatashin <pasha.tatashin@soleen.com> wrote:
> >
> > Hi Dan,
> >
> > How do you test these patches? Do you have any instructions?
>
> Yes, I briefly mentioned this in the cover letter, but here is the
> test I am using:

Sorry, fumble fingered the 'send' button, here is that link:

https://github.com/pmem/ndctl/blob/subsection-pending/test/sub-section.sh
