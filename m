Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EF86D715E
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 02:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbjDEAfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 20:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbjDEAfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 20:35:51 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68BF340FB;
        Tue,  4 Apr 2023 17:35:50 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id 47FBF210DEA2; Tue,  4 Apr 2023 17:35:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 47FBF210DEA2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1680654949;
        bh=Lm837P1CWGU8gkD+0NV2QWBXE5Jg3ngDlIEqKcG2dP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bm+VFJUTZ9EP37yQqCXwxrbvAIZkC7cLHJlx+azokqRk0E1LbMTvMiGWyVnjYGv5L
         QVCO0+0iouZxRAkyN/RA4tKcR0ejiuxJ77Y2lDJK6j2SuGnLJveu3JG6ngEH/KD57A
         CvkVQmNtE6VWGJO/SBE8g62bCiQAXfNZO3AyDsYI=
Date:   Tue, 4 Apr 2023 17:35:49 -0700
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        decui@microsoft.com, petrtesarik@huaweicloud.com,
        linux-hyperv@vger.kernel.org, iommu@lists.linux.dev,
        robin.murphy@arm.com, dexuan.linux@gmail.com,
        tyler.hicks@microsoft.com
Subject: Re: [PATCH 6.1 000/179] 6.1.23-rc2 review
Message-ID: <20230405003549.GA21326@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230404183150.381314754@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404183150.381314754@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 08:32:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Apr 2023 18:31:13 +0000.
> Anything received after that time might be too late.
> 

Hi Greg, 

6.1.23-rc2 is failing to boot on x86 WSL. A bisect leads to commit
c2f05366b687 ("swiotlb: fix slot alignment checks") being the problem
and reverting this patch puts everything back in a working state.

There's a report from Dexuan who also encountered this error on a Linux
VM on Hyper-V:

https://lore.kernel.org/all/CAA42JLa1y9jJ7BgQvXeUYQh-K2mDNHd2BYZ4iZUz33r5zY7oAQ@mail.gmail.com/

Adding a chunk of my log below which shows errors occuring from the hv_strvsc driver.

+cc Dexuan, Petr, Tyler, Hyper-V list, swiotlb list and maintainers

-Kelsey



[    1.796960] scsi 0:0:0:0: Direct-Access
PQ: 0 ANSI: 0
[    1.798026] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.799408] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
[    1.800296] sd 0:0:0:0: [sda] 1 512-byte logical blocks: (512 B/512
B)
[    1.801029] sd 0:0:0:0: [sda] 0-byte physical blocks
[    1.804195] sd 0:0:0:0: [sda] Write Protect is on
[    1.804820] sd 0:0:0:0: [sda] Mode Sense: 0f 00 80 00
[    1.806353] scsi 0:1:1:0: Direct-Access
PQ: 0 ANSI: 0
[    1.806711] sd 0:0:0:0: [sda] Asking for cache data failed
[    1.807534] sd 0:1:1:0: Attached scsi generic sg9 type 0
[    1.808063] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    1.809789] sd 0:1:1:0: [sdj] Test Unit Ready failed: Result:
hostbyte=0x01 driverbyte=DRIVER_OK
[    1.810476] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
[    1.810988] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#520
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.812072] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#521
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.812943] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#522
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.812966] scsi 0:4:0:0: Direct-Access
PQ: 0 ANSI: 0
[    1.813001] sd 0:1:1:0: [sdj] Read Capacity(10) failed: Result:
hostbyte=0x01 driverbyte=DRIVER_OK
[    1.813097] scsi 0:4:0:0: Attached scsi generic sg10 type 0
[    1.815128] sd 0:4:0:0: [sdk] Test Unit Ready failed: Result:
hostbyte=0x01 driverbyte=DRIVER_OK
[    1.815790] scsi 0:6:0:0: Direct-Access
PQ: 0 ANSI: 0
[    1.815949] sd 0:6:0:0: Attached scsi generic sg11 type 0
[    1.816072] sd 0:0:0:0: [sda] Write Protect is off
[    1.816075] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[    1.816466] sd 0:1:1:0: [sdj] Sense not available.
[    1.816515] sd 0:1:1:0: [sdj] 0 512-byte logical blocks: (0 B/0 B)
[    1.816517] sd 0:1:1:0: [sdj] 0-byte physical blocks
[    1.816974] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#155
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.817056] sd 0:1:1:0: [sdj] Write Protect is off
[    1.817058] sd 0:1:1:0: [sdj] Mode Sense: 00 00 00 00
[    1.817756] sd 0:6:0:0: [sdl] Test Unit Ready failed: Result:
hostbyte=0x01 driverbyte=DRIVER_OK
[    1.818109] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#67
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.820136] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#68
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.821920] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#69
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.822789] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#156
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.823115] sd 0:1:1:0: [sdj] Asking for cache data failed
[    1.823367] sd 0:6:0:0: [sdl] Read Capacity(10) failed: Result:
hostbyte=0x01 driverbyte=DRIVER_OK
[    1.823373] sd 0:6:0:0: [sdl] Sense not available.
[    1.823376] sd 0:6:0:0: [sdl] 0 512-byte logical blocks: (0 B/0 B)
[    1.823377] sd 0:6:0:0: [sdl] 0-byte physical blocks
[    1.825457] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.825632] sd 0:6:0:0: [sdl] Write Protect is off
[    1.825636] sd 0:6:0:0: [sdl] Mode Sense: 00 00 00 00
[    1.825934] sd 0:1:1:0: [sdj] Assuming drive cache: write through
[    1.825970] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#157
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.826005] sd 0:6:0:0: [sdl] Asking for cache data failed
[    1.826007] sd 0:6:0:0: [sdl] Assuming drive cache: write through
[    1.826092] sd 0:4:0:0: [sdk] Read Capacity(10) failed: Result:
hostbyte=0x01 driverbyte=DRIVER_OK
[    1.826141] sd 0:1:1:0: [sdj] Attached SCSI disk
[    1.826649] sd 0:6:0:0: [sdl] Attached SCSI disk
[    1.845293] sd 0:4:0:0: [sdk] Sense not available.
[    1.846327] sd 0:4:0:0: [sdk] 0 512-byte logical blocks: (0 B/0 B)
[    1.847370] sd 0:4:0:0: [sdk] 0-byte physical blocks
[    1.854709] sd 0:4:0:0: [sdk] Write Protect is off
[    1.855569] sd 0:4:0:0: [sdk] Mode Sense: 00 00 00 00
[    1.858191] sd 0:4:0:0: [sdk] Asking for cache data failed
[    1.858876] sd 0:4:0:0: [sdk] Assuming drive cache: write through
[    1.860270] sd 0:4:0:0: [sdk] Attached SCSI disk
[    1.965050] scsi 0:0:0:0: Direct-Access
PQ: 0 ANSI: 0
[    1.966030] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.966347] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
[    1.967120] sd 0:0:0:0: [sda] 1 512-byte logical blocks: (512 B/512
B)
[    1.967175] scsi 0:0:0:1: Direct-Access     Msft     Virtual Disk
1.0  PQ: 0 ANSI: 5
[    1.967644] sd 0:0:0:0: [sda] 0-byte physical blocks
[    1.968899] scsi 0:0:0:1: scsi_get_vpd_buf: VPD page 0x00 result 12 >
4 bytes
[    1.969160] sd 0:0:0:0: [sda] Write Protect is on
[    1.970184] sd 0:0:0:0: [sda] Mode Sense: 0f 00 80 00
[    1.970797] sd 0:0:0:0: [sda] Asking for cache data failed
[    1.971230] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    1.972270] sd 0:0:0:1: Attached scsi generic sg12 type 0
[    1.972511] sd 0:0:0:1: [sdm] 8388616 512-byte logical blocks: (4.29
GB/4.00 GiB)
[    1.972763] sd 0:0:0:0: [sda] 744728 512-byte logical blocks: (381
MB/364 MiB)
[    1.973379] sd 0:0:0:1: [sdm] 4096-byte physical blocks
[    1.973749] sd 0:0:0:1: [sdm] Write Protect is off
[    1.974745] sda: detected capacity change from 1 to 744728
[    1.974776] sd 0:0:0:1: [sdm] Mode Sense: 00 00 00 00
[    1.974781] scsi 0:2:1:0: Direct-Access
PQ: 0 ANSI: 0
[    1.974925] sd 0:2:1:0: Attached scsi generic sg13 type 0
[    1.977046] sd 0:2:1:0: [sdn] Test Unit Ready failed: Result:
hostbyte=0x01 driverbyte=DRIVER_OK
[    1.978129] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.979617] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#30
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.979972] sd 0:0:0:1: [sdm] No Caching mode page found
[    1.981154] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#31
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.981172] sd 0:0:0:1: [sdm] Assuming drive cache: write through
[    1.982140] EXT4-fs (sda): VFS: Can't find ext4 filesystem
[    1.982953] scsi 0:7:0:0: Direct-Access
PQ: 0 ANSI: 0
[    1.982957] hv_storvsc fd1d2cbd-ce7c-535c-966b-eb5f811c95f0: tag#32
cmd 0x25 status: scsi 0x0 srb 0x20 hv 0xc0000001
[    1.983085] sd 0:2:1:0: [sdn] Read Capacity(10) failed: Result:
hostbyte=0x01 driverbyte=DRIVER_OK
[    1.983088] sd 0:2:1:0: [sdn] Sense not availThe connection with the
virtual machine or container was closed.





