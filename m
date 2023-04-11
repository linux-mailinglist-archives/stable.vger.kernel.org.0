Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4106DD077
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjDKDoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjDKDoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:44:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B44E40D4;
        Mon, 10 Apr 2023 20:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=23J/8FBsXEnL7p9k8s46zYOwMEms6Ik/i/msTFqEsPs=; b=OzpBgaZCyER1AUJcKzgA2bSBav
        P6xljmei5C48FtZNQb2a5cp9EO7ZrGqw/3KfVMrKFGd7m8Wv1ZnXQelKkGEdu9uqjdpXC8D4kcOvu
        AJRXSSVQcCuCReDfBKapzg1PANTFvST7ydHdAz2+QfBl2G9mt2/GHtJSeLE75/seGBea+1zl4OO7q
        1XnS7WOIMhWbl7c2Kp+K9REG1FOouV+6WqYCjri7FRhw7MP5Ij64rbS/JghVLovA8HgnkgCKENkXL
        vRjaoSxG+LbSqJkiqVFZvdHP9JIJeQrRyfDJZ75bS9+Azc2NcaaW0Soexe5re6GRZdudOPT+oX3wy
        VaJx2qCQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pm4tX-005HBj-Uy; Tue, 11 Apr 2023 03:42:12 +0000
Date:   Tue, 11 Apr 2023 04:42:11 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Peng Zhang <zhangpeng.00@bytedance.com>, Liam.Howlett@oracle.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org,
        David Binderman <dcb314@hotmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] maple_tree: Use correct variable type in sizeof
Message-ID: <ZDTXE8jKMz802jqR@casper.infradead.org>
References: <20230411023513.15227-1-zhangpeng.00@bytedance.com>
 <20230410202935.d1abf62f386eefb1efa36ce4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410202935.d1abf62f386eefb1efa36ce4@linux-foundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 10, 2023 at 08:29:35PM -0700, Andrew Morton wrote:
> On Tue, 11 Apr 2023 10:35:13 +0800 Peng Zhang <zhangpeng.00@bytedance.com> wrote:
> 
> > The type of variable pointed to by pivs is unsigned long, but the type
> > used in sizeof is a pointer type. Change it to unsigned long.
> 
> Thanks, but there's nothing in this changelog which explains why a
> -stable backport is being proposed.  When fixing a bug, please always
> describe the user-visible effects of that bug.

There is no user-visible effect of this bug as the assembly code
generated will be identical.

> > --- a/lib/maple_tree.c
> > +++ b/lib/maple_tree.c
> > @@ -3255,7 +3255,7 @@ static inline void mas_destroy_rebalance(struct ma_state *mas, unsigned char end
> >  
> >  		if (tmp < max_p)
> >  			memset(pivs + tmp, 0,
> > -			       sizeof(unsigned long *) * (max_p - tmp));
> > +			       sizeof(unsigned long) * (max_p - tmp));
> >  
> >  		if (tmp < mt_slots[mt])
> >  			memset(slots + tmp, 0, sizeof(void *) * (max_s - tmp));
> 
> Is there any situation in which
> sizeof(unsigned long *) != sizeof(unsigned long)?

Windows 64-bit (pointer 64-bit, unsigned long is 32 bit) is the only
one I know.  Linux is all ILP32 or LP64.  There may be some embedded
environments which are different, but I have no idea what they might be.
