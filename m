Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7326744B11B
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 17:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbhKIQ3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 11:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238397AbhKIQ3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 11:29:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D99C061764;
        Tue,  9 Nov 2021 08:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HJOrQ7Um771rTcBKOZOHqIhxhU6fSWgXyYE9Qt8KapU=; b=GdwjLXrUHeWyuWlHkBofD8xUUa
        5Z2irTqqzeY0jrlbu2ezUMqpuAcj0FaJ3iQx/8AWwI+rrx3XRISYDIZkRz414YplML9J2gIrN1wwm
        rxGjYNlZaO4AK8HUBgW9en8Y2oNRyX2bab1InjMBFSAvf9PSVrHor79PK/p4wn7i23/l4Hdf3bZGH
        phMIB/TiLkjVzaxZNXn52COCBErlwoqVXZvdSYKnIi1pPx6H/D7BXstQ8XfH58aJmFGxNY6Pt7+jh
        stoO/PJdX7jWgsJaQjYuQPLWWkmskTqjJ3Otd+ZHa75vtVF7RmuwVJN539Cpqi0AKBZ76efOU8dEC
        Px9IerOw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkTxO-001APS-M6; Tue, 09 Nov 2021 16:26:46 +0000
Date:   Tue, 9 Nov 2021 16:26:46 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Nathan Wilson <nate@chickenbrittle.com>, stable@vger.kernel.org
Subject: Re: [PATCH] udf: Fix crash after seekdir
Message-ID: <YYqhRmm/+XHrCgxP@casper.infradead.org>
References: <20211109114841.30310-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109114841.30310-1-jack@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 12:48:41PM +0100, Jan Kara wrote:
> udf_readdir() didn't validate the directory position it should start
> reading from. Thus when user uses lseek(2) on directory file descriptor
> it can trick udf_readdir() into reading from a position in the middle of
> directory entry which then upsets directory parsing code resulting in
> errors or even possible kernel crashes. Similarly when the directory is
> modified between two readdir calls, the directory position need not be
> valid anymore.

... We don't have an xfstest for this already?  Actually, two.  One for
lseek() and one for modifying the directory as it's being read.
