Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60DD140043
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgAPXxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:53:48 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39352 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgAPXxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 18:53:47 -0500
Received: by mail-pg1-f194.google.com with SMTP id b137so10723867pga.6
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 15:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nwuUu0rd+ezmfVCeASoxtHfEplm0p4vYcMmPm2DgncM=;
        b=d5eqpW0hfMdPXymgExL01D0nYXemD+Mz9BRfI3a4u/tQJr7Fhf0aR92fa9Oaz8JfB/
         AgPe6vxUW/AiQBAibkO13ZJP9kDOtvvw7P8qUWJg2n1TY51DnEwPfHVVxE7mGc1qlCRZ
         7APqOpPjUy8R3nbpInSkYMGwrYh90nK9kdBo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nwuUu0rd+ezmfVCeASoxtHfEplm0p4vYcMmPm2DgncM=;
        b=k6o8LbdcXMRfFafiMHAIuVOb4Pyi2PVfqLILCqZ7MBL2324UM1FP1pfoA3UAr+aMBD
         u8XLLrlE+phLRtqbi2VjDEiy4IdJ93F/NjV7p9ksYkFpuEwLxfa4SifcJEo/4H4nOKMq
         EHBVX8FfFi4IdZ6sC+KekQjdpBZmzcRnFPQmxBZ/6l/buaV9N5X7H/F/QGc/bCAVAI9Q
         k4qxBOtP+omIPdC7LQMMU0xE2VjFUx3ZumQHgjw6rocvcT9YqT4Sfxc/S2pnI+HO/G2F
         rUGbeU2w5RE5kpQKSaVwWAP9WZ13vVi72PgI4JlHbVzTNmNKlvu1aIUMRoiriJ4zCvzM
         u7qg==
X-Gm-Message-State: APjAAAVysc6ZoQdrT6ZFAtAg7sZGVvC+OQvyEvUtb+/c6nyfoUejMSYN
        63SlekdEtUfQFSuFTVnHVVjnjQ==
X-Google-Smtp-Source: APXvYqycvVwcBRNb8QOYs8ADNj35ltKMfqrYsONPt4dFTQI0kIgKm0ZKkXClz2Dy/qn0W2JODiuCsw==
X-Received: by 2002:a62:5c43:: with SMTP id q64mr81104pfb.194.1579218827219;
        Thu, 16 Jan 2020 15:53:47 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i17sm25853759pfr.67.2020.01.16.15.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 15:53:46 -0800 (PST)
Date:   Thu, 16 Jan 2020 15:53:45 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: missing backports for x86 syscall function prototype cleanups
Message-ID: <202001161553.F3FD9E9@keescook>
References: <202001151737.F00EC408@keescook>
 <20200116082848.GA2359@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116082848.GA2359@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 09:28:48AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Jan 15, 2020 at 05:41:07PM -0800, Kees Cook wrote:
> > Hi!
> > 
> > Sami pointed out to me that 4 of 6 patches in Linus's tree that were
> > cleaning up the x86 syscall function prototypes didn't make it into
> > -stable.
> > 
> > These were backported:
> > 
> > 8661d769ab77 ("syscalls/x86: Use the correct function type in SYSCALL_DEFINE0")
> > 	(as e79138ba8e0ec84f3ab5daa4761e4d534bbc682d)
> > f53e2cd0b8ab ("x86/mm: Use the correct function type for native_set_fixmap()")
> > 	(as a823d762a57519adeb33f5f12f761d636e42d32e)
> > 
> > But these are missing, leading to some confusion when working with v5.4
> > under CFI:
> > 
> > cf3b83e19d7c928e05a5d193c375463182c6029a
> > 00198a6eaf66609de5e4de9163bb42c7ca9dd7b7
> > f48f01a92cca09e86d46c91d8edf9d5a71c61727
> > 6e4847640c6aebcaa2d9b3686cecc91b41f09269
> > 
> > Can these get added please?
> 
> I've queued them up now.  But for 4.19, are these also needed?  If so,
> f48f01a92cca ("syscalls/x86: Use the correct function type for
> sys_ni_syscall") needs a backport for it to work properly.

I think, for now, we don't need to. v5.4 should be enough. Thanks!

-Kees

-- 
Kees Cook
