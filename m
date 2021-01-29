Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8773090C8
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 00:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhA2XzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 18:55:01 -0500
Received: from so15.mailgun.net ([198.61.254.15]:25322 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231565AbhA2XzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Jan 2021 18:55:01 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2021 18:55:00 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611964481; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=HUNiHIQmr/npCagMU/t/LtTySsZ+JNwCBw3sxHTxVDE=; b=BSl2q0P+7tjqIacKku6ntQHdXPzDX7c/7+VVHOCGbULvr7UGcgDP0LxTxTWooauVxJtyZi4C
 Lfmu8XdlVzZpLBP7nJoChnC+tDuWUF4oDmJAO3LJ0XR5fTsWaaAopSaSfilgASfJ/NrpPDeR
 ifya8UmI/rbYyYBw5iYxOT8Po98=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60149ec04ee30634eb209d93 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 Jan 2021 23:48:16
 GMT
Sender: jcrouse=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1AA0CC43462; Fri, 29 Jan 2021 23:48:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from jcrouse1-lnx.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jcrouse)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53D46C433C6;
        Fri, 29 Jan 2021 23:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53D46C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jcrouse@codeaurora.org
Date:   Fri, 29 Jan 2021 16:48:11 -0700
From:   Jordan Crouse <jcrouse@codeaurora.org>
To:     Eric Anholt <eric@anholt.net>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] drm/msm: Fix race of GPU init vs timestamp power
 management.
Message-ID: <20210129234811.GA1612@jcrouse1-lnx.qualcomm.com>
Mail-Followup-To: Eric Anholt <eric@anholt.net>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <20210127233946.1286386-1-eric@anholt.net>
 <20210128184702.GB29306@jcrouse1-lnx.qualcomm.com>
 <CADaigPVF=Ti4tLYTUsK+0Gi6GbK9ADOuFf4tCYftmVZ96gJLxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADaigPVF=Ti4tLYTUsK+0Gi6GbK9ADOuFf4tCYftmVZ96gJLxg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 11:17:16AM -0800, Eric Anholt wrote:
> On Thu, Jan 28, 2021 at 10:52 AM Jordan Crouse <jcrouse@codeaurora.org> wrote:
> >
> > On Wed, Jan 27, 2021 at 03:39:44PM -0800, Eric Anholt wrote:
> > > We were using the same force-poweron bit in the two codepaths, so they
> > > could race to have one of them lose GPU power early.
> > >
> > > Signed-off-by: Eric Anholt <eric@anholt.net>
> > > Cc: stable@vger.kernel.org # v5.9
> >
> > You can add:
> > Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
> >
> > Because that was my ugly.
> >
> > Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
> 
> I only pointed it at 5.9 because it looked like it would probably
> conflict against older branches.  I can add the fixes tag if you'd
> like, though.

Fair enough. It is a good bug to fix but not if there are a lot of conflicts to
deal with.

Jordan
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
