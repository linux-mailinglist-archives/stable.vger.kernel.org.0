Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE3843CB62
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 16:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbhJ0OCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 10:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbhJ0OCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 10:02:49 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A4DC061570
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 07:00:23 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d3so4340171wrh.8
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 07:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VsY/FViuPLJJ0x97MC/uW0G6j8qKMPcqH4JsVsaJd28=;
        b=pq7P7YMYIQH9NwuUkgLPVJUTai+lIGPlC5FaJMuPwNa2PuYaeQVV6XanW9YKTIm0HM
         Q6lPrfldyu0HckCShW0yFEe6FisHQVrfyDrHElq2Ty2l7PMyMtDoLZM6YDp3E8aymfei
         PVlgZk1Xlcx49k9Z/3qLhdC4r+bZGkySjjkUwXErZcezO8B0XVWGU/yA5rtpjE288Wso
         +AO1Z78th+sxJ/q6dIJJIGYj61Pqtn9sSmgcS6DC9qzwUwyCnc2o0evzSis2MhsbA8qN
         tzBG5/cv+N2re3xehzhcVd0iE/UJMGsSfyzqcyx+FBaNuv8qs57/I172ywbxO8ivoYaK
         zIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VsY/FViuPLJJ0x97MC/uW0G6j8qKMPcqH4JsVsaJd28=;
        b=m65ZoSox3dH/n1EXcnq5CthHWH3eIGZ/CbchBBrix4gKZbncAfLrRe/hgVUxCVA6Gz
         XZF4rTmxTnunnlhSmVwDIf3nxm6jY2Cf5r1m5SrPZsdYDWImnX2KOq6jzpTnMFpbTfpO
         YcBxymYnstVDn8ruqzhQ/gLAHvsVzh+unpEiDz83/yB5pZQxx1mIW+/rmpmd4Q/nwv0z
         7/ZWwdN58V197RLnvgVbH4rPQ4h4ciFTuJLiuL4fQEDBTe8QvQyliIeyDhNhdny5JAXM
         pIV12i81KnzVJuDTM12IcET/Jig2SJXw8sz0CD+V5S4157lzJS8A3E4jXXpJ8sqKOlJ5
         U/LQ==
X-Gm-Message-State: AOAM532A8uk7eMkbTdhsCsNT6iWI00ELRsv7BvIYB7EqbPP6NZ4yflmN
        SvnUJ9kX1dgaAH83ISd3fWE+ow==
X-Google-Smtp-Source: ABdhPJwpzln+cmk6xuo+GBK/V8sev59TI12TEYWN4Q4jok1Tu4vItFDTWfN7+4lRAlhHJH1dFTCkrw==
X-Received: by 2002:a5d:5262:: with SMTP id l2mr13983077wrc.131.1635343222402;
        Wed, 27 Oct 2021 07:00:22 -0700 (PDT)
Received: from google.com ([95.148.6.207])
        by smtp.gmail.com with ESMTPSA id o17sm3750549wmq.11.2021.10.27.07.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 07:00:21 -0700 (PDT)
Date:   Wed, 27 Oct 2021 15:00:20 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 1/1] io_uring: fix double free in the
 deferred/cancelled path
Message-ID: <YXlbdJRa6kTu2GEz@google.com>
References: <20211027080128.1836624-1-lee.jones@linaro.org>
 <YXkLVoAfCVNNPDSZ@kroah.com>
 <YXkP533F8Dj+HAxY@google.com>
 <YXkThoB6XUsmV8Yf@kroah.com>
 <YXkVxVFg8e5Z33zV@google.com>
 <YXlKKxRETze45IPv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YXlKKxRETze45IPv@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Oct 2021, Greg KH wrote:

> On Wed, Oct 27, 2021 at 10:03:01AM +0100, Lee Jones wrote:
> > On Wed, 27 Oct 2021, Greg KH wrote:
> > 
> > > On Wed, Oct 27, 2021 at 09:37:59AM +0100, Lee Jones wrote:
> > > > On Wed, 27 Oct 2021, Greg KH wrote:
> > > > 
> > > > > On Wed, Oct 27, 2021 at 09:01:28AM +0100, Lee Jones wrote:
> > > > > > 792bb6eb86233 ("io_uring: don't take uring_lock during iowq cancel")
> > > > > > inadvertently fixed this issue in v5.12.  This patch cherry-picks the
> > > > > > hunk of commit which does so.
> > > > > 
> > > > > Why can't we take all of that commit?  Why only part of it?
> > > > 
> > > > I don't know.
> > > > 
> > > > Why didn't the Stable team take it further than v5.11.y?
> > > 
> > > Look in the archives?  Did it not apply cleanly?
> > > 
> > > /me goes off and looks...
> > > 
> > > Looks like I asked for a backport, but no one did it, I only received a
> > > 5.11 version:
> > > 	https://lore.kernel.org/r/1839646480a26a2461eccc38a75e98998d2d6e11.1615375332.git.asml.silence@gmail.com
> > > 
> > > so a 5.10 version would be nice, as I said it failed as-is:
> > > 	https://lore.kernel.org/all/161460075611654@kroah.com/
> > 
> > Precisely.  This is the answer to your question:
> > 
> >   > > > Why can't we take all of that commit?  Why only part of it?
> > 
> > Same reason the Stable team didn't back-port it - it doesn't apply.
> > 
> > The second hunk is only relevant to v5.11+.
> 
> Great, then use the "normal" stable style, but down in the s-o-b area
> say "dropped second chunk as it is not relevant to 5.10.y".

Just to clarify, by "normal", you mean:

 - Take the original patch
 - Apply an "[ Upstream commit <id> ]" tag (or similar)
 - Remove the hunk that doesn't apply
 - Make a note of the aforementioned action
 - Submit to Stable

Rather than submitting a bespoke patch.  Right?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
