Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAF82C9F15
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 11:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgLAKYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 05:24:40 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33744 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgLAKYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 05:24:40 -0500
Received: by mail-lj1-f195.google.com with SMTP id t22so2059144ljk.0;
        Tue, 01 Dec 2020 02:24:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JWonEAgpgF7EYqcl/vsME9uiualwG4Qmy0o/voi1XaU=;
        b=b358XQ6RM5cQ4ps1WA/zshCenTT0PIiv8Fd2GaA6OvPaG0r3J9IfLZpzlAzHSs8rZz
         +EmhMZTFBNw7adIpBwuhOnAFAJESPcrzBnpyma5fNbrKAlbG6VbfgzmO90brAKxlmipp
         hCOX7yahbtdr8wDfMl3H20Og32klz1NklaKRzigb+D7pUV/aS/Cu8BjfvoFNkE+oQKgD
         ZvdxPAKnPlMvr+PITcyASzN13c1sgqPHDY84QqXZao/TibhwZZ5V5AGylg7Rxjfyc5eJ
         yH2ZAcGEli9E2Wf+OeTYRkU+ZVZ0vKVQQH1Gp/jct5AreaO+N1z2XhkafDzFPZnWl2NE
         QXhg==
X-Gm-Message-State: AOAM530dqE2hiXmsxlmAZ5cI1Pgb6BdBmZ8xwjGDEhPh8lij9C0wMq2Q
        gGeoOc2raTFtw4fNd2V98HU=
X-Google-Smtp-Source: ABdhPJw6hvNc5I4lTvG7mAIFJFx1bmHcYwID4AI3YQSF0IqGtt6gEZoAjfsec6wSJVwX4jlqO+UW8g==
X-Received: by 2002:a2e:b701:: with SMTP id j1mr942305ljo.242.1606818237965;
        Tue, 01 Dec 2020 02:23:57 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id x134sm153503lff.161.2020.12.01.02.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 02:23:57 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kk2pf-0006xr-1p; Tue, 01 Dec 2020 11:24:27 +0100
Date:   Tue, 1 Dec 2020 11:24:27 +0100
From:   Johan Hovold <johan@kernel.org>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Sebastian Sjoholm <sebastian.sjoholm@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: option: fix Quectel BG96 matching
Message-ID: <X8YZ23FSBpuFupui@localhost>
References: <20201201100318.37843-1-bjorn@mork.no>
 <X8YYdVk7LQ+VcpPf@localhost>
 <87tut5bzd5.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87tut5bzd5.fsf@miraculix.mork.no>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 11:21:42AM +0100, Bjørn Mork wrote:
> Johan Hovold <johan@kernel.org> writes:
> 
> > On Tue, Dec 01, 2020 at 11:03:18AM +0100, Bjørn Mork wrote:
> >> This is a partial revert of commit 2bb70f0a4b23 ("USB: serial:
> >> option: support dynamic Quectel USB compositions")
> >> 
> >> The Quectel BG96 is different from most other modern Quectel modems,
> >> having serial functions with 3 endpoints using ff/ff/ff and ff/fe/ff
> >> class/subclass/protocol. Including it in the change to accommodate
> >> dynamic function mapping was incorrect.
> >> 
> >> Revert to interface number matching for the BG96, assuming static
> >> layout of the RMNET function on interface 4. This restores support
> >> for the serial functions on interfaces 2 and 3.
> >> 
> >> Full lsusb output for the BG96:
> >
> >> Cc: Sebastian Sjoholm <sebastian.sjoholm@gmail.com>
> >> Cc: linux-stable@vger.kernel.org
> >> Fixes: 2bb70f0a4b23 ("USB: serial: option: support dynamic Quectel USB compositions")
> >> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> >
> > Thanks, Bjørn. Now applied.
> 
> Thanks. But I see that I managed to type the stable address wrong.
> Sorry.  Hope you can get that fixed somehow.

Yeah, I noticed when replying. Now fixed up.

> Patch for checkpatch next, I guess...

Heh, a potentially useful addition for a change. ;)

Johan
