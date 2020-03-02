Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7009817652A
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 21:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgCBUlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 15:41:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCBUlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 15:41:00 -0500
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E418D21556;
        Mon,  2 Mar 2020 20:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583181660;
        bh=zSZieL+ySgARgxDZJBIGKZWYvrkE3mow+cIkXNqm8vY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=C4voe7XGggq/F6m83iCejst5Rs6NqGAz2JSGplquylZwgyZLgiV4Y8dQhjHeiph2D
         HrM1Jwp+fMdL1McWdTesnxZHujjS07JllPD0Z/LihIAbvKGzbcDDrzBTM5LokmCA6E
         fGR94NVikZp6rraG8LoQPvGo7RfrHWPL8gFMnyDY=
Date:   Mon, 2 Mar 2020 14:40:57 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        tristmd@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
Message-ID: <20200302204057.GA128531@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206142812.25989-1-jack@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 03:28:12PM +0100, Jan Kara wrote:

> @@ -1844,18 +1896,18 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
>  	}
>  
>  	ret = 0;
> -	if (q->blk_trace == NULL)
> +	if (bt == NULL)
>  		ret = blk_trace_setup_queue(q, bdev);
>  
>  	if (ret == 0) {
>  		if (attr == &dev_attr_act_mask)
> -			q->blk_trace->act_mask = value;
> +			bt->act_mask = value;

You've likely seen this already, but Coverity complains that "bt" may
be a NULL pointer here, since we checked it for NULL above.

  CID 1460458:  Null pointer dereferences  (FORWARD_NULL)

>  		else if (attr == &dev_attr_pid)
> -			q->blk_trace->pid = value;
> +			bt->pid = value;
>  		else if (attr == &dev_attr_start_lba)
> -			q->blk_trace->start_lba = value;
> +			bt->start_lba = value;
>  		else if (attr == &dev_attr_end_lba)
> -			q->blk_trace->end_lba = value;
> +			bt->end_lba = value;
>  	}
>  
>  out_unlock_bdev:
> 
