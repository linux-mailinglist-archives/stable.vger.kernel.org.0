Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5E05236D0
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 17:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245602AbiEKPNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 11:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245590AbiEKPND (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 11:13:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74F110115D;
        Wed, 11 May 2022 08:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8137DB8249B;
        Wed, 11 May 2022 15:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D845BC340EE;
        Wed, 11 May 2022 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652281973;
        bh=xL0TzVaiEO5aQMaeWan8rwYgo0MOQI+Fp4FxzLjw2tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aKx+R2rdSnRCoaCHf9GcU1Xyf/iunPrgmyeh+ui8m1c9GlxKAgwv9joZXeECdC+fT
         NMbPxGFMb1oRXC/E7Mtqey0wDXb1wJ7zndfRptQNYcbNI4mlMcPizJpZgm0KQEFTDl
         IAY+5g3jvqN+N6U+GTiOjEnIUBTUqyiMr34Yzqq8EZiCww6tXlUsYWkx6p7YMVfRrW
         1JilVx2utCxQ2cOj5HWMez3mRG+OPR0ljhHJ914Vj5dvBskurJcBkIoTKDARvg7S8N
         cyte0dyNmz6J1Y30wXLEiazZGvHivPNjaZmgcHjMucEp2io+EK+L9lSUajIHxY1Aic
         cf9MJtoe/X7Cg==
Date:   Wed, 11 May 2022 18:11:23 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
Cc:     Marten.Lindahl@axis.com, jgg@ziepe.ca,
        johannes.holland@infineon.com, jsnitsel@redhat.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        martenli@axis.com, nayna@linux.vnet.ibm.com, peterhuewe@gmx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tpm: Fix buffer access in tpm2_get_tpm_pt()
Message-ID: <YnvSG0hfjqEe92v6@kernel.org>
References: <YnbL2R/a3SwA3fMC@iki.fi>
 <20220509114809.245621-1-stefan.mahnke-hartmann@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509114809.245621-1-stefan.mahnke-hartmann@infineon.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 01:48:09PM +0200, Stefan Mahnke-Hartmann wrote:
> On 07.05.22 21:43, Jarkko Sakkinen wrote:
> > On Fri, May 06, 2022 at 02:31:46PM +0200, Stefan Mahnke-Hartmann wrote:
> >> Under certain conditions uninitialized memory will be accessed.
> >> As described by TCG Trusted Platform Module Library Specification,
> >> rev. 1.59 (Part 3: Commands), if a TPM2_GetCapability is received,
> >> requesting a capability, the TPM in Field Upgrade mode may return a
> >                                       ~~~~~~~~~~~~~~~~~~
> >
> > Looks like random picks for casing: two words with upper case letter and
> > one with lowe case.
> 
> In the TCG specification it is unfortunately also inconsistent.
> I will change it to lower case then.
> 
> >
> >> zero length list.
> >> Check the property count in tpm2_get_tpm_pt().
> >>
> >> Fixes: 2ab3241161b3 ("tpm: migrate tpm2_get_tpm_pt() to use struct tpm_buf")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
> >
> > Which section is this in that specification documented?
> 
> It is described in the TCG Trusted Platform Module Library Specification,
> rev. 1.59 (Part 3: Commands) in Chapter 30.2.1, Example 3. This example
> describes the behavior in failure mode, but it may occur in other
> circumstances, such as field upgrade mode.
> 
> >
> > I looked into section 30.2 but could not find the part that documents this
> > behaviour, i.e. returning success in FW upgrade mode. Why it wouldn't just
> > return TPM_RC_UPGRADE?
> 
> Since some computer system failed booting up in case the TPM returned
> anything else than SUCCESS, therefore Infineon decided to return SUCCESS
> when TPM is in field upgrade mode.

OK, fair enough. This would be a place for inline comment though, given
that it is not obvious by intuition.

BR, Jarkko
