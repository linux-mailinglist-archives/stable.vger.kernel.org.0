Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024B548FD75
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 15:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiAPOeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 09:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiAPOeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 09:34:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE29DC061574;
        Sun, 16 Jan 2022 06:34:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92D36B80D4C;
        Sun, 16 Jan 2022 14:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F919C36AE9;
        Sun, 16 Jan 2022 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642343659;
        bh=Oo3IEYSZe4Lq3ZPlAY8Bw/E9I4wuk7EtHkE4QX98vEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PoofQluGqNYvUJpHRB8vgQcj+23MTWbAFmyUHBydxcjp9wrKn4NfS6rKAM8rOZujs
         X+usDF26jKOlIOfodseT9lkjcAH1ot1W3KNFDSSRrXR1p2BJB2AeMym8wQ1U9dV1oS
         XyVI63GEJMcpKl63Va7mIi02/+WybM0kQKRgEbonMTGshp9XJ7fOoNuY1iSUoVjqVL
         9+Msfs4/wTnGkq5FM5LexGVSzf5CBBQyPYZLRs6NYcF1SeZbBL8OM1MKoXoPzQBl3w
         1rPI5Yop4A77fDBkLR+OM7oGgdd4x3n5+vfZYyy6Bb9X7JSnurEKyrlrtcQKYVAbtt
         krU93zG+VWLkg==
Date:   Sun, 16 Jan 2022 16:34:06 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tadeusz Struk <tstruk@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] tpm: Fix error handling in async work
Message-ID: <YeQs3rHQ+0eVGDTH@iki.fi>
References: <20220116012627.2031-1-tstruk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220116012627.2031-1-tstruk@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 15, 2022 at 05:26:26PM -0800, Tadeusz Struk wrote:
> When an invalid (non existing) handle is used in a TPM command,
> that uses the resource manager interface (/dev/tpmrm0) the resource
> manager tries to load it from its internal cache, but fails and
> the tpm_dev_transmit returns an -EINVAL error to the caller.
> The existing async handler doesn't handle these error cases
> currently and the condition in the poll handler never returns
> mask with EPOLLIN set.
> The result is that the poll call blocks and the application gets stuck
> until the user_read_timer wakes it up after 120 sec.
> Change the tpm_dev_async_work function to handle error conditions
> returned from tpm_dev_transmit they are also reflected in the poll mask
> and a correct error code could passed back to the caller.
> 
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: <linux-integrity@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> Fixes: 9e1b74a63f77 ("tpm: add support for nonblocking operation")
> Tested-by: Jarkko Sakkinen<jarkko@kernel.org>
> Signed-off-by: Tadeusz Struk <tstruk@gmail.com>

Thank you.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
