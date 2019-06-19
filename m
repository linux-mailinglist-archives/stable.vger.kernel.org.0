Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86954BF48
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 19:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfFSRGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 13:06:55 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36319 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFSRGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 13:06:54 -0400
Received: by mail-oi1-f193.google.com with SMTP id w7so11163795oic.3
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 10:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0p/XIwpXKqn06m+RPTTcvCNox7E/RmmojiCAJ5y+urI=;
        b=X1G1dO6s3hbPvvZxcZOiIHvHuDoK3U48uQPPR5MSfaahW+qB1h5ikRxyrv0TQ20ja0
         HICDctS0WB3ZfGIRg+H0iIVCOFaWPrqH49VvmlQYs54j8X67guXIqTf09+c1rckymzbV
         CCA0ucFlLTdXNabe+3SVVYtFDnUivT7Subor5zWzFNMMilwCMtKka4LlKaWkWMhvonJS
         tbQ0whFMH1pwYpXuToAxQMqnJ70T9W7U+F9PYM7voXqcBD6Atro+SbJN3pT9PRBmjh0M
         wTtxFqXTPr6YUGMkMtavqPHD+DBwSSuZ8kCju0CBrKYoI1Cd1zI68zp/6pDA/7ySsNxR
         +jJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0p/XIwpXKqn06m+RPTTcvCNox7E/RmmojiCAJ5y+urI=;
        b=oYqCIPHUaUwWXN1FBbVh5Lhg26l3b3SQeP2KrmY6GZfvXSuQ8sSJL3Q37O+pA364ee
         s5L/DxqxC1irOz7K+Xm/iBVogoSXABetequSGt2jOx8UhCPrlgcF2Rg+2tSXlpdZzqrn
         TsUWPFcvL7ucrNBn+L3RiWvb2rhk2RPyiIVnQqcpXapQ7NxABEuU48796Ahq85iCReeE
         Oil1a4ihaoXfDxYr/ThuRohw7nhafzMtabdpPAumH+raFWJlDVqsnVPenfnN+WklMIuG
         Ye8Jy7PfSVEaS9MaU4rwClnrryo+UazU4ajgjPUpHrzZkqCLrDrZZwc3STU+0hPRQUzN
         AAPQ==
X-Gm-Message-State: APjAAAXliBcMAsCI7l5ciE93Si27KcQEdYtcMRnPFuVfZuVz+OfDsgYU
        lMiFkFi+Qx1KtKAnww2K5POqp8fpPh9DccKsx5Eqog==
X-Google-Smtp-Source: APXvYqzPQ7hGf38RJ89R10lUDX088z06TMvhN9nJMBhLW66oBHW/MYhv7ngyJ6+CXJ7guXzYDqNBTWN5jhwDowX/HFE=
X-Received: by 2002:aca:ec82:: with SMTP id k124mr3358584oih.73.1560964014171;
 Wed, 19 Jun 2019 10:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156092356065.979959.6681003754765958296.stgit@dwillia2-desk3.amr.corp.intel.com>
 <877e9hk06d.fsf@linux.ibm.com>
In-Reply-To: <877e9hk06d.fsf@linux.ibm.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 19 Jun 2019 10:06:43 -0700
Message-ID: <CAPcyv4gZfLoG2tOGFWK56rr1vadF71+ny951brtunbPUNW-W1w@mail.gmail.com>
Subject: Re: [PATCH v10 12/13] libnvdimm/pfn: Fix fsdax-mode namespace
 info-block zero-fields
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 19, 2019 at 9:30 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > At namespace creation time there is the potential for the "expected to
> > be zero" fields of a 'pfn' info-block to be filled with indeterminate
> > data. While the kernel buffer is zeroed on allocation it is immediately
> > overwritten by nd_pfn_validate() filling it with the current contents of
> > the on-media info-block location. For fields like, 'flags' and the
> > 'padding' it potentially means that future implementations can not rely
> > on those fields being zero.
> >
> > In preparation to stop using the 'start_pad' and 'end_trunc' fields for
> > section alignment, arrange for fields that are not explicitly
> > initialized to be guaranteed zero. Bump the minor version to indicate it
> > is safe to assume the 'padding' and 'flags' are zero. Otherwise, this
> > corruption is expected to benign since all other critical fields are
> > explicitly initialized.
> >
> > Note The cc: stable is about spreading this new policy to as many
> > kernels as possible not fixing an issue in those kernels. It is not
> > until the change titled "libnvdimm/pfn: Stop padding pmem namespaces to
> > section alignment" where this improper initialization becomes a problem.
> > So if someone decides to backport "libnvdimm/pfn: Stop padding pmem
> > namespaces to section alignment" (which is not tagged for stable), make
> > sure this pre-requisite is flagged.
>
> Don't we need a change like below in this patch?
>
> modified   drivers/nvdimm/pfn_devs.c
> @@ -452,10 +452,11 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>         if (memcmp(pfn_sb->parent_uuid, parent_uuid, 16) != 0)
>                 return -ENODEV;
>
> -       if (__le16_to_cpu(pfn_sb->version_minor) < 1) {
> -               pfn_sb->start_pad = 0;
> -               pfn_sb->end_trunc = 0;
> -       }
> +       if ((__le16_to_cpu(pfn_sb->version_minor) < 1) ||
> +           (__le16_to_cpu(pfn_sb->version_minor) >= 3)) {
> +                       pfn_sb->start_pad = 0;
> +                       pfn_sb->end_trunc = 0;
> +               }

No, this kills off start_pad and end_trunc permanently.

> IIUC we want to force the start_pad and end_truc to zero if the pfn_sb
> minor version number >= 3. So once we have this patch backported and
> older kernel finds a pfn_sb with minor version 3, it will ignore the
> start_pad read from the nvdimm and overwrite that with zero here.
> This patch doesn't enforce that right? After the next patch we can have
> values other than 0 in pfn_sb->start_pad?

The reason for the version bump is for the kernel to safely assume
that uninitialized fields default to zero, but it's otherwise a nop
when the implementation is explicitly initializing every field by
default.
