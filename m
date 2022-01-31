Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FBA4A4A63
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 16:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378430AbiAaPT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 10:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359325AbiAaPT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 10:19:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9BEC061714;
        Mon, 31 Jan 2022 07:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=X5Q5MeJDTPKbLPeAN2MtOT5sSDrTeYy1qnQ5DDAxIaY=; b=tweIhqfFo7IPJLtRc+U6X4zRG/
        yGm17K8r35WfAR1Z3Pp5jZxTwu9pS7l19D8MHHoo5lF5gnMczM/vo5M83IEWaQh8VV5t3juB2KeUi
        FosS5h8/Iy9TMCHzNWSo1qVBt8JU+YzraXxCN5TExHIZ1HqlVL5IcM6O61ZztEHlFHrtqIbHmwcT9
        wIR367tJqAZz5kaPc8FgVVfgeZhphtApIxBizRqkI+DK9dejx2UTl04bqKRd6F05qMYG8niBfwh0Q
        RlDz4gojjsluqPiWShSfQRBoez5P6tZEIwL2XRyRrJN280TOC7AHKMqGn5gdCPBure6k7Mzj1qiDf
        1AxoS7vQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nEYSg-00A1w0-Mx; Mon, 31 Jan 2022 15:19:22 +0000
Date:   Mon, 31 Jan 2022 15:19:22 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        0day robot <lkp@intel.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [fs/exec]  80bd5afdd8: xfstests.generic.633.fail
Message-ID: <Yff9+tIDAvYM5EO/@casper.infradead.org>
References: <20220127000724.15106-1-ariadne@dereferenced.org>
 <20220131144352.GE16385@xsang-OptiPlex-9020>
 <20220131150819.iuqlz3rz6q7cheap@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131150819.iuqlz3rz6q7cheap@wittgenstein>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 04:08:19PM +0100, Christian Brauner wrote:
> On Mon, Jan 31, 2022 at 10:43:52PM +0800, kernel test robot wrote:
> I can fix this rather simply in our upstream fstests with:
> 
> static char *argv[] = {
> 	"",
> };
> 
> I guess.
> 
> But doesn't
> 
> static char *argv[] = {
> 	NULL,
> };
> 
> seem something that should work especially with execveat()?

The problem is that the exec'ed program sees an argc of 0, which is the
problem we're trying to work around in the kernel (instead of leaving
it to ld.so to fix for suid programs).
