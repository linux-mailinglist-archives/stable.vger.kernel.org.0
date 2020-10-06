Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B67284F04
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 17:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFPaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 11:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgJFPaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 11:30:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A579206DD;
        Tue,  6 Oct 2020 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601998218;
        bh=kbVZE3fBApoJ5sfvX3UbVCLOrJcytvQbnxe37Kg6ahI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nDxkACUxVjgxLIHdeQasUj+GL+l58rWORC16ca5WSKgFuxS9WZPTobmo6FCrpPXLq
         CDVpSqXG4gWuJk45A88w18GpV/AE311KZo3UyBF7xAlxTaJZpgOIvh++vbq5Wk5aqT
         M/DEAF1chlLX7Ysml/RiAyj1kvXNDPknunmIfhUI=
Date:   Tue, 6 Oct 2020 17:31:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/1] drm/syncobj: Fix drm_syncobj_handle_to_fd refcount
 leak
Message-ID: <20201006153104.GB23711@kroah.com>
References: <20201006135228.113259-1-gprocida@google.com>
 <20201006135228.113259-2-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006135228.113259-2-gprocida@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 06, 2020 at 02:52:28PM +0100, Giuliano Procida wrote:
> commit e7cdf5c82f1773c3386b93bbcf13b9bfff29fa31 upstream.

That's not what this commit is :(

Are you sure this is correct?

> The cherry-pick 5fb252cad61f of the above commit introduced a refcount
> imbalance and so leak of struct drm_syncobj objects that can be
> triggered with DRM_IOCTL_SYNCOBJ_HANDLE_TO_FD.

Ok, so the backport of e7cdf5c82f1773c3386b93bbcf13b9bfff29fa31 is the
problem, so this needs a bit of wording change to make it obvious what
is happening here.

Can you fix that up and resend?

thanks,

greg k-h
