Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4007A6D45C4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbjDCN2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjDCN2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:28:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA82F26256;
        Mon,  3 Apr 2023 06:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4711BCE01C1;
        Mon,  3 Apr 2023 13:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DAAC433EF;
        Mon,  3 Apr 2023 13:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680528433;
        bh=MCieEk1bbEkw0JplikyuuxTXvbfM7YmCGeNPGoaUs7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PwnNOIb2yfb8SKi/m3zpqy0meV6WFqyUMDuYU8YihOfcUDiu4SfSq/sG7T6NBE+R4
         H6EZrYVEKnmMX3EPrrcXxD5sX16nEJE29AJC4+At0vyBpeJTfqC489BhvxjpxqdLIR
         wXVQ7QowbcpQy90ZP/X5+uzyRjKWKTcQe/Hvj+yc=
Date:   Mon, 3 Apr 2023 15:27:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 4.19/5.4/5.10 1/1] gfs2: Always check inode size of
 inline inodes
Message-ID: <2023040302-surface-thwarting-037f@gregkh>
References: <20230324201933.329885-2-pchelkin@ispras.ru>
 <20230324202615.330615-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324202615.330615-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 24, 2023 at 11:26:15PM +0300, Fedor Pchelkin wrote:
> From: Andreas Gruenbacher <agruenba@redhat.com>
> 
> commit 70376c7ff31221f1d21db5611d8209e677781d3a upstream.
> 
> Check if the inode size of stuffed (inline) inodes is within the allowed
> range when reading inodes from disk (gfs2_dinode_in()).  This prevents
> us from on-disk corruption.
> 
> The two checks in stuffed_readpage() and gfs2_unstuffer_page() that just
> truncate inline data to the maximum allowed size don't actually make
> sense, and they can be removed now as well.
> 
> Reported-by: syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> [pchelkin@ispras.ru: adjust the inode variable inside gfs2_dinode_in with
> the format used before upstream commit 7db354444ad8 ("gfs2: Cosmetic
> gfs2_dinode_{in,out} cleanup")]
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
> v2: add missed From: tag

Now queued up, thanks.

greg k-h
