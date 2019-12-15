Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76A611F9B0
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfLORc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfLORc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 12:32:27 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC1E24679;
        Sun, 15 Dec 2019 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576431147;
        bh=iouhilPIr9mNparKJDFaxSKVppgDdgkm9jVhINcT06o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gEn/OXY++ZLxY7dB/6b0zRUBJrABIp/ALCPgGTXNlmHuqAWHaJU6lxLWphaE4z9tW
         hFVlOd871I3HyPYGGgMjq//MYKSiBaCfT4VjmrDEBrLy5JJf9xMibhCSA2WKrefw9r
         P6MquKPrTfiIsyh5aj4T+PzBaNrbMz5MkJb2bKo8=
Date:   Sun, 15 Dec 2019 12:32:25 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     qutran@marvell.com, aeasi@marvell.com, emilne@redhat.com,
        hmadhani@marvell.com, martin.petersen@oracle.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: qla2xxx: Fix double scsi_done for
 abort path" failed to apply to 5.3-stable tree
Message-ID: <20191215173225.GE18043@sasha-vm>
References: <157633589722494@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157633589722494@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 14, 2019 at 04:04:57PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From f45bca8c5052e8c59bab64ee90c44441678b9a52 Mon Sep 17 00:00:00 2001
>From: Quinn Tran <qutran@marvell.com>
>Date: Tue, 5 Nov 2019 07:06:54 -0800
>Subject: [PATCH] scsi: qla2xxx: Fix double scsi_done for abort path
>
>Current code assumes abort will remove the original command from the active
>list where scsi_done will not be called. Instead, the eh_abort thread will
>do the scsi_done. That is not the case.  Instead, we have a double
>scsi_done calls triggering use after free.
>
>Abort will tell FW to release the command from FW possesion. The original
>command will return to ULP with error in its normal fashion via scsi_done.
>eh_abort path would wait for the original command completion before
>returning.  eh_abort path will not perform the scsi_done call.
>
>Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
>Cc: stable@vger.kernel.org # 5.2
>Link: https://lore.kernel.org/r/20191105150657.8092-6-hmadhani@marvell.com
>Reviewed-by: Ewan D. Milne <emilne@redhat.com>
>Signed-off-by: Quinn Tran <qutran@marvell.com>
>Signed-off-by: Arun Easi <aeasi@marvell.com>
>Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

I took these two additional patches to resolve the conflict:

	85cffefa09e4 ("scsi: qla2xxx: Fix a race condition between aborting and completing a SCSI command")
	bdb61b9b944d ("scsi: qla2xxx: Introduce the function qla2xxx_init_sp()")

-- 
Thanks,
Sasha
