Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35825FEA4
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 01:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfGDX10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 19:27:26 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45677 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfGDX1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 19:27:25 -0400
Received: by mail-ot1-f68.google.com with SMTP id x21so7282946otq.12
        for <stable@vger.kernel.org>; Thu, 04 Jul 2019 16:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29vsGpTjh39zWXsI6Ik43Nv+EdiuWAOV6vxVTajp20k=;
        b=xPh6pbcmI7ZR83uwzt44/h5WZ1jKG98r+LQaDHsemaTjfAFmLK4NHwQNObxnmJM5M8
         kiKlk4co3uBSxHYbFY+WMMvf50uquNZyF0w7RVkb+wN9QHaDcveJWANUrWindaZdPjYX
         fRPefhjZL+h/GTwMBlPyo/7+/fOiU2/TzGWz4bA8jxIM0dAKYaLHEKDaVOkAQSEXS/JJ
         HntfFU+nDsisSL67tqCRY1E2FW29XVGHkHGY+9yi5XPwwkF8dUbKQwZFovjFinBx4P3H
         +CX76/THYqM9Ar2u/pO3kfTI759leI2eRYxgBjawd3DUVZuTF7q3s4H/zjBzZl96hbN0
         jkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29vsGpTjh39zWXsI6Ik43Nv+EdiuWAOV6vxVTajp20k=;
        b=UWDQzDV2td26GyjNzjoOy1uC2jRteYN6SwyHBCJidmDCk5pQf7RwUp/L+u5PiD4VKT
         FlTXPaySvp//Nstu28bop4CTvucNy3OzBnXdFkTlcYEJJ2F17YDZLsB5zqLwFtHVQedU
         Nxh2HtKHyoW9ETab0/iFAJ14+n/hzRmXIKsh+pwnf495c1K7wHhy5+233xgKyGGW6vEE
         vskZDuNKNJpdfS+9XGY7amgQc8mKq3KffBMt1nqRkEDmq4Oian0oEe8adRR8rw/+fTlm
         rsU/AEQ8098GLmgbx5gBAal8phHhQgkYgkUoCjC1cN2DuD3Ejoqoj6H92NAjlruFrdFr
         vitA==
X-Gm-Message-State: APjAAAV0R7D+gA4nI56CjVA9PjkofOpgdoO047lfJ1L62JxzO+zNgkNl
        k+yfVviQ4lMprTaqROlbV0bGQOnZLlA89Id67G+v/w==
X-Google-Smtp-Source: APXvYqzFfoPnlwPxd7HMRN1iiNSb0TD46BOhSl+i1LNcRaH8pGkExzmOgi5cRwt9v88JBevUo0Jwrlqmbeg2el1s4mY=
X-Received: by 2002:a9d:7a9a:: with SMTP id l26mr386103otn.71.1562282845133;
 Thu, 04 Jul 2019 16:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org> <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org> <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org> <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
In-Reply-To: <20190704191407.GM1729@bombadil.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 4 Jul 2019 16:27:14 -0700
Message-ID: <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 4, 2019 at 12:14 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Jul 04, 2019 at 06:54:50PM +0200, Jan Kara wrote:
> > On Wed 03-07-19 20:27:28, Matthew Wilcox wrote:
> > > So I think we're good for all current users.
> >
> > Agreed but it is an ugly trap. As I already said, I'd rather pay the
> > unnecessary cost of waiting for pte entry and have an easy to understand
> > interface. If we ever have a real world use case that would care for this
> > optimization, we will need to refactor functions to make this possible and
> > still keep the interfaces sane. For example get_unlocked_entry() could
> > return special "error code" indicating that there's no entry with matching
> > order in xarray but there's a conflict with it. That would be much less
> > error-prone interface.
>
> This is an internal interface.  I think it's already a pretty gnarly
> interface to use by definition -- it's going to sleep and might return
> almost anything.  There's not much scope for returning an error indicator
> either; value entries occupy half of the range (all odd numbers between 1
> and ULONG_MAX inclusive), plus NULL.  We could use an internal entry, but
> I don't think that makes the interface any easier to use than returning
> a locked entry.
>
> I think this iteration of the patch makes it a little clearer.  What do you
> think?
>

Not much clearer to me. get_unlocked_entry() is now misnamed and this
arrangement allows for mismatches of @order argument vs @xas
configuration. Can you describe, or even better demonstrate with
numbers, why it's better to carry this complication than just
converging the waitqueues between the types?
