Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5B22046B2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 03:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731747AbgFWB1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 21:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731572AbgFWB1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 21:27:35 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F5EB20720;
        Tue, 23 Jun 2020 01:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592875654;
        bh=m5rKXmfyC1BPFj7LEaU2zplEgB0BdXJJTHgOA2tfhcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oX/P+QrmDzg0TnkjRZs70GT8BmnAv709AKSZEYpxXyPRT+F/c/g2L1EoGnu+s69qj
         3TkOz6YqB2pcKaBgDasJavNMSjhHKQfk4aoeyyu08NNgBG17nNsC2dp3WiOhvpd78N
         bU7wFORNq3hBIFpygzTrNEEb+vwhOcpQL2oggB2A=
Date:   Mon, 22 Jun 2020 21:27:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     miquel.raynal@bootlin.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mtd: rawnand: diskonchip: Fix the probe
 error path" failed to apply to 4.19-stable tree
Message-ID: <20200623012733.GT1931@sasha-vm>
References: <159257446611107@kroah.com>
 <20200623004853.GS1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200623004853.GS1931@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 08:48:53PM -0400, Sasha Levin wrote:
>On Fri, Jun 19, 2020 at 03:47:46PM +0200, gregkh@linuxfoundation.org wrote:
>>
>>The patch below does not apply to the 4.19-stable tree.
>>If someone wants it applied there, or to any other stable or longterm
>>tree, then please email the backport, including the original git commit
>>id to <stable@vger.kernel.org>.
>>
>>thanks,
>>
>>greg k-h
>>
>>------------------ original commit in Linus's tree ------------------
>>
>>From c5be12e45940f1aa1b5dfa04db5d15ad24f7c896 Mon Sep 17 00:00:00 2001
>>From: Miquel Raynal <miquel.raynal@bootlin.com>
>>Date: Tue, 19 May 2020 14:59:45 +0200
>>Subject: [PATCH] mtd: rawnand: diskonchip: Fix the probe error path
>>
>>Not sure nand_cleanup() is the right function to call here but in any
>>case it is not nand_release(). Indeed, even a comment says that
>>calling nand_release() is a bit of a hack as there is no MTD device to
>>unregister. So switch to nand_cleanup() for now and drop this
>>comment.
>>
>>There is no Fixes tag applying here as the use of nand_release()
>>in this driver predates by far the introduction of nand_cleanup() in
>>commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
>>which makes this change possible. However, pointing this commit as the
>>culprit for backporting purposes makes sense even if it did not intruce
>>any bug.
>>
>>Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
>>Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>>Cc: stable@vger.kernel.org
>>Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-13-miquel.raynal@bootlin.com
>
>Some code refactoring:
>
>59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")
>00ad378f304a ("mtd: rawnand: Pass a nand_chip object to nand_scan()")
>
>And movement (drivers/mtd/nand/diskonchip.c ->
>drivers/mtd/nand/raw/diskonchip.c) in older branches. I've fixed it up
>and queued for 4.19-4.9.

I've changed my mind and grabbed both:

59ac276f2227 ("mtd: rawnand: Pass a nand_chip object to nand_release()")
00ad378f304a ("mtd: rawnand: Pass a nand_chip object to nand_scan()")

Which allowed my to (relatively) easily grabbed all the other failed mtd
patches into 4.19-4.9.

-- 
Thanks,
Sasha
