Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564C822FBBD
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 00:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgG0WBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 18:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgG0WBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 18:01:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15297C061794;
        Mon, 27 Jul 2020 15:01:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k18so2609659pfp.7;
        Mon, 27 Jul 2020 15:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0cGq0/NNCapzBCBRu3Zhft71fdG1zuIbVle88q2wLsE=;
        b=CY++EJxUKM8JtMI7Hl8THeQ9Rw6M9rxGAlrbMyprkLS7Gd5fyzoGBydsvMp3MPWa77
         BCcWQFOQtHNYSVDR/+GZHSUyXHGX6jkRYnUWfN5T1hVtKIEYXRwHDA12HJ7UXpnEzzTW
         7D7DuZz5YKz/VuiFJSc79kapow0kGVyYzxgvkkd2Zj4C9rh7G16WFnMtf0HHCiHlrg9X
         q23EM6LeJxgCDtpdJAaUZ8tyv3OWTyJRKUtLhKNcE+8xuWPYKbK277eLRUKv7CuosbdC
         89w/Cf5X3xTRcfhxgq0XXY5eChotc6RbEpj18PzDCNGdQVP37xt3juXrnjN6eQCyTVXD
         lSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0cGq0/NNCapzBCBRu3Zhft71fdG1zuIbVle88q2wLsE=;
        b=Q3FYnsTPIdHyh74Z5qg2P53zFMSlp6q9lCA/cqXp9ZO/QSU+YvEJj0AE97ktE3gwjf
         pWigC0mQAEHghbSFunyiQYoZ3f4EHCLTjS8ey58lWhAj5l7v/gpo5oQWw8e8MwVFZPja
         uH/9QUWGcX+dBRtHejrHT0ifGn7lJPvVqbqOXZpFioqF6i2tfWYkle9h88gc80oO5ij1
         UlPKxkkgUZWGGphQOzLp2yb5yzBwjgtLhfJh2l2tMDsujhgDKbcxaVf9hsoWhkrT4qfV
         xDzLbIWhXe7qF3zzCh2JMjOlCsCRH2fmk5twbI5TyUgMIqIgx7766uhkxSQwuDALGBxT
         mnfg==
X-Gm-Message-State: AOAM533DtEEUM3pQJlJz2X0OO5wa/Ld4HcQbiSGioZ84ZSksMwWYeEZa
        SjiK8H5d+jl2zJUBTGjHO867BT096Sg=
X-Google-Smtp-Source: ABdhPJzu8Vg3yNexLP9qwEj4iZCHcXlK98zdMfv9I8DwCU/xhltm+yiiRNMl9NPtgFuKKO07OqIYGg==
X-Received: by 2002:a62:84d5:: with SMTP id k204mr20610517pfd.66.1595887274529;
        Mon, 27 Jul 2020 15:01:14 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id g5sm578460pjl.31.2020.07.27.15.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 15:01:14 -0700 (PDT)
Date:   Mon, 27 Jul 2020 15:01:12 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Derek Basehore <dbasehore@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 54/86] Input: elan_i2c - only increment wakeup count
 on touch
Message-ID: <20200727220112.GV1665100@dtor-ws>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134917.124943291@linuxfoundation.org>
 <20200727212933.pkt6kgescdz7akht@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727212933.pkt6kgescdz7akht@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 11:29:33PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Derek Basehore <dbasehore@chromium.org>
> > 
> > [ Upstream commit 966334dfc472bdfa67bed864842943b19755d192 ]
> > 
> > This moves the wakeup increment for elan devices to the touch report.
> > This prevents the drivers from incorrectly reporting a wakeup when the
> > resume callback resets then device, which causes an interrupt to
> > occur.
> 
> Contrary to the changelog, this does not move anything... unlike
> mainline, it simply adds two pm_wakeup_events.
> 
> It may still be correct, but maybe someone wants to double-check?

Good catch, I believe the backport is busted.

Thanks.

-- 
Dmitry
