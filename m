Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49CC2EA901
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbhAEKlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbhAEKlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 05:41:09 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1114C061793
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 02:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QAcS8H0I2+1IJhjocnF9OGYUB5jstRUE1T+wmkGKVzc=; b=NtY1+VDDI4xj5b1U13gjRm9v3Y
        X/THAT2BPcoKD7vV8ITiMVYDp5laPUAIYTOg5AUCs11IrFmvhvC5QxLu9ieL8aNeCxFeYLzR4vSQw
        QZsEwBhHzNbDMbGZCs+8Q3Tj5hQ4fXNUKT7Dfv2KG57FEmsrmNN7iPnOExBA0xTdLUsw=;
Received: from p54ae91f2.dip0.t-ipconnect.de ([84.174.145.242] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kwjl6-0003uK-Bv; Tue, 05 Jan 2021 11:40:12 +0100
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
References: <20210105101821.47138-1-nbd@nbd.name> <X/Q//pErSOfQj/Gd@kroah.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] Revert "mtd: spinand: Fix OOB read"
Message-ID: <e869888f-66fe-a931-2225-544938368d83@nbd.name>
Date:   Tue, 5 Jan 2021 11:40:11 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/Q//pErSOfQj/Gd@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021-01-05 11:31, Greg KH wrote:
> On Tue, Jan 05, 2021 at 11:18:21AM +0100, Felix Fietkau wrote:
>> This reverts stable commit baad618d078c857f99cc286ea249e9629159901f.
>> 
>> This commit is adding lines to spinand_write_to_cache_op, wheras the upstream
>> commit 868cbe2a6dcee451bd8f87cbbb2a73cf463b57e5 that this was supposed to
>> backport was touching spinand_read_from_cache_op.
>> It causes a crash on writing OOB data by attempting to write to read-only
>> kernel memory.
>> 
>> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  drivers/mtd/nand/spi/core.c | 4 ----
>>  1 file changed, 4 deletions(-)
> 
> So the backport to 5.10.y broke, but not the backport to 4.19.y or
> 5.4.y?  Can you provide a "correct" backport for this instead of just
> removing this fix?
I just checked, it seems that 4.19.y and 5.4.y are broken in exactly the
same way.

On a first glance, it seems that the upstream commit has a wrong Fixes
line and is fixing 3d1f08b032dc ("mtd: spinand: Use the external ECC
engine logic") instead, which is not in 5.10.
If that is correct, then we don't need any stable backport at all.

In my opinion it's best to just revert the broken commit in all the
stable trees as quickly as possible and let Miquel sort out the mess
afterwards, if needed.

- Felix
