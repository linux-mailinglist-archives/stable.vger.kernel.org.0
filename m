Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D71F39215E
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 22:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhEZUV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 16:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbhEZUV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 16:21:28 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C16C061574;
        Wed, 26 May 2021 13:19:55 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f22so1900428pgb.9;
        Wed, 26 May 2021 13:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lTaZiSjHTYTfLBHw5KYDWGju9wq7Uxw21u2vrmX0bvQ=;
        b=ucgC07yjyCuw/DuoBl3D5TOpZELZZziy2tecqB2NV+JF1VR6wza2xYWRoDEpf99NbV
         YFtcpqGiIsBDwTuxuYyX7lBj0Zrlvtj3PLfouybsA4/+VbR27IPj0dD0JNCgQ1Z3NagO
         k+Ws3MviqWhp8GKt+7z/6slw3Nw6nlTHMPqUMeQWC9cyGaHmTDBu0G2dbuSp7lBu2dHI
         Codjh7G1QDHKRTInQoAtyS51Iy10g8mdSuzDBbD9x40yp+gK/WxlHAaI9zEyTVqaQBTK
         s4H0AhnuUIArt7PCoaFuObcDAj+8l++kikY2EzTTib9LApw9m0L58ZLH1JUZ1EwCJtvc
         dP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lTaZiSjHTYTfLBHw5KYDWGju9wq7Uxw21u2vrmX0bvQ=;
        b=k+CvBSUblSsi2R+xwyYKISdbgEGE4XMIuYYMX0U1PKheDC7sfeXJXAKqmjxulzPqRM
         nu9HNgI2C624mdTm4EJE6NDSOColqouzzUYECU05Xp767sgLyqGz/xQu29sEsD3mf7CY
         RPVs1gEgfrQslbb6CqtvLAGuXezoYhjwIG2rMAhVgsvgnciseoYEmkDgKIEqIYUnPSRc
         zhH3/zZgF9VRqRMNOz94O6MdLyjFzV+yS1Tn9zEODjeejS6+Nk+CTQNb+tx0/yK5MKNI
         nj6zlOnQYdnyBj3yya1cpFSylzvX+8/kEekWQLFAas+boQeEV1AfSIfvzsALoWNy/5WH
         /fgQ==
X-Gm-Message-State: AOAM532zFZVCflMdaTGmqDltQ876nqxmsX2Y5Wr196MkrL1bXOwtYiJ9
        KxW0MUcjufhK8uBgRdOxnyY=
X-Google-Smtp-Source: ABdhPJxVoGyB4misgrEphjTViOIytDe6a29L9584OK26YgihQux54kY6mI9t4UGMCgO9oyknUmP0CA==
X-Received: by 2002:a63:2dc4:: with SMTP id t187mr241278pgt.80.1622060394761;
        Wed, 26 May 2021 13:19:54 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:bf6f:1c57:1da9:bcbb])
        by smtp.gmail.com with ESMTPSA id y13sm197351pgp.16.2021.05.26.13.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 13:19:53 -0700 (PDT)
Date:   Wed, 26 May 2021 13:19:51 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Input: elants_i2c - Fix NULL dereference at probing
Message-ID: <YK6tZy3E/XZpOAbh@google.com>
References: <20210526194301.28780-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526194301.28780-1-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Takashi,

On Wed, May 26, 2021 at 09:43:01PM +0200, Takashi Iwai wrote:
> The recent change in elants_i2c driver to support more chips
> introduced a regression leading to Oops at probing.  The driver reads
> id->driver_data, but the id may be NULL depending on the device type
> the driver gets bound.
> 
> Add a NULL check and falls back to the default EKTH3500.

Thank you for the patch. I think my preference would be to switch to
device_get_match_data() and annotate the rest of the match tables with
proper controller types.

Thanks!

-- 
Dmitry
