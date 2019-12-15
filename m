Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAD011F8CF
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 17:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfLOQQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 11:16:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfLOQQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 11:16:19 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2B7206D7;
        Sun, 15 Dec 2019 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576426579;
        bh=4Zxpte3zmBPSFTsIKJl4ntmENTxzAEPmrYvKmP/X0/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L8RjCbCI1FeYlx6tH4l4GAeR9VwZwtx0A9z5i2D891jtpTaPVzw3I/VvCCc5EISCb
         aspv7A55vEunU5Fh6dreSsfieDbjljBTuZoOXzhNap4trz4TgG2uCOIld0BM6rCJJ5
         YzXIyDB338ufuEKubTUCRq9QTe2EEw7fx88PmBiA=
Date:   Sun, 15 Dec 2019 11:16:11 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jsmart2021@gmail.com, dick.kennedy@broadcom.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: lpfc: Fix bad ndlp ptr in xri
 aborted handling" failed to apply to 5.3-stable tree
Message-ID: <20191215161611.GB18043@sasha-vm>
References: <157633576465127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157633576465127@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 14, 2019 at 04:02:44PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 324e1c402069e8d277d2a2b18ce40bde1265b96a Mon Sep 17 00:00:00 2001
>From: James Smart <jsmart2021@gmail.com>
>Date: Fri, 18 Oct 2019 14:18:21 -0700
>Subject: [PATCH] scsi: lpfc: Fix bad ndlp ptr in xri aborted handling
>
>In cases where I/O may be aborted, such as driver unload or link bounces,
>the system will crash based on a bad ndlp pointer.
>
>Example:
>  RIP: 0010:lpfc_sli4_abts_err_handler+0x15/0x140 [lpfc]
>  ...
>  lpfc_sli4_io_xri_aborted+0x20d/0x270 [lpfc]
>  lpfc_sli4_sp_handle_abort_xri_wcqe.isra.54+0x84/0x170 [lpfc]
>  lpfc_sli4_fp_handle_cqe+0xc2/0x480 [lpfc]
>  __lpfc_sli4_process_cq+0xc6/0x230 [lpfc]
>  __lpfc_sli4_hba_process_cq+0x29/0xc0 [lpfc]
>  process_one_work+0x14c/0x390
>
>Crash was caused by a bad ndlp address passed to I/O indicated by the XRI
>aborted CQE.  The address was not NULL so the routine deferenced the ndlp
>ptr. The bad ndlp also caused the lpfc_sli4_io_xri_aborted to call an
>erroneous io handler.  Root cause for the bad ndlp was an lpfc_ncmd that
>was aborted, put on the abort_io list, completed, taken off the abort_io
>list, sent to lpfc_release_nvme_buf where it was put back on the abort_io
>list because the lpfc_ncmd->flags setting LPFC_SBUF_XBUSY was not cleared
>on the final completion.
>
>Rework the exchange busy handling to ensure the flags are properly set for
>both scsi and nvme.
>
>Fixes: c490850a0947 ("scsi: lpfc: Adapt partitioned XRI lists to efficient sharing")
>Cc: <stable@vger.kernel.org> # v5.1+
>Link: https://lore.kernel.org/r/20191018211832.7917-6-jsmart2021@gmail.com
>Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
>Signed-off-by: James Smart <jsmart2021@gmail.com>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

For 5.3 there were context changes needed as a result of

	c00f62e6c546 ("scsi: lpfc: Merge per-protocol WQ/CQ pairs into single per-cpu pair")

I've fixed up the patch and queued it for 5.3.

-- 
Thanks,
Sasha
