Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E35D546930
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 17:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiFJPLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 11:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345390AbiFJPLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 11:11:20 -0400
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BA420AA69
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:11:02 -0700 (PDT)
Received: by mail-qv1-f43.google.com with SMTP id h18so18784285qvj.11
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sKXGAog39LKZY4WYCXDbeAfVjBlfuLt1RyciOfygwXU=;
        b=fwbWCStviSgnSrG4WR0mwGklLl2KncdQe0c+eV69mS7rGMZSjTEU/uRGIQimJb82pu
         dNfONsk+Try7S4XZ1ik23thBAc72MpPTv2xi9VUs7erg3zIVQce7x04g6FKFqQMwgtqn
         a+ak38zdR8jEU6X9eh2V7GW6GJlhMSgToK/B/NXTNXBar7/P95T7zLnLmyAinSfymez7
         50PnI2XqqCPiMPJlQlePIyN71hLRytt6exe6ZLNeoi8+5fukcrQq3HGL50zkWDTjfKB9
         9okXixt9Jdg27pKDE1xnOAVT9/S0ePMdqvo3C0cOSmVurtNYkC/PsRD9pXwHQMhuv/hf
         fnVA==
X-Gm-Message-State: AOAM532Wc+V1m9b91B8itfRNihcqRffvsdUIz6RXG8wfH9o52e15omtn
        9cOFB1S2fLFVAByi6NvBUiGv
X-Google-Smtp-Source: ABdhPJzfpJR/RjQLHUu3kWRlKvxHxz6bsudZeV2/S/4eugGpDEdr3x2h4vOCWJiRMX7i6L/0LQCoNw==
X-Received: by 2002:a05:6214:2308:b0:435:3440:7d3c with SMTP id gc8-20020a056214230800b0043534407d3cmr33667442qvb.65.1654873861579;
        Fri, 10 Jun 2022 08:11:01 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id u20-20020a05620a0c5400b006a6a774d27bsm17078941qki.134.2022.06.10.08.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:11:01 -0700 (PDT)
Date:   Fri, 10 Jun 2022 11:11:00 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oleksandr Tymoshenko <ovt@google.com>, keescook@chromium.org,
        sarthakkukreti@google.com, stable@vger.kernel.org,
        regressions@lists.linux.dev, dm-devel@redhat.com
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
Message-ID: <YqNfBMOR9SE2TuCm@redhat.com>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqLTV+5Q72/jBeOG@kroah.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10 2022 at  1:15P -0400,
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > I believe this commit introduced a regression in dm verity on systems
> > where data device is an NVME one. Loading table fails with the
> > following diagnostics:
> > 
> > device-mapper: table: table load rejected: including non-request-stackable devices
> > 
> > The same kernel works with the same data drive on the SCSI interface.
> > NVME-backed dm verity works with just this commit reverted.
> > 
> > I believe the presence of the immutable partition is used as an indicator
> > of special case NVME configuration and if the data device's name starts
> > with "nvme" the code tries to switch the target type to
> > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > 
> > The special NVME optimization case was removed in
> > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > affected.
> > 
> 
> Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> immutable singleton target on NVMe") to those older kernels?  If so,
> have you tested this and verified that it worked?

Sorry for the unforeseen stable@ troubles here!

In general we'd be fine to apply commit 9c37de297f65 but to do it
properly would require also making sure commits that remove
"DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
unnecessary NVMe branching in favor of scsi_dh checks") are applied --
basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
be removed.

The commit header for 8d47e65948dd documents what
DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
"nvme" mode really never got used by any userspace that I'm aware of.

Sadly I currently don't have the time to do this backport for all N
stable kernels... :(

But if that backport gets out of control: A simpler, albeit stable@
unicorn, way to resolve this is to simply revert 9c37de297f65 and make
it so that DM-mpath and DM core just used bio-based if "nvme" is
requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:

@@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)

                        if (!strcasecmp(queue_mode_name, "bio"))
                                m->queue_mode = DM_TYPE_BIO_BASED;
			else if (!strcasecmp(queue_mode_name, "nvme"))
-                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
+                               m->queue_mode = DM_TYPE_BIO_BASED;
                        else if (!strcasecmp(queue_mode_name, "rq"))
                                m->queue_mode = DM_TYPE_REQUEST_BASED;
                        else if (!strcasecmp(queue_mode_name, "mq"))

Mike
