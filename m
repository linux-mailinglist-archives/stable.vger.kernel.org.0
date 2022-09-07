Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F6B5AFDBE
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 09:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiIGHnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 03:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiIGHnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 03:43:13 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5F19CCF1;
        Wed,  7 Sep 2022 00:43:12 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id e3so5208473uax.4;
        Wed, 07 Sep 2022 00:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6THtmgcVePWFNs8nUqYB0LRQGPCz7NxBUHotNl9JwcQ=;
        b=k4ZPS7ZbWV8H+Y73IWgtHV4Cauy75oX+aYmzu0/O4cvq3/O3l6XBtDYQvhLFsHrFUZ
         k7XJvqK2WaQaGLUwU7YBgZ8ES2BRiucn1u0jfB+vq9z7M2Hb1C4B0t6qVrbT+22JnLTy
         Ceuo2xsfqF1FDH1Bh+wrL2ioUmfN+beZSPMferwumRNeAQWExp+jIhu8D8jar/Z7mtr+
         MYqMLELNJQabQWsqEXAh23H2jfK8wXT1og71kn2JOpXTZuzE00Cjldd4sXtd2/whgtd6
         8WCI7DNupZrs0SO0HLJ08HKWKP6X9WHsxts8QBgRBFFL1LW1zoVmAW/oaWTU4ZKB5Vex
         0rBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6THtmgcVePWFNs8nUqYB0LRQGPCz7NxBUHotNl9JwcQ=;
        b=eoPVYMa4ow3+spy17jgj/K4ww8WKfEmaEsmAR8i6PhzACDfBpvf3LxM/j8abT5vcPl
         OVwXFREWMvuF50m8mCCBtKz72yhPfraGqsCe/aOQZZGlgtcGSxicl6ijGHsmgiIK/laD
         nuF+IdQGGQHfwJKVaca4vzmdn+xqtZAKBvVgmnNIp/K890f+UFHXVXWL80zFrI5+QeWY
         6nDu+3e3PXezGuiX96Gzu60R0WopENMkoSI7ENllVW/rCaZGwVdz1EuBDXvoohkEwShR
         CRkhSzc16shigbsgNBkG6YyDJ031LHuxtfPqCfVtiVPthg4YJskqlVXO8AlDKU77iM4Z
         ZfeQ==
X-Gm-Message-State: ACgBeo3PAXRUODlhD5VBVui7XLwIitL0gCAcNLJFOaJW6q35LRZA6KRr
        /f+wHhOm+wNubUljGaKFmnmLiiHmxtvoDdG+Dfk=
X-Google-Smtp-Source: AA6agR4EVRZiq8vqbPT60dq2yr4eOX/5+LVuSpwWhwF4fmyNG/ZH0LujJYCv0EKVvPLA+ekGFRgaCgvTHcN3FybRkto=
X-Received: by 2002:ab0:5ac9:0:b0:39f:82d3:a5d3 with SMTP id
 x9-20020ab05ac9000000b0039f82d3a5d3mr664641uae.114.1662536591426; Wed, 07 Sep
 2022 00:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220906183600.1926315-1-teratipally@google.com>
 <20220906183600.1926315-2-teratipally@google.com> <CAOQ4uxi_Q8aXUg+FM0Q9__t=KqJSVqOgkS8j8kNC3MQfniZLWA@mail.gmail.com>
In-Reply-To: <CAOQ4uxi_Q8aXUg+FM0Q9__t=KqJSVqOgkS8j8kNC3MQfniZLWA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 7 Sep 2022 10:43:00 +0300
Message-ID: <CAOQ4uxieqhdkj=Ypp+guf0fV4dpd_c=dg9fFTgGLatV1GbHfmA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
To:     Varsha Teratipally <teratipally@google.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Fix CC for brauner]

On Wed, Sep 7, 2022 at 10:40 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Sep 6, 2022 at 9:36 PM Varsha Teratipally
> <teratipally@google.com> wrote:
> >
> > From: Christoph Hellwig <hch@lst.de>
> >
> > XFS always inherits the SGID bit if it is set on the parent inode, while
> > the generic inode_init_owner does not do this in a few cases where it can
> > create a possible security problem, see commit 0fa3ecd87848
> > ("Fix up non-directory creation in SGID directories") for details.
> >
> > Switch XFS to use the generic helper for the normal path to fix this,
> > just keeping the simple field inheritance open coded for the case of the
> > non-sgid case with the bsdgrpid mount option.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
>
> Hi Varsha,
>
> For future reference, when posting an xfs patch for stable,
> please follow these guidelines:
>
> 1. Post it to xfs list for review BEFORE posting to stable
> 2. LKML is not a relevant list
> 3. Tag the patch with the target kernel [PATCH 5.10]
> 4. Include the upstream commit id
> 5. Add some description (after --- line) about how you tested
>
> Regarding this specific patch for 5.10, I had already tested and posted it
> for review back in June [1].
>
> Dave Chinner commented then that he was concerned about other
> security issues discovered later on related to the generic implementation
> of SGID stripping.
> At the time, the generic upstream fixes and tests were still WIP.
>
> Christoph Hellwig, the author of the original patch replied to Dave's
> concern:
>
> "To me backporting it seems good and useful, as it fixes a relatively
> big problem.  The remaining issues seem minor compared to that."
>
> Christiain Brauner who has been reviewing the generic upstream
> also agreed that:
>
> "Imho, backporting this patch is useful. It fixes a basic issue."
>
> So this specific fix patch from the v5.12 release, which is not
> relevant for 5.15.y has my blessing to go to 5.10.y.
>
> Regardless, the last bits of the upstream work on the generic
> implementation by Yang Xu have landed in v6.0-rc1 [2] and the
> respective fstests have just recently landed in fstests v2022.09.04.
>
> I already have all the patches backported to 5.10 [3] and will start
> testing them in the following weeks, but now I also depend on Leah
> to test them for 5.15.y before I can post to 5.10.y and that may take
> a while...
>
> Thanks,
> Amir.
>
> [1] https://lore.kernel.org/linux-xfs/CAOQ4uxg4=m9zEFbDAKXx7CP7HYiMwtsYSJvq076oKpy-OhK1uw@mail.gmail.com/
> [2] https://lore.kernel.org/linux-fsdevel/20220809103957.1851931-1-brauner@kernel.org/
> [3] https://github.com/amir73il/linux/commits/xfs-5.10.y-sgid-fixes
