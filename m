Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF8E1AD77B
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 09:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgDQHfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 03:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbgDQHfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 03:35:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCDDC061A0C;
        Fri, 17 Apr 2020 00:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DdP3H169eV2IavVQf/9gs/bbd8L/xKwiCNv9vSMdxK4=; b=bGSZQAFJDJ/MCm5VUi8/qe5aEZ
        2BliRBR3H2ALwBicpgBWjJiUZ931UFHzyU/0xJum2/jmFrLsPDipN3kUY5QByQo6I8UMQsNiOcQeq
        0hxr2eG6l4elNqjKA15ulu+DT8T0R+0nUHqRFsWZO9Hx+bOaW51u3ZDWbk5xxBJNVAra6CyfLMOef
        BSZtIwZqYyA2rWbX436N7g6IpYviu22S2h8n/6ylptcKbbPEbeSbW7ZWXS/vX+TOTLj7cfAoTup+V
        6fOHLPx5hY49kdUfPBnKdX/iaZzjR3JnrvG5lNpKAFdlvoQjdFVzcpwADZJNDKOyIJwTs9/bptNGu
        tQuSZm6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPLWp-0005ew-G8; Fri, 17 Apr 2020 07:35:11 +0000
Date:   Fri, 17 Apr 2020 00:35:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Kellermann <mk@cm4all.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com, bfields@redhat.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk, agruenba@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/4] fs/posix_acl: apply umask if superblock disables
 ACL support
Message-ID: <20200417073511.GA598@infradead.org>
References: <20200407142243.2032-1-mk@cm4all.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407142243.2032-1-mk@cm4all.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 04:22:40PM +0200, Max Kellermann wrote:
>  
> -	if (S_ISLNK(*mode) || !IS_POSIXACL(dir))
> +	if (S_ISLNK(*mode))
>  		return 0;
>  
> +	if (!IS_POSIXACL(dir)) {
> +		*mode &= ~current_umask();
> +		return 0;
> +	}
> +

I think the first hunk is obviously correct, but I don't think we need
the second one, as the handling of the get_acl() eturn value should do
the right thing.  If you want to optimize it a bit, it might be worth to
move the !IS_POSIXACL check in get_acl to the top of the function,
before checking the cached ACL.
