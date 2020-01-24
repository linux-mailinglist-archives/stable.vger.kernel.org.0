Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A718A148556
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 13:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387597AbgAXMpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 07:45:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35694 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387574AbgAXMpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 07:45:15 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so1599246wmb.0;
        Fri, 24 Jan 2020 04:45:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j+mBBTpQJ4wbg8K52L8M4km/ID9qCvpn337om+dHJcg=;
        b=fdHlWwGYPjfw1Ny99VNqIHv7bDzqZDoVW4n0C8WSqvY63tYJ2HMLuDAMQwgCxjnBRv
         8KEf0IQRR7pUczoEdpU70ftrD4wYXvZG/cnspnutGv+CfBNClBBfGiyy6Pm0Tqnsutc/
         JPowucQAKQvfOuQa3GPqk8X4E0bkTEk+YRY5/gR61Fk+7oBviF/spObsda+0HDiJbnkZ
         DsOlGjJR2MwlNXSjpt1CeL47jlZ/buX/2QErkoOw1oxAjg90ijW1p+y/ZiCk3qQXaki2
         7eQG1OdaLuwSHVz5b+wDmh4YuzjUjwpsGC4F3nTRNzifeC2eSwFvk4KKMAnD65ltq1RH
         RLCA==
X-Gm-Message-State: APjAAAXRQUXIVFxj9It/7WgwhK1HmbmDY2npWkBvZcsTd4amJ4VhlaFk
        vG23a35xXUPLhsxNRAKq0NE=
X-Google-Smtp-Source: APXvYqw48IZitTegCDEqW/DRYA1NjgNNLdiLHQ9/3fjlhxhOgsQMrqFvY7FUdFcstQQHzviWIpDW8Q==
X-Received: by 2002:a1c:bc08:: with SMTP id m8mr2654997wmf.189.1579869913658;
        Fri, 24 Jan 2020 04:45:13 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id g25sm14465121wmh.3.2020.01.24.04.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 04:45:12 -0800 (PST)
Date:   Fri, 24 Jan 2020 13:45:12 +0100
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
Message-ID: <20200124124512.GT29276@dhcp22.suse.cz>
References: <e60e64f9-894b-4121-d97b-fb61459cbbe5@redhat.com>
 <CAPcyv4jm=fmP=-5vbo2jxzMe2qXqZP=zDYF8G_rs3X6_Om0wPg@mail.gmail.com>
 <4d0334e2-c4e7-6d3f-99ba-2ca0495e1549@redhat.com>
 <CAPcyv4jixmv8fJ5FiYE=97Jud3Mc+6QzRX1txceSYU+WY_0rQA@mail.gmail.com>
 <fc0cfb97-5a60-7e73-4f85-d8e6947c5e28@redhat.com>
 <CAPcyv4jVpN26RGQLRn4BewYtzHDoQfvh37DEdEBq1dd4-BP0kw@mail.gmail.com>
 <64902066-51dd-9693-53fc-4a5975c58409@redhat.com>
 <CAPcyv4hcDNeQO3CfnqTRou+6R5gZwyi4pVUMxp1DadAOp7kJGQ@mail.gmail.com>
 <516aa930-9b64-b377-557c-5413ed9fe336@redhat.com>
 <CAPcyv4iiYtN6iGt=rVuNR=O=H9YcY1b1yWp+5TuDhu0QoVqT_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iiYtN6iGt=rVuNR=O=H9YcY1b1yWp+5TuDhu0QoVqT_A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 10-01-20 13:27:24, Dan Williams wrote:
> On Fri, Jan 10, 2020 at 9:42 AM David Hildenbrand <david@redhat.com> wrote:
[...]
> > For your reference (roughly 5 months ago, so not that old)
> >
> > https://lkml.kernel.org/r/20190724143017.12841-1-david@redhat.com
> 
> Oh, now I see the problem. You need to add that lock so far away from
> the __add_memory() to avoid lock inversion problems with the
> acpi_scan_lock. The organization I was envisioning would not work
> without deeper refactoring.

Sorry to come back to this late. Has this been resolved?

-- 
Michal Hocko
SUSE Labs
