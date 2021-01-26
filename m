Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A511303AE3
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 11:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404692AbhAZK4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 05:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732142AbhAZKzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 05:55:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B4DE22581;
        Tue, 26 Jan 2021 10:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611658506;
        bh=/G0jpGfGj7wtXKkXwyT9tJfgt9gpX0A3orQNjYj5ay8=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=dWRZs3Rc8P+CxIlEtXQR5m4ym5X7gF8BLKGaEqRTjGF5vwSuC4ikCGAykf5lgibmx
         IS9ESsK8a0P1puxuUIyw2O90dJXnYvWAfn5MDTDD3hOZUDYC7UevQKucHLbGSnYDPi
         2OdG8pVTU3mydmHEsKKhWz//rTJH31WF1rBD6w3JixlGFg8nZ9452rrrNm6p3tSmGg
         oRhyJXeKTevpNoTC4VkTL6JE0t8YDMtGQnZhgeWoVhFBWgGYstR2RaIlKr5DaNhPCk
         KTlQ+1wHHDbvG1i+NKV+lQMU2z35TnIewOJkSRbvaTKxJ3d5ECVPmyl24uBQtsfVfX
         pGL9z72BNSpQQ==
Date:   Tue, 26 Jan 2021 11:55:03 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jason Gerecke <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: Re: [PATCH] HID: wacom: Correct NULL dereference on AES pen
 proximity
In-Reply-To: <20210121184649.157189-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2101261152030.5622@cbobk.fhfr.pm>
References: <20210121184649.157189-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 21 Jan 2021, Jason Gerecke wrote:

> The recent commit to fix a memory leak introduced an inadvertant NULL
> pointer dereference. The `wacom_wac->pen_fifo` variable was never
> intialized, resuling in a crash whenever functions tried to use it.
> Since the FIFO is only used by AES pens (to buffer events from pen
> proximity until the hardware reports the pen serial number) this would
> have been easily overlooked without testing an AES device.
> 
> This patch converts `wacom_wac->pen_fifo` over to a pointer (since the
> call to `devres_alloc` allocates memory for us) and ensures that we assign
> it to point to the allocated and initalized `pen_fifo` before the function
> returns.
> 
> Link: https://github.com/linuxwacom/input-wacom/issues/230
> Fixes: 37309f47e2f5 ("HID: wacom: Fix memory leakage caused by kfifo_alloc")
> CC: stable@vger.kernel.org # v4.19+
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Tested-by: Ping Cheng <ping.cheng@wacom.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

