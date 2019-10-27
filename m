Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B927E647D
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 18:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfJ0RXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 13:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727667AbfJ0RXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 13:23:08 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9659921726;
        Sun, 27 Oct 2019 17:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572196988;
        bh=exfw+vnAV2Fh2pDrI/JnNXOfVxHPj8N6yrNMclPo1hA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v0zh+48oPYqumsWioU+FE6fyRiio76/B6gQ9H5XQhBMfzBXBz34lJutAprcMxqKLe
         zCFhDKXQZQR8cppTNhClzd1XSrzjasNM3lBFQqZBJn4zKSkXSXCJW9WQ9wKKIKdDmo
         vIjOJHr3cMIk/66Pv31liXGtp+bEmNz03c7bkl50=
Date:   Sun, 27 Oct 2019 17:00:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org, keescook@chromium.org,
        davem@davemloft.net
Subject: Re: [v4.4.y] net: sched: Fix memory exposure from short TCA_U32_SEL
Message-ID: <20191027160026.GB2311304@kroah.com>
References: <20191018190647.158575-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018190647.158575-1-zsm@chromium.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 12:06:47PM -0700, Zubin Mithra wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> commit 98c8f125fd8a6240ea343c1aa50a1be9047791b8 upstream
> 
> Via u32_change(), TCA_U32_SEL has an unspecified type in the netlink
> policy, so max length isn't enforced, only minimum. This means nkeys
> (from userspace) was being trusted without checking the actual size of
> nla_len(), which could lead to a memory over-read, and ultimately an
> exposure via a call to u32_dump(). Reachability is CAP_NET_ADMIN within
> a namespace.
> 
> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Zubin Mithra <zsm@chromium.org>
> ---
> Notes:
> * Syzkaller triggered an OOB read in u32_change with the following

Now queued up, thanks.

greg k-h
