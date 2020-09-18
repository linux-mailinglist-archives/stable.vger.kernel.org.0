Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCB82702AB
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 18:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIRQzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 12:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIRQzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 12:55:04 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB97C0613CE
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 09:55:04 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id i1so6799899edv.2
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 09:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yxwRMmZAvscI9qLISrOKxKWDWXBsK0Qiq++otHhpMpM=;
        b=vW9xAgzLdO0QTngXP251avBoOv0g0D8jITnPZCJ5/Gugk+FHUHF/kvs6N/4BGb4yRp
         kwWQrpEvWarWlY6oGD1By4fOTSpcnfY6T5RGy1jX3cdIMv/EEDhvGn5NMNtptRwMLdk9
         TeIAV3rz/9S3/Lu+cwsk0KqQ/wvILgP0cetKg5Ci454hEpq8RvIg4WXN774E5PSIoMHa
         DsJC9VcCZV4SAA+etDYxCrS/HmvNAGtSF0KuTLpB/dl9CdoduF6NOwxzGVgG6ZJCJvpV
         bIXTRwy1i/WvQl4YY+EbOK5NGuWUtetdeY9jGfArhxhr2VbmzVU9ho3TRx2nE6NTGkEk
         2xTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yxwRMmZAvscI9qLISrOKxKWDWXBsK0Qiq++otHhpMpM=;
        b=GAi6C63uAtyozPepLssDXoRMbaF1b5ZVdqP+wLs/8w/IXU28mdH3ltdSI6QJg7G583
         ak+c/lW44t0orE3dgzsVPsT33a5lUaA/++t14FMnGLAUj5z/xQxuVCIUckGD/2Hzckn5
         Kc3i8an9FFabCfGb/B5zHwtkAQi3hJoBOCCQKRUyMHbCoNlrtNKE721fAyCTR9c4oquY
         0OzFwxrW2JhA/2CVPfdB2P6DqYfp6rowwxyWzCaS+I36s/qt8g7GuC0aW6wBlHj3Wgvg
         QuFiBFeXvG//DjdBW/F/WNr1490gsjziZDSkN7ugPqrFXSv0ohbgWvxOMW8XLQHLhQ67
         w0+A==
X-Gm-Message-State: AOAM533XcBSJcXWJd6mXofYJ/cc3cuavSiWG0YgJGZElH8Az8WzqziLh
        Iwr4yGHjcd57tEn0crrn90VQUqqNzs3lLFMNmuhPWw==
X-Google-Smtp-Source: ABdhPJxcLHTp2HmWlgI7Su041TxmNFgVD/jngcdBcxMjvp5IOfJeNJy8OR2y4k4Bfa6ELWveIGOQjFysEqiHQiktakY=
X-Received: by 2002:aa7:c511:: with SMTP id o17mr40445469edq.300.1600448103080;
 Fri, 18 Sep 2020 09:55:03 -0700 (PDT)
MIME-Version: 1.0
References: <160040692945.25320.13233625491405115889.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200918153041.GN7954@magnolia>
In-Reply-To: <20200918153041.GN7954@magnolia>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 18 Sep 2020 09:54:51 -0700
Message-ID: <CAPcyv4ii+NWnJhLWwz=Z+2aAJ=DdjwQoqPC+hO88CsM2ub5FEw@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH v2] dm: Call proper helper to determine dax support
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>,
        Mike Snitzer <snitzer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Adrian Huang <ahuang12@lenovo.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 8:31 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Thu, Sep 17, 2020 at 10:30:03PM -0700, Dan Williams wrote:
> > From: Jan Kara <jack@suse.cz>
> >
> > DM was calling generic_fsdax_supported() to determine whether a device
> > referenced in the DM table supports DAX. However this is a helper for "leaf" device drivers so that
> > they don't have to duplicate common generic checks. High level code
> > should call dax_supported() helper which that calls into appropriate
> > helper for the particular device. This problem manifested itself as
> > kernel messages:
> >
> > dm-3: error: dax access failed (-95)
> >
> > when lvm2-testsuite run in cases where a DM device was stacked on top of
> > another DM device.
>
> Is there somewhere where it is documented which of:
>
> bdev_dax_supported, generic_fsdax_supported, and dax_supported
>
> one is supposed to use for a given circumstance?

generic_fsdax_supported should be private to device drivers populating
their dax_operations. I think it deserves a rename at this point.
dax_supported() knows how to route through multiple layers of stacked
block-devices to ask the "is dax supported" question at each level.

> I guess the last two can test a given range w/ blocksize; the first one
> only does blocksize; and the middle one also checks with whatever fs
> might be mounted? <shrug>
>
> (I ask because it took me a while to figure out how to revert correctly
> the brokenness in rc3-5 that broke my nightly dax fstesting.)

Again, apologies for that.
