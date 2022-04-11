Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5444C4FB479
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245252AbiDKHUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245262AbiDKHUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:20:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946B833E04;
        Mon, 11 Apr 2022 00:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eRvS51FJJk4hsNGYs/0q1x0DTCnMoHiRKM9+/geBumI=; b=2qM+lbsh8p7QzxV2jd9h7EoBNn
        OFkVV+tCGHh9TzF8kKvujd28J0S3lztq1WR3S1uFYIKE0VvObT2ONPi8QyQJ6THJPKXGmI3xqSED4
        D7ya0BolVEgT/3USxetl06t+7/TaN9gc5Y8s5cv5lp9Dv/lYMLtljXMVMvD27zUMimQDiGb0YDo4l
        js2nL/LRmcAHlBSUlKnrFg1ulTWojNz29QPqarjez9be7F2xKPyYIqvC8hRgL3Kho2dNJ2opJvi35
        mGHZXJpoLpHdYJc25KyfNrZGnNCul8VKdNUvC0hdkiyD3ndRrVoljr5CzORv0JBX+l7Os1GYwAb1J
        rUERwyag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ndoJl-0079KH-6h; Mon, 11 Apr 2022 07:18:33 +0000
Date:   Mon, 11 Apr 2022 00:18:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: fix the error handling for
 submit_extent_page() for btrfs_do_readpage()
Message-ID: <YlPWSTqn5z19Jtzk@infradead.org>
References: <cover.1649657016.git.wqu@suse.com>
 <2ce5b91dba107bba1ff56c9ebbadcd70e6d333e5.1649657016.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ce5b91dba107bba1ff56c9ebbadcd70e6d333e5.1649657016.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 11, 2022 at 02:12:50PM +0800, Qu Wenruo wrote:
> [BUG]
> Test case generic/475 have a very high chance (almost 100%) to hit a fs
> hang, where a data page will never be unlocked and hang all later
> operations.

Question:  how can we even get an error?  The submission already stopped
return errors with patch 1.  btrfs_get_chunk_map called from
btrfs_zoned_get_device and calc_bio_boundaries really just has sanity
checks that should be fatal if not met, same for btrfs_get_io_geometry.

So yes, we could fix the nasty error handling here.  Or just remove it
entirely, which would reduce the possibility of bugs even more.
