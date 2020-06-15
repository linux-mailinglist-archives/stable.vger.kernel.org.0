Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632241F8DD0
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 08:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgFOG1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 02:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgFOG1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 02:27:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3A1C061A0E;
        Sun, 14 Jun 2020 23:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IxrZoYq5zO6zBfe1eWp7BMs7FSinMBKRHvuwJLlvcSY=; b=XkO+JcZ3fBieY/lWYVSvGPSEzg
        6hTUf1V7/hH5EyO1+EybiVmuEME5o2+WBhr+5XZlhmqRbr9qGCtAcIAdNj/vSSuLJaVqXOJYRniyl
        W34FgxPyd6pDRtQi3TA96qWOKOBjv2b5NhvpV4elLG9kfpN6QeLz71ZZQMEpeQUBK29Kk9dYm5kP7
        p8N74nikP0WBJ67lyr+V8ErTQFNlAiRu1UoYhUB5cSsapg6dsqlde4fl//xvHUJFb7LpXA0zfDxnD
        U5RQjgZPQABa1uR0kgqKCelD1/I6JYUQVoXWrBpUihzKKDEqL6OT4WqzfjWvspkZkPFdgZnuPl+lx
        UXcDQoYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jkib1-00077d-UG; Mon, 15 Jun 2020 06:27:51 +0000
Date:   Sun, 14 Jun 2020 23:27:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] writeback: Fix sync livelock due to b_dirty_time
 processing
Message-ID: <20200615062751.GC26438@infradead.org>
References: <20200611075033.1248-1-jack@suse.cz>
 <20200611081203.18161-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611081203.18161-3-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 10:11:54AM +0200, Jan Kara wrote:
> When we are processing writeback for sync(2), move_expired_inodes()
> didn't set any inode expiry value (older_than_this). This can result in
> writeback never completing if there's steady stream of inodes added to
> b_dirty_time list as writeback rechecks dirty lists after each writeback
> round whether there's more work to be done. Fix the problem by using
> sync(2) start time is inode expiry value when processing b_dirty_time
> list similarly as for ordinarily dirtied inodes. This requires some
> refactoring of older_than_this handling which simplifies the code
> noticeably as a bonus.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
