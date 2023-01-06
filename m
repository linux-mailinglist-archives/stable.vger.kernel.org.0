Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A00F6605EE
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 18:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbjAFRuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 12:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbjAFRuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 12:50:01 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF79E625FA
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 09:50:00 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id z16so1970752wrw.1
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 09:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MEWcai/0BTUSDXzlv/9ZnddHBUgd9q90oSNrTCd/iAE=;
        b=hkasdKR/OrqmQwA/oOWmPJTk7z6ETkOAnL/+a1hwca7i4k8ududHCU7HQbUMGoP+qW
         Uw1kYQ2NTYX+GOukmMyi/bR5ErlLtQqAnJdJ2bagG5WkAe3w1XbjORO4Qr+yOgg+9g3Q
         Mf1s4J2Xy6cIj76SMWXp0VGHGG3zAIgDoQ+Mo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEWcai/0BTUSDXzlv/9ZnddHBUgd9q90oSNrTCd/iAE=;
        b=Zq6D+v9vfDolZRp9KC7KchnMqhVpRNvDc/rYCJoqjz/ID7htusJ0H2LRkwwfvU/pKj
         DeFZyKO4NxpCR5gsDocCbC3/gUjyxmiYL5DMx8e3rIardPESqVfsQhlQiRvQlygsTuSe
         20wVXyWrlvMBjgdgMYNxYJWGFE5RzIQhjGfXz7dmvpisKnfXzjIlzL44ePli5Hhi8llN
         fTPSjszEVUh2gJJMSghOSQVZBljqW0JBChkpjLUSx7m7rmUwWjN6otD06oc0AlYwwoMn
         Z96qSjf1/p1JZ8qYfn8nCP5SdULYCzlt2OZQc+4Ae21elIl2g5e9w+KIFcR4I9lpjtw5
         JINg==
X-Gm-Message-State: AFqh2ko+aVGRyuAqqclglydEkGFG1UJKfWQtkZLxrc2hRuMq9nR+jXzR
        pXduixUSoDQ0Xx4cHIH8HuthnQ==
X-Google-Smtp-Source: AMrXdXsSQA1sZlk78KWMQ3ZlByTzU+qPddwuRA0IvEpJPokqzlPt1nfac/dSnY9a55WhImAedfMMaw==
X-Received: by 2002:adf:f4c1:0:b0:27e:7f5:6634 with SMTP id h1-20020adff4c1000000b0027e07f56634mr26567517wrp.60.1673027399535;
        Fri, 06 Jan 2023 09:49:59 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id o12-20020adfe80c000000b0024258722a7fsm1710958wrm.37.2023.01.06.09.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 09:49:58 -0800 (PST)
Date:   Fri, 6 Jan 2023 18:49:56 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Sean Paul <seanpaul@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/atomic: Allow vblank-enabled + self-refresh
 "disable"
Message-ID: <Y7hfRNHMjk5H+muj@phenom.ffwll.local>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
        Brian Norris <briannorris@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Sean Paul <seanpaul@chromium.org>, stable@vger.kernel.org
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <Y7fH88gNfja364JD@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7fH88gNfja364JD@kroah.com>
X-Operating-System: Linux phenom 5.19.0-2-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 08:04:19AM +0100, Greg KH wrote:
> On Thu, Jan 05, 2023 at 05:40:17PM -0800, Brian Norris wrote:
> > The self-refresh helper framework overloads "disable" to sometimes mean
> > "go into self-refresh mode," and this mode activates automatically
> > (e.g., after some period of unchanging display output). In such cases,
> > the display pipe is still considered "on", and user-space is not aware
> > that we went into self-refresh mode. Thus, users may expect that
> > vblank-related features (such as DRM_IOCTL_WAIT_VBLANK) still work
> > properly.
> > 
> > However, we trigger the WARN_ONCE() here if a CRTC driver tries to leave
> > vblank enabled here.
> > 
> > Add a new exception, such that we allow CRTCs to be "disabled" (with
> > self-refresh active) with vblank interrupts still enabled.
> > 
> > Cc: <stable@vger.kernel.org> # dependency for subsequent patch
> 
> "subsequent" doesn't mean much when it is committed, give it a name
> perhaps?

It also looks a bit funny tbh, and a bit much like duct-tape. I need to
think through how this is supposed to work really.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
