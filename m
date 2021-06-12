Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AC73A4F1D
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 15:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhFLNiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Jun 2021 09:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLNiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Jun 2021 09:38:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29243C061574;
        Sat, 12 Jun 2021 06:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lTQB5qCBpMqmC9qHgfvooE4ztNGei/EzBmjKeqrc5fk=; b=YNdM/7LJ7/WRl5a5BbNVJK2Oz0
        zLvYaOYFkR3GLqcB6Y4pIGODCh8O2t4eFllm0lIw/HgZdrHmVIocszBt0K7hSolIw3yeBi1XBB6KN
        Tgolf7OQ09GM7rIpPPfmJBokRr8KrCZl82y7/IsmpzJsiJ1PTphG69o2VoWdGgFZ1zuruRyx7toGD
        viM8BwIjiWsaiRVXg6FQ7J8HMX+4mCxW47E0nt2PTtAfvncAqNvtUDRy5UCLo47RF4cumROyXV/D3
        oMyV1JkPAQ49Nj378JNSoZvhSBz1J3U0XVexS1WNL/id4S6hk0n7lXP100uMDKJfh50utTZKNnzsL
        J6L40PWw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ls3o4-003k1e-L3; Sat, 12 Jun 2021 13:36:15 +0000
Date:   Sat, 12 Jun 2021 14:36:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-cachefs@redhat.com,
        pfmeec@rit.edu, dhowells@redhat.com, idryomov@gmail.com,
        stable@vger.kernel.org, Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH v2] ceph: fix write_begin optimization when write is
 beyond EOF
Message-ID: <YMS4TOw8txQQ7VGr@casper.infradead.org>
References: <20210611195904.160416-1-jlayton@kernel.org>
 <20210612001141.167797-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210612001141.167797-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 11, 2021 at 08:11:41PM -0400, Jeff Layton wrote:
>  		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
> -		    (pos >= i_size_read(inode)) ||
> +		    (index > (i_size_read(inode) - 1) / PAGE_SIZE) ||
>  		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {

You missed the (i_size == 0) case.  And I really would factor out
reading i_size into a local variable.

>  			zero_user_segments(page, 0, pos_in_page,
>  					   pos_in_page + len, PAGE_SIZE);
> -- 
> 2.31.1
> 
