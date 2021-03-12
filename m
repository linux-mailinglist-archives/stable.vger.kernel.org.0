Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D6433975D
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 20:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhCLTZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 14:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbhCLTZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 14:25:00 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A88C061574;
        Fri, 12 Mar 2021 11:25:00 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id w195so21319343oif.11;
        Fri, 12 Mar 2021 11:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gVKeHQoZbkOidQdqGdRN0fvY10dKG4Cgtuzyr5zJOr8=;
        b=j22POcc4iWsATwLLchiaZEW+owMAwtrYK5+qIQklEd9Fq7A0BRQb2bMyjxZ4WgN4fU
         AVoGd9Efncu6NWF42KY9JDI1qwtsXkicl3hw4xIEHp5P3Gs5sd0kblQ0LtPeWZIBgX0L
         t0kNfm7aa3Ph2yK2GU/GSqqqSKDqN++by68snh82OvVIJQrNC/LpailBfieBB22T3io3
         /rYWWm2jm4PNRTLj5mrhplfhZ8C9AyYQa9vh1Y/DmRF89yAJ51NVYrVT9MN2WApuzVRr
         Fg8/PRPLkWfr6K2PJzJecWYbUA80bi1FwCKV8fPSdzeh+Yx0aV+E2sxTPKU7xAwE3jFy
         VLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gVKeHQoZbkOidQdqGdRN0fvY10dKG4Cgtuzyr5zJOr8=;
        b=tQzN+auWdCK5clz4jCf6ilbXlmbfwgTfpwnn1idn2ZBzh11j45ZaVNIli5iZHHwwf7
         MiBS32FyTjaWflj5WFdaaWz99lVSrmxnoMd1cS2FCzA9zvnIH0LUtPTP5i9zsDVvofdI
         JFNzr9I6zRhPfatGceCzYwA7etEFqv3ty6e9bWGMjqiEjzenLaln5YL48nEjW8WzhMzJ
         MvpLSt5cCwIecAptGW+1XmSjV8ujgoDMcCl+aUGJLHnN6mx7phUqh6eFz41NsLuuable
         J6BWULRW43ZotMpAGyLSj6OnRIaCdqookP3YF87KiVjxgCtxLNVVd2nmOcG09VdhlPww
         3kjw==
X-Gm-Message-State: AOAM530Kg3kydHgXSFa4wucfE6FuKXRd1ViAGuqFMb4NyvfCdQay0I/O
        1A36gGR/8fsj0dIUNK5EhFM=
X-Google-Smtp-Source: ABdhPJy25Fz2DzdIX3FOF+rvIVhYoARYFKIx2T5oQftgFKNU0x5bTqsKsq4L3QSWVsl1MZ6QvpXmrA==
X-Received: by 2002:aca:f086:: with SMTP id o128mr2096964oih.85.1615577100020;
        Fri, 12 Mar 2021 11:25:00 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t19sm1828601otm.40.2021.03.12.11.24.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Mar 2021 11:24:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 12 Mar 2021 11:24:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     stable@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-hwmon@vger.kernel.org, Guohan Lu <lguohan@gmail.com>,
        Boyang Yu <byu@arista.com>
Subject: Re: hwmon: (lm90) Fix max6658 sporadic wrong temperature reading
Message-ID: <20210312192457.GA17220@roeck-us.net>
References: <20210304153832.19275-1-pmenzel@molgen.mpg.de>
 <20210311221556.GA38026@roeck-us.net>
 <9243482c-0a34-d6d1-1955-bee00a75554f@molgen.mpg.de>
 <d4756f39-3a4b-7348-c49b-25701e31f99b@roeck-us.net>
 <02b9c3fe-5961-6a23-3fd0-6d7687867fb1@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02b9c3fe-5961-6a23-3fd0-6d7687867fb1@molgen.mpg.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 05:53:49PM +0100, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> Could you please apply commit 62456189f3292c62f87aef363f204886dc1d4b48 to
> the Linux 4.19 stable series?
> 

v4.9.y..v1.19.y, actually, please.

Thanks,
Guenter
