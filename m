Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5734711C47F
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 05:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfLLEAm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 11 Dec 2019 23:00:42 -0500
Received: from li1843-175.members.linode.com ([172.104.24.175]:58376 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfLLEAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 23:00:41 -0500
Received: from quad.stoffel.org (66-189-75-104.dhcp.oxfr.ma.charter.com [66.189.75.104])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id DB7A41EF96;
        Wed, 11 Dec 2019 23:00:40 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 85BF3A5E01; Wed, 11 Dec 2019 23:00:40 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <24049.47976.479357.312176@quad.stoffel.home>
Date:   Wed, 11 Dec 2019 23:00:40 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Coly Li <colyli@suse.de>
Cc:     John Stoffel <john@stoffel.org>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 32/58] bcache: at least try to shrink 1 node
 in bch_mca_scan()
In-Reply-To: <3363848c-6422-31b7-4ec2-0899f605a7f5@suse.de>
References: <20191211152831.23507-1-sashal@kernel.org>
        <20191211152831.23507-32-sashal@kernel.org>
        <24049.47251.286105.88377@quad.stoffel.home>
        <3363848c-6422-31b7-4ec2-0899f605a7f5@suse.de>
X-Mailer: VM 8.2.0b under 25.1.1 (x86_64-pc-linux-gnu)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>>>> "Coly" == Coly Li <colyli@suse.de> writes:

Coly> On 2019/12/12 11:48 上午, John Stoffel wrote:
>>>>>>> "Sasha" == Sasha Levin <sashal@kernel.org> writes:
>> 
Sasha> From: Coly Li <colyli@suse.de>
Sasha> [ Upstream commit 9fcc34b1a6dd4b8e5337e2b6ef45e428897eca6b ]
>> 
Sasha> In bch_mca_scan(), the number of shrinking btree node is calculated
Sasha> by code like this,
Sasha> unsigned long nr = sc->nr_to_scan;
>> 
Sasha> nr /= c->btree_pages;
Sasha> nr = min_t(unsigned long, nr, mca_can_free(c));
Sasha> variable sc->nr_to_scan is number of objects (here is bcache B+tree
Sasha> nodes' number) to shrink, and pointer variable sc is sent from memory
Sasha> management code as parametr of a callback.
>> 
Sasha> If sc->nr_to_scan is smaller than c->btree_pages, after the above
Sasha> calculation, variable 'nr' will be 0 and nothing will be shrunk. It is
Sasha> frequeently observed that only 1 or 2 is set to sc->nr_to_scan and make
Sasha> nr to be zero. Then bch_mca_scan() will do nothing more then acquiring
Sasha> and releasing mutex c->bucket_lock.
>> 
Sasha> This patch checkes whether nr is 0 after the above calculation, if 0
Sasha> is the result then set 1 to variable 'n'. Then at least bch_mca_scan()
Sasha> will try to shrink a single B+tree node.
>> 
Sasha> nr /= c->btree_pages;
Sasha> +	if (nr == 0)
Sasha> +		nr = 1;
>> 
>> 
>> Wouldn't it be even more clear with:
>> 
>> nr /= c->bree_pages || 1;
>> 
>> instead?

Coly> No, it is not more clear. At least to me, I may confuse does it mean,
Coly> - nr = (nr / c->btree_pages) || 1;
Coly> - or nr = nr / (c->btree_pages || 1)

Coly> If I don't check C manual, I am not able to tell the correct
Coly> calculate at first time.

You're right, it's not quite as clear, it needs proper parenthesis.
But maybe instead of a (possibly) expensive division all the time, why
not just shift and assume you have it shrink a node, or try to.

I honestly haven't looked closely enough at the code to figure out the
best shift to use here.  But isn't this calculation wrong anyway?  If
you have lots of c->bree_pages, wouldn't you want to do more freeing?

I'd need to read the code better, but I'm heading to bed now.  Sorry.

John
