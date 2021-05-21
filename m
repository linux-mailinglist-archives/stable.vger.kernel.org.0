Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D0D38BCF8
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 05:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237453AbhEUDbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 23:31:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:59662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236848AbhEUDbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 23:31:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0CA5CAB64;
        Fri, 21 May 2021 03:30:12 +0000 (UTC)
Subject: Re: [PATCH v3] bcache: avoid oversized read request in cache missing
 code path
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <20210518110009.11413-1-colyli@suse.de>
 <YKYYNVD+NsXaOFNe@infradead.org>
From:   Coly Li <colyli@suse.de>
Message-ID: <fea14938-8347-d549-4a2a-4f1810e02bf7@suse.de>
Date:   Fri, 21 May 2021 11:30:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKYYNVD+NsXaOFNe@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/21 4:05 PM, Christoph Hellwig wrote:
> This fix is pretty gross.  Adding pages to bios can fail for all kinds
> of reasons, so the fix is to use bio_add_page and check its return
> value, and if it needs another bio keep looping and chaining more bios.
> 

OK, I will try this idea and avoid to access BIO_MAX_VECS directly.

> And maybe capping the readahead to some sane upper bound still makes
> sense, but it should never look at BIO_MAX_VECS for that.
> 

Thanks for the hint.

Coly Li
