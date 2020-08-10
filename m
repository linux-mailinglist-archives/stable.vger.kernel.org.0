Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA4A241222
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 23:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHJVLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 17:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbgHJVLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 17:11:07 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6E5C061756;
        Mon, 10 Aug 2020 14:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pSCP9TWK9zwqSv6XuJVuV4uuC8sBqC777asNLKOSMWk=; b=vdD96yTTpkkmNQKWST0BtkFYDy
        /VWcqt5y2MRXq0O+8T/brnMJMlktZwgwTYPZ6XEWLYFHdlv+P2iZuHPK5oJHlpqeTfv/+KtslhZK7
        Z9+UkiGLdD504V/HUWehrU1Fn1V/FU9s3ZIJNV19hYTUxVLrubzpoED469Y8IzyD5JwHetW78z0P4
        xUsoeHFGTH41HHMkWOmutf+knrMHDmoJu44+z9ouP0ZBeMOSPVsopHJVWX76/vY/Z77nJXbL10fOk
        OKQnttJfQDze8P49UBea1dZHAUqkWkH5KEhlHwlN5ThzDCCFxGeWvubvStgy7Os/rNJSdv2Q4Sex9
        2ijD4RbA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5F4P-0003Na-Px; Mon, 10 Aug 2020 21:11:02 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id F20BA980D39; Mon, 10 Aug 2020 23:10:57 +0200 (CEST)
Date:   Mon, 10 Aug 2020 23:10:57 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200810211057.GG3982@worktop.programming.kicks-ass.net>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
 <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 03:06:49PM -0600, Jens Axboe wrote:

> should work as far as I can tell, but I don't even know if there's a
> reliable way to do task_in_kernel().

Only on NOHZ_FULL, and tracking that is one of the things that makes it
so horribly expensive.

