Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B06E1B2BAC
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 17:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgDUPyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 11:54:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33333 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgDUPyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 11:54:43 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay1so5392356plb.0;
        Tue, 21 Apr 2020 08:54:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WA9A83mNO4Jsc2bWW6Z8o2K5ouW7sqEUFm9fDXDQEic=;
        b=gtxmJPBj3O9ErUcTi8LRjbZwGVHqYQWgRgQLQcvFXIStN8gCEZ7QTqOgFgzRSIQ3RG
         TNfPUbV4P4ouBMiySvmxuOCfu909T81bSgpzoi1Zzu2r831GtkbDHuPDeX5O1dKteDh1
         sDAbbYO0bE5Ndn1ps6MlFa0SmMRuS6vxPCpysi/DxCAIw1P36IY/fGK0IgsUveBT8/Gw
         T5VnBBvQEXGU1coRgfBtpHZskQPeNSrxi8ud0QCdFJIL/dA6LPwHScMFfL5aBa3w1Yzf
         f6ddwx3ISJFkrF9n8gOnd3UcKrg37vaSlniX3A0etgDX0rKCTr/qSbJEmOIZZOyAD1cM
         gq5g==
X-Gm-Message-State: AGi0PuYxbpoGzqZXOSWCPUeDGj3UMGua6lBy7KFDrCCUqWo+0A/QVKrZ
        uN2aQdL12qka8f5wgNYmwUM=
X-Google-Smtp-Source: APiQypIaMU86jrFKZ3g4JB1E5/X3QoymTNnWg2UjNrJeZc8T2p7/jLVqRto/TPPKBMt8E8Ug9uLBJA==
X-Received: by 2002:a17:90a:4e81:: with SMTP id o1mr6125309pjh.161.1587484483049;
        Tue, 21 Apr 2020 08:54:43 -0700 (PDT)
Received: from sultan-box.localdomain ([104.200.129.62])
        by smtp.gmail.com with ESMTPSA id x185sm2770600pfx.155.2020.04.21.08.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 08:54:42 -0700 (PDT)
Date:   Tue, 21 Apr 2020 08:54:40 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] drm/i915: Synchronize active and retire callbacks
Message-ID: <20200421155440.GA2289@sultan-box.localdomain>
References: <20200404024156.GA10382@sultan-box.localdomain>
 <20200407064007.7599-1-sultan@kerneltoast.com>
 <20200414061312.GA90768@sultan-box.localdomain>
 <158685263618.16269.9317893477736764675@build.alporthouse.com>
 <20200414144309.GB2082@sultan-box.localdomain>
 <20200420052419.GA40250@sultan-box.localdomain>
 <158737090265.8380.6644489879531344891@jlahtine-desk.ger.corp.intel.com>
 <20200420161514.GB1963@sultan-box.localdomain>
 <158745189706.5265.10618964185012452715@saswiest-mobl.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158745189706.5265.10618964185012452715@saswiest-mobl.ger.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 09:51:37AM +0300, Joonas Lahtinen wrote:
> Quoting Sultan Alsawaf (2020-04-20 19:15:14)
> > On Mon, Apr 20, 2020 at 11:21:42AM +0300, Joonas Lahtinen wrote:
> > > So it seems that the patch got pulled into v5.6 and has been backported
> > > to v5.5 but not v5.4.
> > 
> > You're right, that's my mistake.
> 
> Did applying the patch to v5.4 fix the issue at hand?

Of course the patch doesn't apply as-is because the code's been shuffled around,
but yes. The crashes are gone with that patch, and I don't have the motivation
to check if that patch is actually correct, so hurray, problem solved. I'm not
going to send the backport myself because I'll probably be ignored, so you can
go ahead and do that.

Sultan
