Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50928DB59
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfHNRYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:24:21 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39909 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729191AbfHNRYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 13:24:20 -0400
Received: by mail-ed1-f68.google.com with SMTP id g8so1517590edm.6
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 10:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T3esLEuHvcHBDKeS44Dlxzgj16ZGe90Wnaw14SiLC6E=;
        b=CqqMWX3gUNMnm4h8mhKJO+3gyrAbIK/Q8ElN6LwKqSQinmE3OvInDx6wzXjqiM2ndX
         /A0wWOLdTfc6+pmlAODlL9seeB3uDEdoE8MgK5uYYn66tpmIyREpKrkhYDZPj6W5emwL
         oJJGHxlCKvH6BCOEenRMUgzHGUYf84ThYAjG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=T3esLEuHvcHBDKeS44Dlxzgj16ZGe90Wnaw14SiLC6E=;
        b=DsNgwr8UDx0pICQgkue0fp5wAUL6fODQ90sUXDWwdK8MWHH3aCvD+T38QSlNPygG34
         pgptZUCx4FSaIwUGKXFzdCoL4h4pHAITQXW9ALdb5XYUX5K125D/kOtEbisVau+vZJL0
         3or1nWpOxDJqfr+xvaz+w+jy4fAhvhlDfiItpD3WR5Ui3jfjmcVmX6pmLKFqx7ZBDSUT
         WOkBiWvsHZXjJpf2UKeHKh9isgKOZLeUMxn9cIdmidl56r44PwlAs/xPWeuUW5ptR1C6
         2e/UrP8yIoLHd9lL5L86j2slVHO52yZSRZKz1oCRxBwJquWlAXnO29Qn25ZsQMkgwWg0
         iiiQ==
X-Gm-Message-State: APjAAAV4E/ScVEw1BuxLQJJ0RwWF7okCxZ8Rkuq739E7pZTv/+T4eYzf
        KnpQm+ySzbdlTB+31pF6ugPObA==
X-Google-Smtp-Source: APXvYqxnSM2oBc0b/HZFh2/UJm5weJKUxzZHuzDZdcLlO5+ialydTPWw0kXkytQ0nR4G9r1rM2Pssg==
X-Received: by 2002:a17:906:6bd4:: with SMTP id t20mr634986ejs.294.1565803458771;
        Wed, 14 Aug 2019 10:24:18 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id oh24sm31281ejb.35.2019.08.14.10.24.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 10:24:18 -0700 (PDT)
Date:   Wed, 14 Aug 2019 19:24:15 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org,
        Gustavo Padovan <gustavo@padovan.org>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Sean Paul <seanpaul@chromium.org>
Subject: Re: [PATCH] dma-buf/sw_sync: Synchronize signal vs syncpt free
Message-ID: <20190814172415.GN7444@phenom.ffwll.local>
References: <20190812154247.20508-1-chris@chris-wilson.co.uk>
 <20190812190548.450CF20684@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812190548.450CF20684@mail.kernel.org>
X-Operating-System: Linux phenom 4.19.0-5-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Aug 12, 2019 at 07:05:47PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: d3862e44daa7 dma-buf/sw-sync: Fix locking around sync_timeline lists.
> 
> The bot has tested the following trees: v5.2.8, v4.19.66, v4.14.138, v4.9.189.
> 
> v5.2.8: Build OK!
> v4.19.66: Build OK!
> v4.14.138: Build OK!
> v4.9.189: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

The backporting instruction has an explicit # v4.14+ in there, so failure
to apply to older kernels is expected.

Can you perhaps teach this trick to your script perhaps? Iirc we're using
the official format even.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
