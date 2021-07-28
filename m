Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5773D8B9C
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 12:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhG1KUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 06:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhG1KUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 06:20:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8141A60524;
        Wed, 28 Jul 2021 10:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627467603;
        bh=zFSbDd6JWCp56TFFucOBP/1daI+vXpebuc2/z74R6tU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hXXb8EAQVILloBPsr+wofuDf1pR1/dQynUqMzQrWpZ06knZLf+hLQA7TIo+3Ztflk
         tRw7CNp8sIyosItKxGsEsUoPSOBMkQNzzHgOqMkL/L2PCvKO0XoXXtRQgIM+Rd04D8
         Rn29nyFNaTnjPR1/n6ROqKrchcJDPZmMvhIFowZU=
Date:   Wed, 28 Jul 2021 12:20:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Carsten Schmid <carsten_schmid@mentor.com>
Subject: Re: [PATCH 5.10 167/167] xhci: add xhci_get_virt_ep() helper
Message-ID: <YQEvUay+1Rzp04SO@kroah.com>
References: <20210726153839.371771838@linuxfoundation.org>
 <20210726153845.014643770@linuxfoundation.org>
 <20210728101040.GA30574@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728101040.GA30574@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 12:10:40PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Mathias Nyman <mathias.nyman@linux.intel.com>
> > 
> > [commit b1adc42d440df3233255e313a45ab7e9b2b74096 upstream]
> 
> This is yet another variation in upstream commit making. So far I was
> using these:
> 
>                 ma = re.match(".*Upstream commit ([0-9a-f]*) .*", l)
>                 if ma:
>                     m.upstream = ma.group(1)
>                 ma = re.match("[Cc]ommit ([0-9a-f]*) upstream[.]*", l)
> 		if ma:
>                     m.upstream = ma.group(1)
>                 ma = re.match("[Cc]ommit: ([0-9a-f]*)", l)
>                 if ma:
>                     m.upstream = ma.group(1)
> 
> I guess I could update second regexp to search anywhere in the
> line.... but at that point it will also match stuff like "commit 1234
> upstream is broken".
> 
> Do you have suggestion how to extract upstream sha1 automatically?

I use:
	grep -E -o '[0-9a-f]{40}'

