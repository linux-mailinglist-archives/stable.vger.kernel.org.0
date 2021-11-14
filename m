Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A788744F822
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 14:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhKNNq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 08:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhKNNq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 08:46:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C271361026;
        Sun, 14 Nov 2021 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636897436;
        bh=D5nOLKUWYGbXzUn3UC6feRc1u4Ba241srgr+pLT4c1s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HJivXqT+x8P4bJC6gGhBIWsvc0mMPkej4yk+FwzZpfz8YHEI9YOSmZdwIW0fPoDRX
         i24b0zgrBRi60bg1WkvelQ9MD6XuK0iuIUSaYYBQcDzRvwhPlERBXDNhzDAcLQt/qb
         SF/wDMUC4ja49PQnJnooA1Tgb8mXWVI9JG6AgAvM=
Date:   Sun, 14 Nov 2021 14:43:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-5.4.y 1/2] ALSA: mixer: oss: Fix racy access to
 slots
Message-ID: <YZESmWBVVSAxMZzs@kroah.com>
References: <20211113153846.10996-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211113153846.10996-1-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 13, 2021 at 04:38:45PM +0100, Takashi Iwai wrote:
> commit 411cef6adfb38a5bb6bd9af3941b28198e7fb680 upstream.
> 
> The OSS mixer can reassign the mapping slots dynamically via proc
> file.  Although the addition and deletion of those slots are protected
> by mixer->reg_mutex, the access to slots aren't, hence this may cause
> UAF when the slots in use are deleted concurrently.
> 
> This patch applies the mixer->reg_mutex in all appropriate code paths
> (i.e. the ioctl functions) that may access slots.
> 
> Reported-by: syzbot+9988f17cf72a1045a189@syzkaller.appspotmail.com
> Reviewed-by: Jaroslav Kysela <perex@perex.cz>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/00000000000036adc005ceca9175@google.com
> Link: https://lore.kernel.org/r/20211020164846.922-1-tiwai@suse.de
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
> 
> Please apply to older stable kernels, too

Both now queued up, thanks!

greg k-h
