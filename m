Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3B111C46E
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 04:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfLLDwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 22:52:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:33742 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727421AbfLLDwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 22:52:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D78AAABE9;
        Thu, 12 Dec 2019 03:52:22 +0000 (UTC)
Subject: Re: [PATCH AUTOSEL 4.14 32/58] bcache: at least try to shrink 1 node
 in bch_mca_scan()
To:     John Stoffel <john@stoffel.org>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <20191211152831.23507-1-sashal@kernel.org>
 <20191211152831.23507-32-sashal@kernel.org>
 <24049.47251.286105.88377@quad.stoffel.home>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <3363848c-6422-31b7-4ec2-0899f605a7f5@suse.de>
Date:   Thu, 12 Dec 2019 11:52:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <24049.47251.286105.88377@quad.stoffel.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/12/12 11:48 上午, John Stoffel wrote:
>>>>>> "Sasha" == Sasha Levin <sashal@kernel.org> writes:
> 
> Sasha> From: Coly Li <colyli@suse.de>
> Sasha> [ Upstream commit 9fcc34b1a6dd4b8e5337e2b6ef45e428897eca6b ]
> 
> Sasha> In bch_mca_scan(), the number of shrinking btree node is calculated
> Sasha> by code like this,
> Sasha> 	unsigned long nr = sc->nr_to_scan;
> 
> Sasha>         nr /= c->btree_pages;
> Sasha>         nr = min_t(unsigned long, nr, mca_can_free(c));
> Sasha> variable sc->nr_to_scan is number of objects (here is bcache B+tree
> Sasha> nodes' number) to shrink, and pointer variable sc is sent from memory
> Sasha> management code as parametr of a callback.
> 
> Sasha> If sc->nr_to_scan is smaller than c->btree_pages, after the above
> Sasha> calculation, variable 'nr' will be 0 and nothing will be shrunk. It is
> Sasha> frequeently observed that only 1 or 2 is set to sc->nr_to_scan and make
> Sasha> nr to be zero. Then bch_mca_scan() will do nothing more then acquiring
> Sasha> and releasing mutex c->bucket_lock.
> 
> Sasha> This patch checkes whether nr is 0 after the above calculation, if 0
> Sasha> is the result then set 1 to variable 'n'. Then at least bch_mca_scan()
> Sasha> will try to shrink a single B+tree node.
> 
> Sasha>  	nr /= c->btree_pages;
> Sasha> +	if (nr == 0)
> Sasha> +		nr = 1;
> 
> 
> Wouldn't it be even more clear with:
> 
>    nr /= c->bree_pages || 1;
> 
> instead?

No, it is not more clear. At least to me, I may confuse does it mean,
- nr = (nr / c->btree_pages) || 1;
- or nr = nr / (c->btree_pages || 1)

If I don't check C manual, I am not able to tell the correct calculate
at first time.

Thanks.

-- 

Coly Li
