Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD6EE22EE
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 20:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404766AbfJWS5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 14:57:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33385 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404749AbfJWS5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 14:57:49 -0400
Received: by mail-pg1-f196.google.com with SMTP id u23so1987124pgo.0
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 11:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=0A/h7iLy4iHQtSsekrwsy2+ZOdTrZGwWLZDqgK94iTI=;
        b=WiW6N27nIGzcNodI0rwBgBHNHkWhgXetcPMk3sdC5v3k+2c7+jvFI5wUsKX4vYKVPH
         b57QDME3T4453VBQh06dbHYs6/6qkpCpi0D7ju8F43it9oOGgqfNMtOdrAL5brWnRLSS
         rwgowlv51ncyLoxqhU3EOUYYJkA5tDHaqYs2XN40yA8QKDGDGLYTyLNtHeto5ImmKaE8
         QWU8n15oNlqodMsKE8FfF0uxDy7Zowk8Pxn8i6HJ5dOgEtI6yyFxxjLuFOeV25s/Chw3
         re2XRlgnj4fuCwCWA4goBXL0qgQhWTezgUeEhuALaZtaGGUmvvAn/HRef6Irqh0Ony+u
         dT5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=0A/h7iLy4iHQtSsekrwsy2+ZOdTrZGwWLZDqgK94iTI=;
        b=SZG8OIFJyWpqFM9jW8+LkFLSAuGP1fgqUpIJgovO8Z2MuNzArJogQdY3D+z1Qrtjsh
         hCh5X7YI4Sr+VdElv9+/6dVr24iMRDizw5NviOylqfjImNoI9ol0H4UGe81/aOG7O4HO
         KRreBEqdyTMameDjyiwLX6SJQgtyE/zNqSNC+XiagliTB0Q+i8PeN4BzobUrdloiezgI
         ijYr6hkM6qzS+hjjnooxqafDZZyoDDf4oMFJZyNjGwBFQMmb4ymvrz55O/1PpBt5Mxci
         kHAr4DchNjJ1ABVH7Js7Y31cLrGIxrtpbPlimXfXiPkL0++b8TOR9K0aMB3lWDPSCpnQ
         uIZA==
X-Gm-Message-State: APjAAAUQ05vmHx/uUys9H3u/BmaafN/LSHtSvJlfby36fLXchKbblhXC
        gzsPEfADrMVhJHKFjg2w11ADpw==
X-Google-Smtp-Source: APXvYqx13mXWJwGmMU4WM10j2g/LqTaCcPjmA9goHOXK5t7jCgjGf6iFQ4JS3U1on9Dm5nlm2nm2MA==
X-Received: by 2002:a63:fe15:: with SMTP id p21mr11544514pgh.26.1571857068258;
        Wed, 23 Oct 2019 11:57:48 -0700 (PDT)
Received: from [100.112.92.218] ([104.133.9.106])
        by smtp.gmail.com with ESMTPSA id w11sm30045956pfd.116.2019.10.23.11.57.46
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 11:57:47 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:57:17 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Yang Shi <yang.shi@linux.alibaba.com>
cc:     Matthew Wilcox <willy@infradead.org>, hughd@google.com,
        aarcange@redhat.com, kirill.shutemov@linux.intel.com,
        gavin.dg@linux.alibaba.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
In-Reply-To: <792ea136-4fa0-c87b-9399-5ca47c501c9c@linux.alibaba.com>
Message-ID: <alpine.LSU.2.11.1910231144490.1088@eggly.anvils>
References: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com> <20191023172420.GB2963@bombadil.infradead.org> <792ea136-4fa0-c87b-9399-5ca47c501c9c@linux.alibaba.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Oct 2019, Yang Shi wrote:
> On 10/23/19 10:24 AM, Matthew Wilcox wrote:
> > On Thu, Oct 24, 2019 at 01:05:04AM +0800, Yang Shi wrote:
> > > +	return map_count >= 0 &&
> > > +	       map_count == atomic_read(&head[1].compound_mapcount);
> > >   }
> > I didn't like Hugh's duplicate definition either.  May I suggest:
> 
> Thanks, Willy. It is fine to me. Will take it in v3.

Agreed, that will be better.

Hugh
