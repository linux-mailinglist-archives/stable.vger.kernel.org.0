Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96928544558
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 10:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbiFIIIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 04:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240450AbiFIIII (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 04:08:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8BD1157F7;
        Thu,  9 Jun 2022 01:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09D9EB82C3C;
        Thu,  9 Jun 2022 08:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39328C34114;
        Thu,  9 Jun 2022 08:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654762084;
        bh=VUEvKySVaE7RF0deKcJ/G+d/pOEYQYj0Bdn8d40rA4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tb3WsxPnTYPcD3Pccnx794lx7pJ5c4UMK7zLwEDQ1XeZI8aVsvbSymsgP+hreuHn0
         SPwI6gBoYr8MzRG5E1ssWfXPbNGbZHTNN1pwjieT6pQNxqJDM78FlGomqm1qGYfYBA
         JeWOQjLoHXv9vPcvIBG/3d1TCnQ7zVRu696rBkxY=
Date:   Thu, 9 Jun 2022 10:08:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ron Economos <re@w6rz.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
Message-ID: <YqGqYd89cM+IB74e@kroah.com>
References: <20220607164948.980838585@linuxfoundation.org>
 <0a063e00-360e-7b63-988c-e6c028063cf9@w6rz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a063e00-360e-7b63-988c-e6c028063cf9@w6rz.net>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 04:23:04PM -0700, Ron Economos wrote:
> On 6/7/22 9:53 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.17.14 release.
> > There are 772 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> Regression on RISC-V RV64 (HiFive Unmatched).
> 
> An Oops occurs when an NFS file system is mounted.
> 
> [   98.244615] FS-Cache: Loaded
> [   99.311566] NFS: Registering the id_resolver key type
> [   99.311621] Key type id_resolver registered
> [   99.311626] Key type id_legacy registered
> [   99.469053] Unable to handle kernel access to user memory without uaccess
> routines at virtual address 0000000000000000
> [   99.479039] Oops [#1]
> [   99.481246] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs
> lockd grace fscache netfs nvme_fabrics sunrpc binfmt_misc nls_iso8859_1
> da9063_onkey lm90 at24 uio_pdrv_genirq uio sch_fq_codel dm_multipath
> scsi_dh_rdac scsi_dh_emc scsi_dh_alua ipmi_devintf ipmi_msghandler drm
> backlight ip_tables x_tables autofs4 btrfs blake2b_generic zstd_compress
> raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx
> xor raid6_pq libcrc32c raid1 raid0 multipath linear rtc_da9063
> da9063_regulator mscc macsec nvme macb xhci_pci nvme_core xhci_pci_renesas
> i2c_ocores phylink
> [   99.532427] CPU: 2 PID: 889 Comm: mount.nfs Not tainted 5.17.13 #1
> [   99.538572] Hardware name: SiFive HiFive Unmatched A00 (DT)
> [   99.544133] epc : nfs_fattr_init+0x1e/0x48 [nfs]
> [   99.549059]  ra : _nfs41_proc_get_locations+0xb4/0x128 [nfsv4]
> [   99.555877] epc : ffffffff02332e76 ra : ffffffff023c076c sp :
> ffffffc894793960
> [   99.563084]  gp : ffffffff81a2ed00 tp : ffffffd896180000 t0 :
> ffffffd887720000
> [   99.570294]  t1 : ffffffff81a9c110 t2 : ffffffff81003c04 s0 :
> ffffffc894793970
> [   99.577503]  s1 : ffffffd887700000 a0 : 0000000000000000 a1 :
> ffffffd883de3d80
> [   99.584721]  a2 : ffffffd887700000 a3 : ffffffc704608a00 a4 :
> ffffffff0236aa28
> [   99.591924]  a5 : ffffffff02410cf8 a6 : ffffffff0240fc00 a7 :
> 0000000000000006
> [   99.599134]  s2 : ffffffd885df6000 s3 : ffffffc8947939c8 s4 :
> ffffffc894793998
> [   99.606343]  s5 : ffffffd881a9f000 s6 : ffffffc704608a00 s7 :
> ffffffff021c7db8
> [   99.613552]  s8 : ffffffff0240fd50 s9 : 0000000000000cc0 s10:
> 0000003fd7d2e260
> [   99.620762]  s11: 0000000000016700 t3 : 0000000000000020 t4 :
> 0000000000000001
> [   99.627971]  t5 : ffffffdbffdde088 t6 : ffffffdbffdde0a8
> [   99.633266] status: 0000000200000120 badaddr: 0000000000000000 cause:
> 000000000000000f
> [   99.641236] ---[ end trace 0000000000000000 ]---
> 
> Manually bisected to this commit:
> 
> NFSv4: Fix free of uninitialized nfs4_label on referral lookup.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.17.y&id=9a4a2efee41c4aca43988c43e16d44656f3c2132
> 

That's odd you see this here on 5.17, but NOT on 5.18 with the same
commit merged there.  I'll drop this from 5.17 and as this will probably
be the last (or next to last) 5.17 kernel release, not worry too much
about it.

thanks,

greg k-h
