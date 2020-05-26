Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA37B1E26C6
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 18:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgEZQUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 12:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgEZQUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 12:20:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9BDC03E96D
        for <stable@vger.kernel.org>; Tue, 26 May 2020 09:20:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s69so39240pjb.4
        for <stable@vger.kernel.org>; Tue, 26 May 2020 09:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tLFWEc70kSJC3xDiyEWNVnyhuZzVWGIzcJ1Nk8rcOc0=;
        b=lOvf70PKmmBPmGfNSvXTYx9cNld/SJ4GdwXQvxyEWWWH1t24w5+WMVVyi9NbSTFCuo
         UK25Jfcc2kwV14PFFGZMUXnXGG/ZHoFAzR8a9RxeKmOFXG09X+v7nlHd/ZSRWUHPzodk
         QJfCvytXjqlRnpksslKFGoPUsAsLRdnDs5BS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tLFWEc70kSJC3xDiyEWNVnyhuZzVWGIzcJ1Nk8rcOc0=;
        b=hmzwLBYOa7/bctPXBWbC+YM1Bcsqpc02DBwCVL3KqvSiso2iya69dnLnS9YzyDNElL
         aL6Gt1ctLzy1ZcNrNim+kLXVBAXDxFlaJ4mdd/lz8nfm8n9Jqg4V5B+Fl7edPvQkYOHx
         gqn+tbvWBh1my80UQtA3gLKhDrfa6UgkYsrrCIsWsH4CqpR/brCMMDtfgXVl1keFyPH5
         qWNPEtH4/NuA3mdnw6ymiKqS8qPwS++XD6jDzR1r7GlDXp7xPJ2MlQDx5pKOMgMOoYRM
         AV9bLS6rAaCwA4z0N1LRc2vnlK5RkXabsk7zRtJUy0bvdL8tzRNxJxEKuF6BAuZ24lrQ
         Bqyw==
X-Gm-Message-State: AOAM533FFUbcVlnAHP66FiFkGYM/HQVe3TQrkDdjH0/xTgVv3xFikqSi
        lzBo9OIuPLwYVrhFP+9Zroy0Wg==
X-Google-Smtp-Source: ABdhPJxEYTpmqGrCSWR6f1rzHdEg5LhA1BVPPbzcg+Vydop3DHCm/xEy4uzlTCOqImNwTjC3mqZ4Rg==
X-Received: by 2002:a17:90a:fb96:: with SMTP id cp22mr27442990pjb.201.1590510033184;
        Tue, 26 May 2020 09:20:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b63sm46799pfg.86.2020.05.26.09.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 09:20:32 -0700 (PDT)
Date:   Tue, 26 May 2020 09:20:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andi Kleen <ak@linux.intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <202005260918.72DE289@keescook>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
 <20200526154835.GW499505@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526154835.GW499505@tassilo.jf.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 08:48:35AM -0700, Andi Kleen wrote:
> On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> > On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> > > +		if (val & X86_CR4_FSGSBASE) {
> > > +			WARN_ONCE(1, "CR4 unexpectedly set FSGSBASE!?\n");
> > 
> > What about those systems that panic-on-warn?
> 
> I assume they're ok with "panic on root hole"

Exactly. :) The pinning infrastructure is pretty small; will that just
get backported? (Also, we can probably rework the pinning to avoid the
special-casing and use a mask/value pair to notice a bit getting turned
_on_ as well...)

-- 
Kees Cook
