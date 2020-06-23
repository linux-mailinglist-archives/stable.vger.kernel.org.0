Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FEF204625
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 02:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731602AbgFWAsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 20:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731526AbgFWAsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 20:48:54 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BC4D206C1;
        Tue, 23 Jun 2020 00:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592873334;
        bh=ph4PMaBl8tMeek/bwdtR76Ll60XIShWbHWHgdgAuhjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VFY8p01AqHq1zh6wx4XcwunxiePP8MrqTmsjo0TZZcc02twrD8MLnDKq6r36v7NVz
         laWTg2bmicxKAqyT+KVQ00U/6ugsOwAWYZ54Agr0IMIsEBgDdHcY2/Kwa/V7lUqhyY
         etA09Ps8WxopKnL6qXZSAyjFFBazLWGWRedRFwm4=
Date:   Mon, 22 Jun 2020 20:48:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     miquel.raynal@bootlin.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mtd: rawnand: diskonchip: Fix the probe
 error path" failed to apply to 4.19-stable tree
Message-ID: <20200623004853.GS1931@sasha-vm>
References: <159257446611107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159257446611107@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 03:47:46PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From c5be12e45940f1aa1b5dfa04db5d15ad24f7c896 Mon Sep 17 00:00:00 2001
>From: Miquel Raynal <miquel.raynal@bootlin.com>
>Date: Tue, 19 May 2020 14:59:45 +0200
>Subject: [PATCH] mtd: rawnand: diskonchip: Fix the probe error path
>
>Not sure nand_cleanup() is the right function to call here but in any
>case it is not nand_release(). Indeed, even a comment says that
>calling nand_release() is a bit of a hack as there is no MTD device to
>unregister. So switch to nand_cleanup() for now and drop this
>comment.
>
>There is no Fixes tag applying here as the use of nand_release()
>in this driver predates by far the introduction of nand_cleanup() in
>commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
>which makes this change possible. However, pointing this commit as the
>culprit for backporting purposes makes sense even if it did not intruce
>any bug.
>
>Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
>Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>Cc: stable@vger.kernel.org
>Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-13-miquel.raynal@bootlin.com

Some code refactoring:

59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")
00ad378f304a ("mtd: rawnand: Pass a nand_chip object to nand_scan()")

And movement (drivers/mtd/nand/diskonchip.c ->
drivers/mtd/nand/raw/diskonchip.c) in older branches. I've fixed it up
and queued for 4.19-4.9.

-- 
Thanks,
Sasha
