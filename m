Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109D235CEE3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245310AbhDLQvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345701AbhDLQrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 12:47:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466CBC06138C
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 09:44:30 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l76so9840169pga.6
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 09:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UNKlEmkrm49jut0y7GXEHhj3JtBxtOY6CZ0/T47VW+A=;
        b=PKmo4cDbkWbiYVfjzK2Ksy54pySWRIezSHMyLJCHrThM1gOCO7wtrzhAQLFjKmIlEt
         I05Z9NlSVfNkbcfiF6xWFE1AnjM5CcJXsUms3Aqpr4GjBFwIzcg6MLltvn6FnVIIaeGm
         0t8bAqH+GVy0bnAenbS0jyGAdmb/kTXraT5bfUehxullUlpa+Nax2BLTlNPGDq8U8Qv0
         7Z2cNi5BpMuRQvIsYyqkeK+pri5eJnoY0wtfqrTMkKs/sior52Kxx1+DcamnU2T0R/7h
         AGkkUctqryGjTrf96qaaHJCUsjv2i9s576PfULsufD3srABNN2i3GPh7nok3vz7OTGCg
         uTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UNKlEmkrm49jut0y7GXEHhj3JtBxtOY6CZ0/T47VW+A=;
        b=tSLiC8BFg9nCg2Cjukwx+6lV6h+FYHLTnBLOgdGZ3gmUmCCCInoHgbQbylXxz897+N
         gs2M4/4c6h5ANUQwZVNFuFxxg4VWEbvcW/J1u2d2n0zZ+mWdoUZ8IuPFDtTAwB3JHKZT
         qXpyH9VCbPuvkPzZXNIDbOguOGWuguwN0NQ8b/UG/bokYlggYsfguHWXs8qz4cPytlv3
         5PIX55Q3WRwtIDGdcgOkrWR3jmLK8RsDEjWNbi1f2iEj33G6xoH2oVTaXZ6AQSTfEDyE
         /UjKI4PlRxxbBaicTWWkuo4Ped5ClVLGwy7fVOGcJyc1wyV1B1Yc8t35sv6AIbd/qucc
         vnwA==
X-Gm-Message-State: AOAM531eitlBLhX57TklZFJZ5CvUTw+FVcwKJz8bb5jkD0Rp3oiXHU1G
        7HMZ7+CyfTVIroZqSy/u0viiIFdrvzfbTA==
X-Google-Smtp-Source: ABdhPJzlg9ARJA0G+N4vWrWO0YlJkkfzs+HFSg93Ry3NvnX3nB2wWAJBm+xJwNb3b5F71nLS9OI+ZA==
X-Received: by 2002:a63:5f88:: with SMTP id t130mr28388924pgb.403.1618245869753;
        Mon, 12 Apr 2021 09:44:29 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c9sm9518158pfl.169.2021.04.12.09.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 09:44:29 -0700 (PDT)
Date:   Mon, 12 Apr 2021 16:44:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, kvm@vger.kernel.org, sasha@kernel.org
Subject: Re: [PATCH 5.10/5.11 0/9] Fix missing TLB flushes in TDP MMU
Message-ID: <YHR46QCe/ivBNZKR@google.com>
References: <20210410151229.4062930-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210410151229.4062930-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 10, 2021, Paolo Bonzini wrote:
> The new MMU for two-dimensional paging had some missing TLB flushes
> in 5.10 and 5.11.  This series backports some generic improvements
> to simplify the backport in the last four patches.

Did a quick read through, didn't see anything obviously broken.  Thanks Paolo!
