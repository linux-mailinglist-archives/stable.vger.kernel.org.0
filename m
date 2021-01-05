Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125C72EA924
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbhAEKsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727764AbhAEKsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 05:48:25 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26DFC061574
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 02:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9qLXfKw/x2WJmG6fbvA7T2owyBkiL6NLVqKXoTwDSx0=; b=gabW6cEtZysgujQhSFvnn5JCQG
        fByfosi2aTJm9Tr65dhuT70Wk0ykPpUwD/HTdPuMfzvLwRoa7mQJ13Dqmlk4YZt1Bzz4wQ10t2X3z
        0K6th15JvfOm90PQoahQBMBAoTAND9iOH69Nvi00PhYD1GyrjMWVFfpv3KmVDrN+B6Y4=;
Received: from p54ae91f2.dip0.t-ipconnect.de ([84.174.145.242] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kwjs8-0004JP-DR; Tue, 05 Jan 2021 11:47:28 +0100
Subject: Re: [PATCH] Revert "mtd: spinand: Fix OOB read"
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20210105101821.47138-1-nbd@nbd.name> <X/Q//pErSOfQj/Gd@kroah.com>
 <20210105114035.2c766901@xps13>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <31b5cdd8-db92-20bf-edfd-224f61fecea4@nbd.name>
Date:   Tue, 5 Jan 2021 11:47:27 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210105114035.2c766901@xps13>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021-01-05 11:40, Miquel Raynal wrote:
> Hello,
> 
> Greg KH <gregkh@linuxfoundation.org> wrote on Tue, 5 Jan 2021 11:31:26
> +0100:
> 
>> On Tue, Jan 05, 2021 at 11:18:21AM +0100, Felix Fietkau wrote:
>> > This reverts stable commit baad618d078c857f99cc286ea249e9629159901f.
>> > 
>> > This commit is adding lines to spinand_write_to_cache_op, wheras the upstream
>> > commit 868cbe2a6dcee451bd8f87cbbb2a73cf463b57e5 that this was supposed to
>> > backport was touching spinand_read_from_cache_op.
>> > It causes a crash on writing OOB data by attempting to write to read-only
>> > kernel memory.
>> > 
>> > Cc: Miquel Raynal <miquel.raynal@bootlin.com>
>> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> > ---
>> >  drivers/mtd/nand/spi/core.c | 4 ----
>> >  1 file changed, 4 deletions(-)  
>> 
>> So the backport to 5.10.y broke, but not the backport to 4.19.y or
>> 5.4.y?  Can you provide a "correct" backport for this instead of just
>> removing this fix?
> 
> Agreed, I think the proper way to handle the situation would be to move
> these three lines to spinand_read_from_cache_op() instead of just
> getting rid of them.
But they have a similar line in spinand_read_from_cache_op already (in
addition to some extra code for dealing with MTD_OPS_AUTO_OOB).

Please take another look at your commit 3d1f08b032dc, it really looks to
me like you were just adding back a part of what you removed there.
Maybe the proper solution is to add back the rest of it as well (the
part that deals with MTD_OPS_AUTO_OOB) and leave the stable kernels alone.

- Felix
