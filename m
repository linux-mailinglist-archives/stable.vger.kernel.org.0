Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3986B4CC949
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 23:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbiCCWnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 17:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiCCWnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 17:43:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609E4169384;
        Thu,  3 Mar 2022 14:42:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECD39B82700;
        Thu,  3 Mar 2022 22:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462FEC004E1;
        Thu,  3 Mar 2022 22:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646347332;
        bh=LlIfdRtUuZrzrB5nkf+T8cjTwpV1Lj/Ev0Wsq+zXmWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nIDDxLwC8iVzhNcqhrx593nEo/1SqIyd6NsFMMFN8QU1o/wXosUZVt3R6KrEor1HP
         7wzrSr5daJHtHNOpMbnCLYgAuO5I+GYHC5KJtxTZUE5+sE4OIfqCmi4HIYCLSUu1/L
         85tUzCfmXSQoqrwzPmzqa4H9badwu5mgh+WdDAQrm/HdhK8ZHhh5GMHh0+csVkv3fh
         KfMLt1PdolyFs/ZfBhasYB1KBLbx0AEKiPG1DLAGiG/NUlyifMYhD9JWbw5yRuWdTz
         FkSr8p+B2k8AGo1pNrJ0sXV7bjmTEYpb4wx70u8wCVObg7Xl9oJVtgf7rdkQxNuj3w
         AgwDxLRa7dyzA==
Date:   Fri, 4 Mar 2022 00:41:32 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Stefan Berger <stefanb@linux.ibm.com>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, David.Laight@aculab.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v8 1/1] tpm: fix reference counting for struct tpm_chip
Message-ID: <YiFEHCh+7Fm85yQK@iki.fi>
References: <20220301022108.30310-1-LinoSanfilippo@gmx.de>
 <20220301022108.30310-2-LinoSanfilippo@gmx.de>
 <99eff469-3faf-1e9a-9ad9-e087aeafc301@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99eff469-3faf-1e9a-9ad9-e087aeafc301@linux.ibm.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 01, 2022 at 07:36:34AM -0500, Stefan Berger wrote:
> 
> On 2/28/22 21:21, Lino Sanfilippo wrote:
> > From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> > 
> > The following sequence of operations results in a refcount warning:
> > 
> > 1. Open device /dev/tpmrm.
> > 2. Remove module tpm_tis_spi.
> > 3. Write a TPM command to the file descriptor opened at step 1.
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
> > refcount_t: addition on 0; use-after-free.
> > Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
> > sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
> > brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
> > raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
> > snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
> > CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
> > Hardware name: BCM2711
> > [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
> > [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
> > [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
> > [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
> > [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
> > [<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
> > [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
> > [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
> > [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
> > [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
> > Exception stack(0xc226bfa8 to 0xc226bff0)
> > bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
> > bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
> > bfe0: 0000006c beafe648 0001056c b6eb6944
> > ---[ end trace d4b8409def9b8b1f ]---
> > 
> > The reason for this warning is the attempt to get the chip->dev reference
> > in tpm_common_write() although the reference counter is already zero.
> > 
> > Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
> > extra reference used to prevent a premature zero counter is never taken,
> > because the required TPM_CHIP_FLAG_TPM2 flag is never set.
> > 
> > Fix this by moving the TPM 2 character device handling from
> > tpm_chip_alloc() to tpm_add_char_device() which is called at a later point
> > in time when the flag has been set in case of TPM2.
> > 
> > Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> > already introduced function tpm_devs_release() to release the extra
> > reference but did not implement the required put on chip->devs that results
> > in the call of this function.
> > 
> > Fix this by putting chip->devs in tpm_chip_unregister().
> > 
> > Finally move the new implementation for the TPM 2 handling into a new
> > function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in the
> > good case and error cases.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> > Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
> > Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> 
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>

Thanks, would be it be possible to also check v9?

BR, Jarkko
