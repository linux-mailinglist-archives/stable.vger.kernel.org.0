Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D8060E3C7
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 16:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbiJZOxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 10:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbiJZOxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 10:53:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AF7BBF25
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 07:53:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A796B822BF
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 14:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938EDC433C1;
        Wed, 26 Oct 2022 14:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796010;
        bh=pd6aMDUAJFSiHAW4VvmmsMn5MZkoV3r25rge8waJA/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VuI8G0yATQb04ena06Zwfkm7dT2wxMDdIOtlaqQAZvixwjfvoyxGfuQPQvgN4+a/2
         Vu8e6j2fogrST4CAUFEpHD3C/SaLVaI2pf/ENOLXQ2d4vSvKXE0Prw+Zr42nUY/Lc5
         Q6qIsOqG/6ffw5XTRiIGoUWhoer86S6bQX1v0pEA=
Date:   Wed, 26 Oct 2022 16:53:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     stable@vger.kernel.org, justintee8345@gmail.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH 00/33] lpfc: LTS 5.15 update to correct path split changes
Message-ID: <Y1lJ6OVS3wA8Y6Pj@kroah.com>
References: <20221025225739.85182-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025225739.85182-1-jsmart2021@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 03:57:06PM -0700, James Smart wrote:
> An issue was identified with lpfc in the LTS 5.15 kernel. There is an
> FLOGI failure which prevents FC link bringup.
> 
> In the past several kernel releases, we have been reworking areas of
> the driver to fix issues in the broader design rather than continuing
> to create a patchwork on an issue-by-issue basis. This means there are
> a lot of inter-related patches.
> 
> In this case, it appears that a portion of the "path split" rework was
> pulled into 5.15, and the portion that wasn't picked up introduced
> the error.
> 
> This patch set reverts the patches for the partial pull in, then adds
> the full rework set and all known fixes. lpfc ends up in a state
> somewhat close to 5.18.y
> 
> -- james
> 
> 
> This patch set was created via the following:
> 
>  # Revert prior partial "path split" patches
> git revert 17bf429b913b 6e99860de6f4 9a570069cdbb 2b5ef6430c21
>       b4543dbea84c c56cc7fefc31 1c5e670d6a5a
> 
>  # Pick up full patch set for "path split"
> git cherry-pick a680a9298e7b 1b64aa9eae28 561341425bcc 6831ce129f19
>       cad93a089031 3bea83b68d54 3f607dcb43f1 e0367dfe90d6 9d41f08aa2eb
>       351849800157 2d1928c57df6 61910d6a5243 3512ac094293 31a59f75702f
>       0e082d926f59
> 
>  # Pick up atomic_inc VMID fix
> git cherry-pick 0948a9c53860
> 
>  # Pick up known fixes on "path split"
> git cherry-pick 7294a9bcaa7e c26bd6602e1d c2024e3b33ee cc28fac16ab7
>       775266207105 84c6f99e3907 596fc8adb171 44ba9786b673 24e1f056677e
>       e27f05147bff 
> 
> 
> James Smart (33):
>   Revert "scsi: lpfc: Resolve some cleanup issues following SLI path
>     refactoring"
>   Revert "scsi: lpfc: Fix element offset in
>     __lpfc_sli_release_iocbq_s4()"
>   Revert "scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()"
>   Revert "scsi: lpfc: Remove extra atomic_inc on cmd_pending in
>     queuecommand after VMID"
>   Revert "scsi: lpfc: SLI path split: Refactor SCSI paths"
>   Revert "scsi: lpfc: SLI path split: Refactor fast and slow paths to
>     native SLI4"
>   Revert "scsi: lpfc: SLI path split: Refactor lpfc_iocbq"
>   scsi: lpfc: SLI path split: Refactor lpfc_iocbq
>   scsi: lpfc: SLI path split: Refactor fast and slow paths to native
>     SLI4
>   scsi: lpfc: SLI path split: Introduce lpfc_prep_wqe
>   scsi: lpfc: SLI path split: Refactor base ELS paths and the FLOGI path
>   scsi: lpfc: SLI path split: Refactor PLOGI/PRLI/ADISC/LOGO paths
>   scsi: lpfc: SLI path split: Refactor the RSCN/SCR/RDF/EDC/FARPR paths
>   scsi: lpfc: SLI path split: Refactor LS_ACC paths
>   scsi: lpfc: SLI path split: Refactor LS_RJT paths
>   scsi: lpfc: SLI path split: Refactor FDISC paths
>   scsi: lpfc: SLI path split: Refactor VMID paths
>   scsi: lpfc: SLI path split: Refactor misc ELS paths
>   scsi: lpfc: SLI path split: Refactor CT paths
>   scsi: lpfc: SLI path split: Refactor SCSI paths
>   scsi: lpfc: SLI path split: Refactor Abort paths
>   scsi: lpfc: SLI path split: Refactor BSG paths
>   scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand
>     after VMID
>   scsi: lpfc: Fix broken SLI4 abort path
>   scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()
>   scsi: lpfc: Remove redundant lpfc_sli_prep_wqe() call
>   scsi: lpfc: Fix split code for FLOGI on FCoE
>   scsi: lpfc: Correct BDE DMA address assignment for GEN_REQ_WQE
>   scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
>   scsi: lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event()
>   scsi: lpfc: Correct BDE type for XMIT_SEQ64_WQE in
>     lpfc_ct_reject_event()
>   scsi: lpfc: Resolve some cleanup issues following abort path
>     refactoring
>   scsi: lpfc: Resolve some cleanup issues following SLI path refactoring
> 
>  drivers/scsi/lpfc/lpfc.h           |   56 +-
>  drivers/scsi/lpfc/lpfc_bsg.c       |  303 ++---
>  drivers/scsi/lpfc/lpfc_crtn.h      |   21 +-
>  drivers/scsi/lpfc/lpfc_ct.c        |  338 +++--
>  drivers/scsi/lpfc/lpfc_els.c       | 1378 +++++++++++++-------
>  drivers/scsi/lpfc/lpfc_hbadisc.c   |   44 +-
>  drivers/scsi/lpfc/lpfc_hw.h        |   14 +-
>  drivers/scsi/lpfc/lpfc_hw4.h       |   29 +
>  drivers/scsi/lpfc/lpfc_nportdisc.c |   98 +-
>  drivers/scsi/lpfc/lpfc_nvme.c      |   11 +-
>  drivers/scsi/lpfc/lpfc_scsi.c      |    2 +-
>  drivers/scsi/lpfc/lpfc_sli.c       | 1953 +++++++++++++---------------
>  drivers/scsi/lpfc/lpfc_sli.h       |    5 +-
>  13 files changed, 2308 insertions(+), 1944 deletions(-)


Ick, this is crazy and way too much work for stable kernels, don't you
think?

How about I just take the reverts and stop there?

Also, when sending in patches for stable kernels, I need the upstream
git id in the changelog text somewhere.  I don't see that here, so I
couldn't take these as-is anyway :(

thanks,

greg k-h
