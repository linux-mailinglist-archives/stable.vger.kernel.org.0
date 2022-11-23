Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DE6635010
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 07:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbiKWGIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 01:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235980AbiKWGHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 01:07:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C4AF8854
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 22:05:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC51461922
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 06:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF9EC433C1;
        Wed, 23 Nov 2022 06:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669183546;
        bh=IP5MVI56kooWfR009KVyeyTsh+/a5w0dWSLi0FmrSDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XPUjMfJx+Ca3541RB0mQZ/j2gvlpn6oak67bnjPpAckGl7Iug4h3WoVC90t1QZc1K
         4P2gyPTJLvbQXhPVay2FXOxXZbT43gUg0ILJHqNGGS0I3LVQT1ymb/+8nICVG3Z2Jm
         2aP7dG5eIDmIBRMPmNFt7H656M3zz6meYJwTsLWA=
Date:   Wed, 23 Nov 2022 07:05:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Cc:     linux_uek_grp@oracle.com, stable@vger.kernel.org
Subject: Re: [PATCH UEK5-U5] scsi: qla2xxx: Fix use after free in eh_abort
 path
Message-ID: <Y324N9L71QuEs/Ig@kroah.com>
References: <1669165012-11899-1-git-send-email-rajan.shanmugavelu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669165012-11899-1-git-send-email-rajan.shanmugavelu@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 22, 2022 at 04:56:52PM -0800, Rajan Shanmugavelu wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> In eh_abort path driver prematurely exits the call to upper layer. Check
> whether command is aborted / completed by firmware before exiting the call.
> 
> 9 [ffff8b1ebf803c00] page_fault at ffffffffb0389778
>   [exception RIP: qla2x00_status_entry+0x48d]
>   RIP: ffffffffc04fa62d  RSP: ffff8b1ebf803cb0  RFLAGS: 00010082
>   RAX: 00000000ffffffff  RBX: 00000000000e0000  RCX: 0000000000000000
>   RDX: 0000000000000000  RSI: 00000000000013d8  RDI: fffff3253db78440
>   RBP: ffff8b1ebf803dd0   R8: ffff8b1ebcd9b0c0   R9: 0000000000000000
>   R10: ffff8b1e38a30808  R11: 0000000000001000  R12: 00000000000003e9
>   R13: 0000000000000000  R14: ffff8b1ebcd9d740  R15: 0000000000000028
>   ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> 10 [ffff8b1ebf803cb0] enqueue_entity at ffffffffafce708f
> 11 [ffff8b1ebf803d00] enqueue_task_fair at ffffffffafce7b88
> 12 [ffff8b1ebf803dd8] qla24xx_process_response_queue at ffffffffc04fc9a6
> [qla2xxx]
> 13 [ffff8b1ebf803e78] qla24xx_msix_rsp_q at ffffffffc04ff01b [qla2xxx]
> 14 [ffff8b1ebf803eb0] __handle_irq_event_percpu at ffffffffafd50714
> 
> Link: https://lore.kernel.org/r/20210908164622.19240-10-njavali@marvell.com
> Fixes: f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort path")
> Cc: stable@vger.kernel.org
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Co-developed-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Co-developed-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Orabug: 34813552
> 
> (cherry picked from commit 3d33b303d4f3b74a71bede5639ebba3cfd2a2b4d)

This is already in the stable kernel releases, so why do you need it
merged again?

thanks,

greg k-h
