Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F0043CC8E
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhJ0Oof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 10:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhJ0Ooe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 10:44:34 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FA4C061570
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 07:42:09 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d3so4566393wrh.8
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 07:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VJ5q2bIPzwBUEYk6Imk/385wk0jHO1MD7bOFpHNONIc=;
        b=VDzUHaMvd+r7etLtk3KoShKIAARjA4qa+Pz7H6GY+F5rpVTNxCFa/D/uHAmLA8Tfw2
         85VqWERD4i3brDUf/d58kCFtg18duJSTl9+3iOhUoHokCbC+3uKzRiXEZqmV9czkCEJL
         WL2o3JVcddjSRdphCh8vOZz+v/5C1TBXbJIQ+k88bkbFRvocJbQoB+eNclO+7h7IhSPk
         Sd9bWhI8dmdS9GeS6ZCYBJiDSGD0RziQv8ghodhmLkq0PcP5tKi1ehiluX2NbeUEuXjB
         m7rnkOOQlqibjlvZQRVg5GZ4Ngfn2HeoHZJuo69zdQPEiYCeHEz1PDkLXJ+1Ao73EAD/
         x8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VJ5q2bIPzwBUEYk6Imk/385wk0jHO1MD7bOFpHNONIc=;
        b=R6gqQUBb4hbRBGUuiWQjDuAqGdlwSYwd0+rGUVtLkZPW8eWHg78BToP+d4uyUCRwFE
         cVQo4OZX/GKEcse4yp/ANGSVxFCedch4KGD3K0EtadifHI0P5N8BNfB8wrZGOaYg5VXA
         +mrW1yj7Q/jGUMuMQfW2Uaf0hYDcQKvL1A+SNtHf1IL8PgGzFJvc4D9YSyHPhOTdvdSn
         ZIMNKmtAPx4SCeJD2SfCXCMwq3uKmGk1EDNvUlhH2dCtCPkK2EdAyhecmZxSLYqJysdk
         fBXz0rzDHDlVL5YNp9nTjaZcNDQWGu3O+1Vm/BHmMLfLCuXSu/LkU3e2KpXVTebNPr8j
         wF3A==
X-Gm-Message-State: AOAM531mfx+PT/yYIONqQ5aCUZhmr8JpNUXke1sqphyaB4DBfEYb9mhB
        txPV82fPvLPAo0rTRUtCZZI05T4zGKj6EQ==
X-Google-Smtp-Source: ABdhPJyyXpkedUauKUpN88idrfkMP7XxzvEs2cNPQz+Wf4koEQeiMHbMWGSj2FWwB6VnZ7szARhGvA==
X-Received: by 2002:a5d:47ca:: with SMTP id o10mr40521590wrc.360.1635345727832;
        Wed, 27 Oct 2021 07:42:07 -0700 (PDT)
Received: from google.com ([95.148.6.207])
        by smtp.gmail.com with ESMTPSA id t1sm92487wre.32.2021.10.27.07.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 07:42:07 -0700 (PDT)
Date:   Wed, 27 Oct 2021 15:42:05 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 1/1] io_uring: fix double free in the
 deferred/cancelled path
Message-ID: <YXllPeUFIcuYc2z3@google.com>
References: <20211027080128.1836624-1-lee.jones@linaro.org>
 <YXkLVoAfCVNNPDSZ@kroah.com>
 <YXkP533F8Dj+HAxY@google.com>
 <YXkThoB6XUsmV8Yf@kroah.com>
 <YXkVxVFg8e5Z33zV@google.com>
 <YXlKKxRETze45IPv@kroah.com>
 <YXlbdJRa6kTu2GEz@google.com>
 <YXlkYWPlz3TwNH7Z@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YXlkYWPlz3TwNH7Z@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Oct 2021, Greg KH wrote:

> On Wed, Oct 27, 2021 at 03:00:20PM +0100, Lee Jones wrote:
> > On Wed, 27 Oct 2021, Greg KH wrote:
> > 
> > > On Wed, Oct 27, 2021 at 10:03:01AM +0100, Lee Jones wrote:
> > > > On Wed, 27 Oct 2021, Greg KH wrote:
> > > > 
> > > > > On Wed, Oct 27, 2021 at 09:37:59AM +0100, Lee Jones wrote:
> > > > > > On Wed, 27 Oct 2021, Greg KH wrote:
> > > > > > 
> > > > > > > On Wed, Oct 27, 2021 at 09:01:28AM +0100, Lee Jones wrote:
> > > > > > > > 792bb6eb86233 ("io_uring: don't take uring_lock during iowq cancel")
> > > > > > > > inadvertently fixed this issue in v5.12.  This patch cherry-picks the
> > > > > > > > hunk of commit which does so.
> > > > > > > 
> > > > > > > Why can't we take all of that commit?  Why only part of it?
> > > > > > 
> > > > > > I don't know.
> > > > > > 
> > > > > > Why didn't the Stable team take it further than v5.11.y?
> > > > > 
> > > > > Look in the archives?  Did it not apply cleanly?
> > > > > 
> > > > > /me goes off and looks...
> > > > > 
> > > > > Looks like I asked for a backport, but no one did it, I only received a
> > > > > 5.11 version:
> > > > > 	https://lore.kernel.org/r/1839646480a26a2461eccc38a75e98998d2d6e11.1615375332.git.asml.silence@gmail.com
> > > > > 
> > > > > so a 5.10 version would be nice, as I said it failed as-is:
> > > > > 	https://lore.kernel.org/all/161460075611654@kroah.com/
> > > > 
> > > > Precisely.  This is the answer to your question:
> > > > 
> > > >   > > > Why can't we take all of that commit?  Why only part of it?
> > > > 
> > > > Same reason the Stable team didn't back-port it - it doesn't apply.
> > > > 
> > > > The second hunk is only relevant to v5.11+.
> > > 
> > > Great, then use the "normal" stable style, but down in the s-o-b area
> > > say "dropped second chunk as it is not relevant to 5.10.y".
> > 
> > Just to clarify, by "normal", you mean:
> > 
> >  - Take the original patch
> >  - Apply an "[ Upstream commit <id> ]" tag (or similar)
> >  - Remove the hunk that doesn't apply
> >  - Make a note of the aforementioned action
> >  - Submit to Stable
> 
> Yes.
> 
> > Rather than submitting a bespoke patch.  Right?
> 
> Correct.

Got it, thanks.  Wilco.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
