Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B11051E98C
	for <lists+stable@lfdr.de>; Sat,  7 May 2022 21:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346517AbiEGTph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 15:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbiEGTph (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 15:45:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC24D2B275;
        Sat,  7 May 2022 12:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 839F8B8068C;
        Sat,  7 May 2022 19:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B4AC385AC;
        Sat,  7 May 2022 19:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651952507;
        bh=Uocodj44OGa6wP2CSv2SNJwnjTs5eandl68Fm7eawW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XbxIYqvP0FujJLy2tyKS4lgKGymjgLyjU+YcEvaOHSlD5XI0lzD7cNJ6K7XVpBHup
         oLP3RQW1sP03R1GiGq+IOqkhjet9rEjhXfDP9rT+Knya+9fgPZduJTbBpzOZa+wZjU
         OdP9Wdsb3riEoNGxy4lQN9h9NNJxeZlwH/+86AikTLicFtS2TilvMIh43bvib+DVgT
         sCguIv+2NbTZYbcJO7/Y/xtDq1ovaMyEZ5qLtfxs4FVokOLy4KvicLmEaNkVo8QoAx
         99p4nKRljzC99l5ZoGuL1hkNEviXZtWevi/xcKmFLSoAcSck3D+VbMRHqei+SoiFxw
         NIexdsqNGc13w==
Date:   Sat, 7 May 2022 22:43:21 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marten.Lindahl@axis.com, martenli@axis.com, jgg@ziepe.ca,
        jsnitsel@redhat.com, nayna@linux.vnet.ibm.com,
        johannes.holland@infineon.com, peterhuewe@gmx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tpm: Fix buffer access in tpm2_get_tpm_pt()
Message-ID: <YnbL2R/a3SwA3fMC@iki.fi>
References: <20220506123145.229058-1-stefan.mahnke-hartmann@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506123145.229058-1-stefan.mahnke-hartmann@infineon.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 02:31:46PM +0200, Stefan Mahnke-Hartmann wrote:
> Under certain conditions uninitialized memory will be accessed.
> As described by TCG Trusted Platform Module Library Specification,
> rev. 1.59 (Part 3: Commands), if a TPM2_GetCapability is received,
> requesting a capability, the TPM in Field Upgrade mode may return a
                                      ~~~~~~~~~~~~~~~~~~

Looks like random picks for casing: two words with upper case letter and
one with lowe case.

> zero length list.
> Check the property count in tpm2_get_tpm_pt().
> 
> Fixes: 2ab3241161b3 ("tpm: migrate tpm2_get_tpm_pt() to use struct tpm_buf")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>

Which section is this in that specification documented?

I looked into section 30.2 but could not find the part that documents this
behaviour, i.e. returning success in FW upgrade mode. Why it wouldn't just
return TPM_RC_UPGRADE?

BR, Jarkko

 
