Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803A412E9B9
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 19:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgABSJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 13:09:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42502 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgABSJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 13:09:08 -0500
Received: from [172.58.107.60] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1in4u9-0007xR-Uo; Thu, 02 Jan 2020 18:09:06 +0000
Date:   Thu, 2 Jan 2020 19:09:02 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amanieu d'Antras <amanieu@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org
Subject: Re: [PATCH 7/7] clone3: ensure copy_thread_tls is implemented
Message-ID: <20200102180901.tgtl7wxtq434h5ny@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200102172413.654385-8-amanieu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200102172413.654385-8-amanieu@gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 06:24:13PM +0100, Amanieu d'Antras wrote:
> copy_thread implementations handle CLONE_SETTLS by reading the TLS
> value from the registers containing the syscall arguments for
> clone. This doesn't work with clone3 since the TLS value is passed
> in clone_args instead.
> 
> Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> Cc: <stable@vger.kernel.org> # 5.3.x

I'm in favor of this change. But we need to make sure that any arch
which now has ARCH_WANTS_SYS_CLONE3 set but doesn't implement
copy_thread_tls() is fixed.

Once all architectures have clone3() support - and there are
just a few by now (IA64 comes to mind) this means we should also be able
to get rid of of copy_thread() completely. That seems desirable to me as
it makes the codepaths easier to follow.

Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
