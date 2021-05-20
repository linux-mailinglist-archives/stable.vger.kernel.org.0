Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F94B389F6E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhETIHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhETIHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 04:07:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0571C061574;
        Thu, 20 May 2021 01:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EnMP33KD+v1NrZLekTHVvqXVLcSZIAG5TyluA2WJ8xo=; b=VBOQN5YQLqy9hFu1pzd15ldk0y
        iAt19jFhSEpbvZ1+Q5i649CVOMlTcX4wJFDz0K2mS6FalkPvOwtApOyYYTE6ztaWgacQD5nXnK8WP
        xKZpNhvwKwiNHg8tWrb3zJvmOcHGoplx2s1DbyJrkQMrDGizj50ZiK0jcODlFJuasSrlrGz9Fobyj
        iZ5z2jSSyGMJzyaephsd/TyQWpDQShzjsf51XJ6PjHFoLQBPdYsBu2K8u8mdfrvbcR0A9VurYVnQc
        HmwYVZHicIjB2xZjcen1GpH2xP3B65fgz6pQJIymEoDFwumw8YBsiCpD4qnplFzTGb0KxLz6L7Rx1
        09J8yQjw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljdg5-00FiuP-QZ; Thu, 20 May 2021 08:05:38 +0000
Date:   Thu, 20 May 2021 09:05:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Diego Ercolani <diego.ercolani@gmail.com>,
        Jan Szubiak <jan.szubiak@linuxpolska.pl>,
        Marco Rebhan <me@dblsaiko.net>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Thorsten Knabe <linux@thorsten-knabe.de>,
        Victor Westerhuis <victor@westerhu.is>,
        Vojtech Pavlik <vojtech@suse.cz>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.com>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH v3] bcache: avoid oversized read request in cache missing
 code path
Message-ID: <YKYYNVD+NsXaOFNe@infradead.org>
References: <20210518110009.11413-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518110009.11413-1-colyli@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fix is pretty gross.  Adding pages to bios can fail for all kinds
of reasons, so the fix is to use bio_add_page and check its return
value, and if it needs another bio keep looping and chaining more bios.

And maybe capping the readahead to some sane upper bound still makes
sense, but it should never look at BIO_MAX_VECS for that.
