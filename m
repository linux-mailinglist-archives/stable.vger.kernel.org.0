Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9256BB6588
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 16:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfIROJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 10:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfIROJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 10:09:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 017D2218AF;
        Wed, 18 Sep 2019 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568815797;
        bh=fiuiRVJ1fZdnx/CWlyqok8rfVCycNLo2lTBkY+5k/RQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S6zBV4RmArHz9F0e/v6RPXOrSyY4VIqYoRcxP7G2TRj0R81lrUIOlp1t+zfmv/5eu
         c22QSgikb4JTFMElcvKplelcZYC3Iyo3b+C+P7Lzu8R6CwMyCozdFyPojJwAvXgxLv
         +QNaE84O9oUbzoW3l8Zeeee3SOMDog7Lx+/EcBqE=
Date:   Wed, 18 Sep 2019 16:09:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, will@kernel.org,
        kernellwp@gmail.com, Matt Delco <delco@chromium.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: coalesced_mmio: add bounds checking
Message-ID: <20190918140955.GA1920517@kroah.com>
References: <1568815302-21319-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568815302-21319-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 04:01:42PM +0200, Paolo Bonzini wrote:
> From: Matt Delco <delco@chromium.org>
> 
> The first/last indexes are typically shared with a user app.
> The app can change the 'last' index that the kernel uses
> to store the next result.  This change sanity checks the index
> before using it for writing to a potentially arbitrary address.
> 
> This fixes CVE-2019-14821.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5f94c1741bdc ("KVM: Add coalesced MMIO support (common part)")
> Signed-off-by: Matt Delco <delco@chromium.org>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reported-by: syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com
> [Use READ_ONCE. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/coalesced_mmio.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)

Also looks good to me.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
