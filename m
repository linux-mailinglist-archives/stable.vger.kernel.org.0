Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F072757D15A
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 18:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbiGUQT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 12:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiGUQTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 12:19:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E27163C8
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 09:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA0F461E02
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 16:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE8FC341C0;
        Thu, 21 Jul 2022 16:19:05 +0000 (UTC)
Date:   Thu, 21 Jul 2022 17:19:01 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>, Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: set UXN on swapper page tables
Message-ID: <Ytl8dbOmTA05t7lA@arm.com>
References: <20220719234909.1398992-1-pcc@google.com>
 <165834388144.420659.7440428405850430601.b4-ty@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165834388144.420659.7440428405850430601.b4-ty@arm.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 20, 2022 at 08:04:48PM +0100, Catalin Marinas wrote:
> On Tue, 19 Jul 2022 16:49:09 -0700, Peter Collingbourne wrote:
> > On a system that implements FEAT_EPAN, read/write access to the idmap
> > is denied because UXN is not set on the swapper PTEs. As a result,
> > idmap_kpti_install_ng_mappings panics the kernel when accessing
> > __idmap_kpti_flag. Fix it by setting UXN on these PTEs.
> 
> Applied to arm64 (for-next/fixes), thanks!
> 
> [1/1] arm64: set UXN on swapper page tables
>       https://git.kernel.org/arm64/c/f7b4c3b82e7d

I'm dropping this patch from for-next/fixes as it breaks linux-next
(interacts badly with stuff already queued). We'll send it to -stable
separately as that's no longer needed in mainline after 5.19.

-- 
Catalin
