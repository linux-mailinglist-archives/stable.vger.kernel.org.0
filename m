Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8A414A561
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 14:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgA0NrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 08:47:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33532 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0NrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 08:47:06 -0500
Received: by mail-wr1-f65.google.com with SMTP id b6so11394641wrq.0;
        Mon, 27 Jan 2020 05:47:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RrWpQE/VnIZwikbFGvSuSK1v5GexTEwUzERkPHgg/GE=;
        b=SPXRZ7N9u8vERq5HcrxbMrXfD3/tHsxJ5maOZEErBoqt55UaePjEnuRN4ZBkNEW48w
         eq0gLsF+fv5GG1dEPigzpiKZFV8KGi+SkSo0EhBgVOE9wMNYjc8oBSfc90oms23Qu2nl
         uSlT11Vyktafb1/LOcC42WJjSx9uxm1KN4xOFzmZ5rNKulYM/RiDtmbm5v19pF5dcYcf
         jPDGzHAJaObHjMs4JjwOlIE+jXOvg0l7eCmCEaZYDdC0Ui6X7xIf5u0T+0tpN3qtWGC5
         cle48SUXw6+inVToHmu11HgmL8meRUmAafKftFAPqyIlhB/zf6M1aakk0h4iUcWK6FOb
         SGaQ==
X-Gm-Message-State: APjAAAWf/si+2/W42BJ16g1P9tkTOV+8hVrTZhNgVEyjPlX+eiVk48ZT
        tJHbep5OftF8WT2CS+/2fYA=
X-Google-Smtp-Source: APXvYqxuzSy7u6AvBpDEBh+3XBuTPRlHz0vMV4tjwz6eWfNfOphsZWVdcAae62Dpz1a+TxrgovrIhQ==
X-Received: by 2002:adf:fc03:: with SMTP id i3mr22197142wrr.306.1580132824077;
        Mon, 27 Jan 2020 05:47:04 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id m7sm18599014wma.39.2020.01.27.05.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:47:03 -0800 (PST)
Date:   Mon, 27 Jan 2020 14:47:02 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/memory_hotplug: Fix remove_memory() lockdep splat
Message-ID: <20200127134702.GJ1183@dhcp22.suse.cz>
References: <4d0334e2-c4e7-6d3f-99ba-2ca0495e1549@redhat.com>
 <CAPcyv4jixmv8fJ5FiYE=97Jud3Mc+6QzRX1txceSYU+WY_0rQA@mail.gmail.com>
 <fc0cfb97-5a60-7e73-4f85-d8e6947c5e28@redhat.com>
 <CAPcyv4jVpN26RGQLRn4BewYtzHDoQfvh37DEdEBq1dd4-BP0kw@mail.gmail.com>
 <64902066-51dd-9693-53fc-4a5975c58409@redhat.com>
 <CAPcyv4hcDNeQO3CfnqTRou+6R5gZwyi4pVUMxp1DadAOp7kJGQ@mail.gmail.com>
 <516aa930-9b64-b377-557c-5413ed9fe336@redhat.com>
 <CAPcyv4iiYtN6iGt=rVuNR=O=H9YcY1b1yWp+5TuDhu0QoVqT_A@mail.gmail.com>
 <20200124124512.GT29276@dhcp22.suse.cz>
 <CAPcyv4jcCnfGy5HcYimxcyF6v_Anw4nMdaNHQt4tMrqUaN70Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jcCnfGy5HcYimxcyF6v_Anw4nMdaNHQt4tMrqUaN70Rg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 24-01-20 10:04:52, Dan Williams wrote:
> On Fri, Jan 24, 2020 at 4:56 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Fri 10-01-20 13:27:24, Dan Williams wrote:
> > > On Fri, Jan 10, 2020 at 9:42 AM David Hildenbrand <david@redhat.com> wrote:
> > [...]
> > > > For your reference (roughly 5 months ago, so not that old)
> > > >
> > > > https://lkml.kernel.org/r/20190724143017.12841-1-david@redhat.com
> > >
> > > Oh, now I see the problem. You need to add that lock so far away from
> > > the __add_memory() to avoid lock inversion problems with the
> > > acpi_scan_lock. The organization I was envisioning would not work
> > > without deeper refactoring.
> >
> > Sorry to come back to this late. Has this been resolved?
> 
> The mem_hotplug_lock lockdep splat fix in this patch has not landed.
> David and I have not quite come to consensus on how to resolve online
> racing removal. IIUC David wants that invalidation to be
> pages_correctly_probed(), I would prefer it to be directly tied to the
> object, struct memory_block, that remove_memory_block_devices() has
> modified, mem->section_count = 0.

I was asking about this part and I can see you have already posted a
patch[1] and I do not see any reason for not merging it.

[1] http://lkml.kernel.org/r/157991441887.2763922.4770790047389427325.stgit@dwillia2-desk3.amr.corp.intel.com

-- 
Michal Hocko
SUSE Labs
