Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5351E269E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 18:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgEZQPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 12:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgEZQPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 12:15:07 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A6FC03E96D
        for <stable@vger.kernel.org>; Tue, 26 May 2020 09:15:07 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x11so7877288plv.9
        for <stable@vger.kernel.org>; Tue, 26 May 2020 09:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IdTmx5bvE+V1cAcFJI98GnDSoP0mb5MfVH5Axb1TejM=;
        b=YNNvSaANvznznsq6NwzIsZWeDzc27QMCyU/RLQFt132rryBivrtEuaFvxLjynP9vOC
         lrwK6MQNyNlvBZmT/WVxhaRyPcDs+pAsTRKf58LrEcBxV4nseo6f1t3PdSvmHFV4uf0H
         g1OP43Bipju2hrlrFmsJXumIB96rviCx8CjEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IdTmx5bvE+V1cAcFJI98GnDSoP0mb5MfVH5Axb1TejM=;
        b=tZr9M4EMRXrK0mXiEjKSwhMdL/SZxK6aKam8udIBZZHsIdACng4nTHyXV06ywZ+6yj
         cclTkWUtsg0e/x89lUoWftBApd/IDunAIjb6xtmdCE1jZyQwrouDBD0Ec03i3LxjULwP
         fT8nPI0csmHqejjrMVDVjS5fmVwBfnX/sLXQwJz+goCm58+qGS34/pplwaMb97JeeNX/
         l/uud1eD/VZHwcp6jtiFXxulcdLEcvfr0V24RJhwsYj3QVQcVukM8M471V4PgQ/assVL
         2zckh0sFkFaAytNbj6S8Jy4cZBh/YmukdUW48Kz833zLbtOpiBpQ2wEwDokiL/3trqNc
         z2RA==
X-Gm-Message-State: AOAM532BLr2X7m6MXI+0VEeUR7/JoC9w9HD1DFscqas1CFYBirwW63pJ
        QQUcIduvOcWjCi3ff5by6e8dGA==
X-Google-Smtp-Source: ABdhPJzdYWXboruOLBkXnWjJPQ/weKAztCxQPCSyM3XiKpaGg2ZHsjoGl/AuQAdP804jyn88zCCNbg==
X-Received: by 2002:a17:90a:2a8e:: with SMTP id j14mr21920pjd.136.1590509706847;
        Tue, 26 May 2020 09:15:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g18sm33078pfq.146.2020.05.26.09.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 09:15:06 -0700 (PDT)
Date:   Tue, 26 May 2020 09:15:04 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        Andi Kleen <ak@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <202005260912.8867B3AA@keescook>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526065618.GC2580410@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> What about those systems that panic-on-warn?

This is (modulo the general discussion about whether it's the right
way to check) the correct use for WARN*(). It's an undesirable system
state; people choosing panic-on-warn want this:
https://www.kernel.org/doc/html/latest/process/deprecated.html#bug-and-bug-on

-- 
Kees Cook
