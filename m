Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959EB3558E4
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346251AbhDFQKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 12:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346243AbhDFQKM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 12:10:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F93A613BD;
        Tue,  6 Apr 2021 16:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617725404;
        bh=hbOASQD2fS9ZoYpgXs9JA15VayI2Xs8Jh7cHcLFtAXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pqaSxmgrXw/bYtmBy54DQaKjH1Bn3tqUFRsPt01GK4KkRDy7emzo/rwUjBEJx2Q3q
         IEYHxkOtrm0OBBfadw14fCWdvkJ2nthUaCJbTMCgfAD7bV4hisB/6OmHA+M6ruOTmL
         T1t3k8g8zbV0AwfCPKqnjkCJ75J8b1SiM620BX/y2+O5ON+d2IZ5QjgY1hpgdLa6V4
         /xLkuZc+mLMuW4vQsInH43cHyYDOevxkWeOw2haqnySe+TaXgw3QEqG1XNxZ0rjMd5
         Nf5GpurJbduEKrGn+8tARgPDetM0I7SuKtWLdc/J2+p7LlA+lSxbUocW70NcaEJ+Db
         dpemHrfXmX40w==
Date:   Tue, 6 Apr 2021 12:10:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/8] preserve DMA offsets when using swiotlb
Message-ID: <YGyH20fvYV8ySijn@sashalap>
References: <20210405205109.1700468-1-jxgao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210405205109.1700468-1-jxgao@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 08:51:01PM +0000, Jianxiong Gao wrote:
>Hi all,
>
>This series of backports fixes the SWIOTLB library to maintain the
>page offset when mapping a DMA address. The bug that motivated this
>patch series manifested when running a 5.4 kernel as a SEV guest with
>an NVMe device. However, any device that infers information from the
>page offset and is accessed through the SWIOTLB will benefit from this
>bug fix.
>
>Jianxiong Gao (7):
>  driver core: add a min_align_mask field to struct
>    device_dma_parameters
>  swiotlb: add a io_tlb_offset helper
>  swiotlb: factor out a nr_slots helper
>  swiotlb: clean up swiotlb_tbl_unmap_single
>  swiotlb: refactor swiotlb_tbl_map_single
>  swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single
>  nvme-pci: set min_align_mask
>
>Linus Torvalds (1):
>  Linux 5.4

This is clearly wrong :)

This series also doesn't apply cleanly, what did you use as a base?

Also, why are the sign-offs on individual patches different between your
patches and upstream?

-- 
Thanks,
Sasha
