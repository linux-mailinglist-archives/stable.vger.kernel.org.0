Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6FC6BD8FD
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 20:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCPTXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 15:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCPTXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 15:23:43 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF6322781;
        Thu, 16 Mar 2023 12:23:08 -0700 (PDT)
Received: from fpc (unknown [10.10.165.4])
        by mail.ispras.ru (Postfix) with ESMTPSA id B329D40737A8;
        Thu, 16 Mar 2023 19:23:05 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru B329D40737A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678994585;
        bh=URVVIyIH7yYN0vIafCwQq2vwHfikyOWykrYPnkSv5f4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OU69lKxhWk/yH7cK2rHuNE+1NdToEKwFM8NqQyGfcGDzWLNTnK94UQysEe81DMayz
         c/SBFYNJ6aWMzdRNFLHAsDCPKshzCnD8BNjVIkipMBtvRWHbiidQIju7WUYGOsOWVl
         j1IERExycAOk2bfET2DQZ8XhEl+YLha1zC+IzbrI=
Date:   Thu, 16 Mar 2023 22:22:59 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10/5.15] io_uring: avoid null-ptr-deref in
 io_arm_poll_handler
Message-ID: <20230316192259.ec46rcfw52ubqxrp@fpc>
References: <20230316185616.271024-1-pchelkin@ispras.ru>
 <ZBNoOE0tMiJZd6r8@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBNoOE0tMiJZd6r8@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 08:04:24PM +0100, Greg Kroah-Hartman wrote:
> 
> How can you trigger a GFP_ATOMIC memory failure?  If you do, worse
> things are about to happen to your system, right?
> 
> thanks,
> 
> greg k-h

Well, Syzkaller triggers them with fail slab, and that is more for
debugging purposes to detect improper handling of error paths.

I agree that if GFP_ATOMIC memory allocation fails then the system is in
more trouble. Do you mean this is the point not to backport it? Now I'm
actually not quite sure about this... It's not clear to me whether such
things should be backported: on one hand, it is a bug which can actually
occur (yes, in very bad situation), on the other - the whole system is not
good anyway.
