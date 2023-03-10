Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B16E6B5438
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 23:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjCJWY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 17:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbjCJWYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 17:24:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5728F1151C9;
        Fri, 10 Mar 2023 14:24:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A1A761D4A;
        Fri, 10 Mar 2023 22:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922FCC433EF;
        Fri, 10 Mar 2023 22:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678487055;
        bh=wBO740t5o2nLe95wsJDHfzac2ScEyqV1MZTnvh/dt6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k8X09bZ7g198jG6S9p1oZpJGrTKXtfdis3jvTm5HAOnPdpgHant54IaogMeLKglUz
         ZwON7utGZoKk8Q7ZsSFDcvzkPEh9vL9vQte3Bm9iiGfSLYQ5H8LdlqfhRNKxPPLOQ3
         ttF8wpP5vEgiLmFrLjbSZPz/rNRSz6NIL6hWp9F1v9qSnf4F8qsCAdusBGFRHy44gZ
         joUTFP3nVpdW094RVDw79nU6n2DmTr9sBAh0qjnUTMek6jXLtZ8sRTXwFYd6v2/Qxl
         SkXb6l4YJTRebzRLzJD7ok+0RoEroGoNH15xAhesL21iH81MBR/mDOMIK4yvyjoblo
         kU3gm10j3cyQQ==
Date:   Fri, 10 Mar 2023 14:24:14 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH 2/3] f2fs: factor out discard_cmd usage from
 general rb_tree use
Message-ID: <ZAuuDkwBgcJ6dBul@sol.localdomain>
References: <20230310210454.2350881-1-jaegeuk@kernel.org>
 <20230310210454.2350881-2-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310210454.2350881-2-jaegeuk@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 01:04:53PM -0800, Jaegeuk Kim wrote:
> +static bool f2fs_check_discard_tree(struct f2fs_sb_info *sbi)
> +{
> +#ifdef CONFIG_F2FS_CHECK_FS
> +	struct discard_cmd_control *dcc = SM_I(sbi)->dcc_info;
> +	struct rb_node *cur = rb_first_cached(&dcc->root), *next;
> +	struct discard_cmd *cur_dc, *next_dc;
> +
> +	if (!cur)
> +		return true;
> +
> +	while (cur) {

The !cur check is redundant here.

- Eric
