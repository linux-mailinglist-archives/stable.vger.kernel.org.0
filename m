Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6226968F5EA
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 18:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjBHRqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 12:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjBHRpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 12:45:23 -0500
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D9D51C49;
        Wed,  8 Feb 2023 09:44:19 -0800 (PST)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20230208173731usoutp02114f7c9b6e983e2e7ea2adc30052853b~B6gbA7rwA2706027060usoutp02z;
        Wed,  8 Feb 2023 17:37:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20230208173731usoutp02114f7c9b6e983e2e7ea2adc30052853b~B6gbA7rwA2706027060usoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1675877851;
        bh=DrVmy24nHFbRK4jTbsef82LhCdWYgfzbqBv3ctj3ASs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=qCEXVZdaCgsXHelZkV2XUwocL8Xz9d7vhIlG5DlAd1gHvrzRDuguGW2W+n7NJE7a+
         S9RCPPyLI/PFfILY2f+sG+PMcldRJnyjZSRWasY15kzErcBk8THHV5fr6osm0WotWn
         NdY1yHzK/NbPMcseqOcwKiW6/sbHNOssjKtlZIBA=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20230208173730uscas1p1c9b9c414603573d91c52d530e399ce7b~B6ga4sc4g0175001750uscas1p1F;
        Wed,  8 Feb 2023 17:37:30 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 24.66.49129.ADDD3E36; Wed, 
        8 Feb 2023 12:37:30 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20230208173730uscas1p2af3a9eeb8946dfa607b190c079a49653~B6gamcPQD0660206602uscas1p2I;
        Wed,  8 Feb 2023 17:37:30 +0000 (GMT)
X-AuditID: cbfec36f-eddff7000001bfe9-98-63e3ddda5e6d
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id BA.B3.11378.ADDD3E36; Wed, 
        8 Feb 2023 12:37:30 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Wed, 8 Feb 2023 09:37:29 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
        SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Wed,
        8 Feb 2023 09:37:29 -0800
From:   Fan Ni <fan.ni@samsung.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        "dave@stgolabs.net" <dave@stgolabs.net>
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Thread-Topic: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
        default
Thread-Index: AQHZO+QE3nZq3IrnrkiMD6aqk0DnLw==
Date:   Wed, 8 Feb 2023 17:37:29 +0000
Message-ID: <20230208173720.GA709329@bgt-140510-bm03>
In-Reply-To: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8CC4933716740C43BFB545E163AC7CB8@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7djX87q37j5ONlhywMRi+tQLjBYvNrQz
        Wqy+uYbR4uv6X8wWZ7pzLZbv62e0OD/rFIvFvTX/WS3u9zlYLNj4iNGBy2N2w0UWj8V7XjJ5
        bPo0id1j3slAj/f7rrJ5TJ1d77F+y1UWj8+b5AI4orhsUlJzMstSi/TtErgyJm2YxFTwx6Li
        ztsmxgbGo1pdjJwcEgImEif+zmPtYuTiEBJYySjReq+FCcJpZZL49nEnI0xVT8siZojEWkaJ
        DbfeMEI4Hxklbrc9YYdwljJKPPxwnA2khU1AUWJf13YwW0RAW2LinINg7cwCJ5klZn2awg6S
        EBYIkZg9/TkzRFGoxISGtSxdjBxAtp7Eh2sZIGEWARWJp833wcp5BUwlenr3sIDYnAJhEj3H
        LoLFGQXEJL6fWsMEYjMLiEvcejKfCeJsQYlFs/cwQ9hiEv92PWSDsBUl7n9/yQ5RryOxYPcn
        NpC1zAJ2Eos2cUGEtSWWLXzNDLFWUOLkzCcsEK2SEgdX3GABeUVCoJlTYuH5tewQCReJNTev
        Qs2Xlrh6fSozyEwJgWSJVR+5IMI5EvOXbIGaYy2x8M96pgmMKrOQXD0LyUWzEC6aheSiWUgu
        WsDIuopRvLS4ODc9tdgoL7Vcrzgxt7g0L10vOT93EyMwoZ3+dzh/B+P1Wx/1DjEycTAeYpTg
        YFYS4f0+8XGyEG9KYmVValF+fFFpTmrxIUZpDhYlcV5D25PJQgLpiSWp2ampBalFMFkmDk6p
        BqaDCzO/xwfO1+lXLQpvemPl+HvVwnrRQ97cf4Juzth82S1BrVRj5vxElal6SdtvHYnp2Kdy
        +L/0x1Nnbu9p2XaK+83t0i8PRXQfmLcsEYtIklgXZ5EsML/k9ofehmlPNFnLGbTn3i93/LXi
        ofdKn5Cf9RU8s/3DflwKESqZMuMPZ8LMc6oVs+fJPDAzYH4yvX/2fYn9ZefmPyyU/39B4WiV
        1pdCM/GtIQVS/Lk5CR+/LWJ1lHx2zvgCa7iEZwD3vvfZxn///CyubS2QXzbp4K6lac7nf2p1
        LErkXblEwnzpjK+26zxKgswc/GRlln77O6+G99z9nz0Ghdvm8q1UUjj0TOH69/RbtwKLHDLn
        pYgrsRRnJBpqMRcVJwIA6spSF9cDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsWS2cA0UffW3cfJBjsvK1hMn3qB0eLFhnZG
        i9U31zBafF3/i9niTHeuxfJ9/YwW52edYrG4t+Y/q8X9PgeLBRsfMTpwecxuuMjisXjPSyaP
        TZ8msXvMOxno8X7fVTaPqbPrPdZvucri8XmTXABHFJdNSmpOZllqkb5dAlfGpA2TmAr+WFTc
        edvE2MB4VKuLkZNDQsBEoqdlETOILSSwmlHid5dAFyMXkP2RUeLF4musEImljBL7elxAbDYB
        RYl9XdvZQGwRAW2JiXMOMoM0MAucZJZ49+gIE0hCWCBEYvb058wQRaES5zbcBYpzANl6Eh+u
        ZYCEWQRUJJ4232cHsXkFTCV6evewQOwKlbg75QEjiM0pECbRc+wiWA2jgJjE91NrwMYzC4hL
        3HoynwniAQGJJXvOM0PYohIvH/9jhbAVJe5/f8kOUa8jsWD3JzaQE5gF7CQWbeKCCGtLLFv4
        mhniBEGJkzOfsEC0SkocXHGDZQKjxCwk22YhmTQLYdIsJJNmIZm0gJF1FaN4aXFxbnpFsWFe
        arlecWJucWleul5yfu4mRmAiOP3vcOQOxqO3PuodYmTiYDzEKMHBrCTC+33i42Qh3pTEyqrU
        ovz4otKc1OJDjNIcLErivEKuE+OFBNITS1KzU1MLUotgskwcnFINTMzO3G9/TUtM++/XxjJ5
        wsRp4iK/T1t6b78aOO940qYpewxY44M5Dnwz/nLo427naH3FTolAQW/lvhdvgife0m9dvFL6
        bXb9hoj7h6IMbqiX5D2Mibggwh7tO/Xq9puvQzk3PXB+n7Ww568pw197H+deOcn/EUZJk3Z/
        d/zxge+tvFD6v2sz5M33Hc01c6o7rv0if5Ldr4Lm01tfxu6sqg4WdT/UPjHU+7LuMaZ2Zl3W
        9wv23OMX00zY7rLTsaJBIjTz7ZHFb2eoRi1yeGEe6/hE7VjnlZ4u4YAgCzuZAx1i1b7hqT/Y
        4szmF84SrfXSLFkauNEzr8zNeNbXOZ7fVPIDDjBoT18vpGyoOa1ZiaU4I9FQi7moOBEAxWXZ
        4nMDAAA=
X-CMS-MailID: 20230208173730uscas1p2af3a9eeb8946dfa607b190c079a49653
CMS-TYPE: 301P
X-CMS-RootMailID: 20230208173730uscas1p2af3a9eeb8946dfa607b190c079a49653
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
        <CGME20230208173730uscas1p2af3a9eeb8946dfa607b190c079a49653@uscas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:


> Summary:
> --------
>=20
> CXL RAM support allows for the dynamic provisioning of new CXL RAM
> regions, and more routinely, assembling a region from an existing
> configuration established by platform-firmware. The latter is motivated
> by CXL memory RAS (Reliability, Availability and Serviceability)
> support, that requires associating device events with System Physical
> Address ranges and vice versa.
>=20
> The 'Soft Reserved' policy rework arranges for performance
> differentiated memory like CXL attached DRAM, or high-bandwidth memory,
> to be designated for 'System RAM' by default, rather than the device-dax
> dedicated access mode. That current device-dax default is confusing and
> surprising for the Pareto of users that do not expect memory to be
> quarantined for dedicated access by default. Most users expect all
> 'System RAM'-capable memory to show up in FREE(1).
>=20
>=20
> Details:
> --------
>=20
> Recall that the Linux 'Soft Reserved' designation for memory is a
> reaction to platform-firmware, like EFI EDK2, delineating memory with
> the EFI Specific Purpose Memory attribute (EFI_MEMORY_SP). An
> alternative way to think of that attribute is that it specifies the
> *not* general-purpose memory pool. It is memory that may be too precious
> for general usage or not performant enough for some hot data structures.
> However, in the absence of explicit policy it should just be 'System
> RAM' by default.
>=20
> Rather than require every distribution to ship a udev policy to assign
> dax devices to dax_kmem (the device-memory hotplug driver) just make
> that the kernel default. This is similar to the rationale in:
>=20
> commit 8604d9e534a3 ("memory_hotplug: introduce CONFIG_MEMORY_HOTPLUG_DEF=
AULT_ONLINE")
>=20
> With this change the relatively niche use case of accessing this memory
> via mapping a device-dax instance can be achieved by building with
> CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=3Dn, or specifying
> memhp_default_state=3Doffline at boot, and then use:
>=20
>     daxctl reconfigure-device $device -m devdax --force
>=20
> ...to shift the corresponding address range to device-dax access.
>=20
> The process of assembling a device-dax instance for a given CXL region
> device configuration is similar to the process of assembling a
> Device-Mapper or MDRAID storage-device array. Specifically, asynchronous
> probing by the PCI and driver core enumerates all CXL endpoints and
> their decoders. Then, once enough decoders have arrived to a describe a
> given region, that region is passed to the device-dax subsystem where it
> is subject to the above 'dax_kmem' policy. This assignment and policy
> choice is only possible if memory is set aside by the 'Soft Reserved'
> designation. Otherwise, CXL that is mapped as 'System RAM' becomes
> immutable by CXL driver mechanisms, but is still enumerated for RAS
> purposes.
>=20
> This series is also available via:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=3Dfor-=
6.3/cxl-ram-region
>=20
> ...and has gone through some preview testing in various forms.
>=20
> ---

Tested-by: Fan Ni <fan.ni@samsung.com>


Run the following tests with the patch (with the volatile support at qemu).
Note: cxl related code are compiled as modules and loaded before used.

For pmem setup, tried three topologies (1HB1RP1Mem, 1HB2RP2Mem, 1HB2RP4Mem =
with
a cxl switch). The memdev is either provided in the command line when launc=
hing
qemu or hot added to the guest with device_add command in qemu monitor.

The following operations are performed,
1. create-region with cxl cmd
2. create name-space with ndctl cmd
3. convert cxl mem to ram with daxctl cmd
4. online the memory with daxctl cmd
5. Let app use the memory (numactl --membind=3D1 htop)

Results: No regression.

For volatile memory (hot add with device_add command), mainly tested 1HB1RP=
1Mem
case (passthrough).
1. the device can be correctly discovered after hot add (cxl list, may need
cxl enable-memdev)
2. creating ram region (cxl create-region) succeeded, after creating the
region, a dax device under /dev/ is shown.
3. online the memory passes, and the memory is shown on another NUMA node.
4. Let app use the memory (numactl --membind=3D1 htop) passed.




>=20
> Dan Williams (18):
>       cxl/Documentation: Update references to attributes added in v6.0
>       cxl/region: Add a mode attribute for regions
>       cxl/region: Support empty uuids for non-pmem regions
>       cxl/region: Validate region mode vs decoder mode
>       cxl/region: Add volatile region creation support
>       cxl/region: Refactor attach_target() for autodiscovery
>       cxl/region: Move region-position validation to a helper
>       kernel/range: Uplevel the cxl subsystem's range_contains() helper
>       cxl/region: Enable CONFIG_CXL_REGION to be toggled
>       cxl/region: Fix passthrough-decoder detection
>       cxl/region: Add region autodiscovery
>       tools/testing/cxl: Define a fixed volatile configuration to parse
>       dax/hmem: Move HMAT and Soft reservation probe initcall level
>       dax/hmem: Drop unnecessary dax_hmem_remove()
>       dax/hmem: Convey the dax range via memregion_info()
>       dax/hmem: Move hmem device registration to dax_hmem.ko
>       dax: Assign RAM regions to memory-hotplug by default
>       cxl/dax: Create dax devices for CXL RAM regions
>=20
>=20
>  Documentation/ABI/testing/sysfs-bus-cxl |   64 +-
>  MAINTAINERS                             |    1=20
>  drivers/acpi/numa/hmat.c                |    4=20
>  drivers/cxl/Kconfig                     |   12=20
>  drivers/cxl/acpi.c                      |    3=20
>  drivers/cxl/core/core.h                 |    7=20
>  drivers/cxl/core/hdm.c                  |    8=20
>  drivers/cxl/core/pci.c                  |    5=20
>  drivers/cxl/core/port.c                 |   34 +
>  drivers/cxl/core/region.c               |  848 +++++++++++++++++++++++++=
+++---
>  drivers/cxl/cxl.h                       |   46 ++
>  drivers/cxl/cxlmem.h                    |    3=20
>  drivers/cxl/port.c                      |   26 +
>  drivers/dax/Kconfig                     |   17 +
>  drivers/dax/Makefile                    |    2=20
>  drivers/dax/bus.c                       |   53 +-
>  drivers/dax/bus.h                       |   12=20
>  drivers/dax/cxl.c                       |   53 ++
>  drivers/dax/device.c                    |    3=20
>  drivers/dax/hmem/Makefile               |    3=20
>  drivers/dax/hmem/device.c               |  102 ++--
>  drivers/dax/hmem/hmem.c                 |  148 +++++
>  drivers/dax/kmem.c                      |    1=20
>  include/linux/dax.h                     |    7=20
>  include/linux/memregion.h               |    2=20
>  include/linux/range.h                   |    5=20
>  lib/stackinit_kunit.c                   |    6=20
>  tools/testing/cxl/test/cxl.c            |  146 +++++
>  28 files changed, 1355 insertions(+), 266 deletions(-)
>  create mode 100644 drivers/dax/cxl.c
>=20
> base-commit: 172738bbccdb4ef76bdd72fc72a315c741c39161
> =
