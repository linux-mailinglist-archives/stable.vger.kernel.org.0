Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187C0548386
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiFMJRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiFMJRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:17:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C092B18B30;
        Mon, 13 Jun 2022 02:17:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AE6B6132A;
        Mon, 13 Jun 2022 09:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51463C34114;
        Mon, 13 Jun 2022 09:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655111832;
        bh=xvaTrA/hT+882XGo8RJkhe9Pd4T6ylFv/gQwzn+huXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y1dINAJ19F3AyodF41o+C5f0tbV02uGKAlXJ1Izuv/43yyZsWY6YGQl04Dgr3rxtn
         lxQOtFyVs5FT0LylQ2VQMopBiZ/+fz5JoTmzySygS/h1d+6a6CPgU+GMmmIYM8LozO
         yS+h1rUzEAO95zaB8H33FNpD/24RZImJrel5tswQ=
Date:   Mon, 13 Jun 2022 11:17:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     stable@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.17-stable] block, loop: support partitions without
 scanning
Message-ID: <YqcAlj/r+vTOPLu6@kroah.com>
References: <20220609042432.1656938-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609042432.1656938-1-hch@lst.de>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 06:24:32AM +0200, Christoph Hellwig wrote:
> Historically we did distinguish between a flag that surpressed partition
> scanning, and a combinations of the minors variable and another flag if
> any partitions were supported.  This was generally confusing and doesn't
> make much sense, but some corner case uses of the loop driver actually
> do want to support manually added partitions on a device that does not
> actively scan for partitions.  To make things worsee the loop driver
> also wants to dynamically toggle the scanning for partitions on a live
> gendisk, which makes the disk->flags updates non-atomic.
> 
> Introduce a new GD_SUPPRESS_PART_SCAN bit in disk->state that disables
> just scanning for partitions, and toggle that instead of GENHD_FL_NO_PART
> in the loop driver.
> 
> Fixes: 1ebe2e5f9d68 ("block: remove GENHD_FL_EXT_DEVT")
> Reported-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Link: https://lore.kernel.org/r/20220527055806.1972352-1-hch@lst.de
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> (cherry picked from commit b9684a71fca793213378dd410cd11675d973eaa1)

Both queued up, thanks.

greg k-h
