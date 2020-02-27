Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9014170EE2
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 04:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgB0DRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 22:17:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgB0DRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 22:17:33 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90A3B21D7E;
        Thu, 27 Feb 2020 03:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773452;
        bh=WxkS+lgP/EowcpzJd6kB1An+p3Qf8hHsKi2uKbtfRz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e4+q4cD29XWKD9AH6l3FlhjdfbCo4dNxneL/P24BITX1hHlUT3RBYIgk32FfqmQi5
         Lijs0P/EhmhR5/Fyv5hjhiJH+xNzjPkZsGN5tW/UfO6Tr4NZ8LTeyiSpBpm3cQvJgX
         yG3wLA+KI7+TM+RB687RVKlBOu1rPepXNOnrXR7s=
Date:   Wed, 26 Feb 2020 22:17:31 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lyude@redhat.com, bskeggs@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/nouveau/kms/gv100-: Re-set LUT after
 clearing for" failed to apply to 4.19-stable tree
Message-ID: <20200227031731.GF22178@sasha-vm>
References: <1582714299255116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1582714299255116@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 11:51:39AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From f287d3d19769b1d22cba4e51fa0487f2697713c9 Mon Sep 17 00:00:00 2001
>From: Lyude Paul <lyude@redhat.com>
>Date: Wed, 12 Feb 2020 18:11:49 -0500
>Subject: [PATCH] drm/nouveau/kms/gv100-: Re-set LUT after clearing for
> modesets
>
>While certain modeset operations on gv100+ need us to temporarily
>disable the LUT, we make the mistake of sometimes neglecting to
>reprogram the LUT after such modesets. In particular, moving a head from
>one encoder to another seems to trigger this quite often. GV100+ is very
>picky about having a LUT in most scenarios, so this causes the display
>engine to hang with the following error code:
>
>disp: chid 1 stat 00005080 reason 5 [INVALID_STATE] mthd 0200 data
>00000001 code 0000002d)
>
>So, fix this by always re-programming the LUT if we're clearing it in a
>state where the wndw is still visible, and has a XLUT handle programmed.
>
>Signed-off-by: Lyude Paul <lyude@redhat.com>
>Fixes: facaed62b4cb ("drm/nouveau/kms/gv100: initial support")
>Cc: <stable@vger.kernel.org> # v4.18+
>Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

We don't have 88b703527ba7 ("drm/nouveau/kms/gf119-: add ctm property
support") in 4.19. I've fixed it and queued up.

-- 
Thanks,
Sasha
