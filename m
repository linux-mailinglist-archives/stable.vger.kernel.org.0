Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEAB4982A6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbiAXOok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:44:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiAXOoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:44:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 613A1B810A9
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727BFC340E1;
        Mon, 24 Jan 2022 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643035476;
        bh=TXjKEUjtrRkti9/cFKMbac+whJHVe/ryXzac1rfv5CY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rMO3EysY0LhxExM9301/egx7QkHeRda98JTVjlHGF11bTqlSUTTLWDFvB/P07+JYU
         NhSYQNdX88WblQvsn0FaxkmaMqb509T+mP8l3oJiCBQXhCfKn1dvQNRwC+x8DqOSh+
         TzUuyQLoSN0emAv/MrAh5GAasNre0NHeUpptlsXg=
Date:   Mon, 24 Jan 2022 15:44:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 4.9 1/2] Revert "gup: document and work around "COW can
 break either way" issue"
Message-ID: <Ye67UVFxkvNm1xRF@kroah.com>
References: <Ye6r1M/jrcVrUDXQ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye6r1M/jrcVrUDXQ@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 02:38:28PM +0100, Ben Hutchings wrote:
> This reverts commit 9bbd42e79720122334226afad9ddcac1c3e6d373, which
> was commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.  The
> backport was incorrect and incomplete:
> 
> * It forced the write flag on in the generic __get_user_pages_fast(),
>   whereas only get_user_pages_fast() was supposed to do that.
> * It only fixed the generic RCU-based implementation used by arm,
>   arm64, and powerpc.  Before Linux 4.13, several other architectures
>   had their own implementations: mips, s390, sparc, sh, and x86.
> 
> This will be followed by a (hopefully) correct backport.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/gup.c         | 48 ++++++++----------------------------------------
>  mm/huge_memory.c |  7 ++++---
>  2 files changed, 12 insertions(+), 43 deletions(-)

Both now queued up, thanks!

greg k-h
