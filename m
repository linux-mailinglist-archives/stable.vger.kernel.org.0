Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADC61EFE70
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 19:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgFERCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 13:02:36 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:47040 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgFERCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 13:02:36 -0400
Received: by mail-ot1-f67.google.com with SMTP id g7so7060072oti.13;
        Fri, 05 Jun 2020 10:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wTZiSOR+igC/gRCry3GVm0Zp9Ahw3ee9N7yu1QHMPRc=;
        b=YiRpuDfmlt2WeNv2aLXt+VZkCxONKnM/w81WbGLR06RwqA/TQZpStDcV5Kwd0yGnj/
         XS4/E1DB46gCzd9koUsTbKgtw0Mj7uv9EdhBYmpIE1Dyd5GJoqt7IcEEOR41nFkTkCo3
         +6c6L/Q2m7lHJZ8jKDE0ApcxEYsFStQa7dn+KoRVaw4OF71RDuQroOH65Yxe0xjq9oR6
         CG3GZGc1uQSz/h4C62jtwmFuKUULcYLjZZyIpPZ8jUGuRgzeEnvXHoLqmYxIseJbK3h/
         tQm4L0Vw5rTHSIWiqOJXAlbzEzvuGwGYPH7sFtwT16VnBerEVEMONknGUKzjgQDEGT3O
         xQGQ==
X-Gm-Message-State: AOAM530M8q6GT5k/CVgBTqklvSWzKwDrImPvkOGfIgRGOxz5AeXUuY7Z
        nC2NhlhO6k+B8KmOzDsyVPGnBS6iv2lSPIPYW+s=
X-Google-Smtp-Source: ABdhPJwS8cBnOQWNPzEMxfpCbrXxhygVWp3mt32v/HYym+XE4ggBkygQ0R0aKSiHguylxsBfEP6pBBRYzxoafwh8WA0=
X-Received: by 2002:a05:6830:20d1:: with SMTP id z17mr7997880otq.167.1591376555389;
 Fri, 05 Jun 2020 10:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <158889473309.2292982.18007035454673387731.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAJZ5v0gq55A7880dOJD7skwx7mnjsqbCqEGFvEo552U9W2zH3Q@mail.gmail.com>
 <CAPcyv4gQNPNOmSVrp7epS5_10qLUuGbutQ2xz7LXnpEhkWeA_w@mail.gmail.com>
 <CAJZ5v0g-TSk+7d-b0j5THeNtuSDeSJmKZHcG3mBesVZgkCyJOg@mail.gmail.com> <CAPcyv4iECAzRjAUJ1hymOzZRjBYQ_baFrSz=2ah=2pfehn9S_g@mail.gmail.com>
In-Reply-To: <CAPcyv4iECAzRjAUJ1hymOzZRjBYQ_baFrSz=2ah=2pfehn9S_g@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 5 Jun 2020 19:02:24 +0200
Message-ID: <CAJZ5v0iAwDpFYgOa+1=7_wdt4jHVftzS-o=xTJzJSVjceqhzwQ@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: Drop rcu usage for MMIO mappings
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Stable <stable@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Ira Weiny <ira.weiny@intel.com>,
        James Morse <james.morse@arm.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 5, 2020 at 6:39 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Fri, Jun 5, 2020 at 9:22 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> [..]
> > > The fix we are looking at now is to pre-map operation regions in a
> > > similar manner as the way APEI resources are pre-mapped. The
> > > pre-mapping would arrange for synchronize_rcu_expedited() to be elided
> > > on each dynamic mapping attempt. The other piece is to arrange for
> > > operation-regions to be mapped at their full size at once rather than
> > > a page at a time.
> >
> > However, if the RCU usage in ACPI OSL can be replaced with an rwlock,
> > some of the ACPICA changes above may not be necessary anymore (even
> > though some of them may still be worth making).
>
> I don't think you can replace the RCU usage in ACPI OSL and still
> maintain NMI lookups in a dynamic list.

I'm not sure what NMI lookups have to do with the issue at hand.

If acpi_os_{read|write}_memory() is used from NMI, that is a bug
already in there which is unrelated to the performance problem with
opregions.

> However, there are 3 solutions I see:
>
> - Prevent acpi_os_map_cleanup() from triggering at high frequency by
> pre-mapping and never unmapping operation-regions resources (internal
> discussion in progress)

Yes, that can be done, if necessary.

> - Prevent walks of the 'acpi_ioremaps' list (acpi_map_lookup_virt())
> from NMI context by re-writing the physical addresses in the APEI
> tables with pre-mapped virtual address, i.e. remove rcu_read_lock()
> and list_for_each_entry_rcu() from NMI context.

That sounds a bit convoluted to me.

> - Split operation-region resources into a separate mapping mechanism
> than APEI resources so that typical locking can be used for the
> sleepable resources and let the NMI accessible resources be managed
> separately.
>
> That last one is one we have not discussed internally, but it occurred
> to me when you mentioned replacing RCU.

So NMI cannot use acpi_os_{read|write}_memory() safely which you have
pointed out for a few times.

But even if NMI resources are managed separately, the others will
still not be sleepable (at least not all of them).

Cheers!
