Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03963C59F7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345869AbhGLJVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 05:21:42 -0400
Received: from mail-bn8nam08on2076.outbound.protection.outlook.com ([40.107.100.76]:24124
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345946AbhGLJVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 05:21:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmbvOskaDztYnV04MuSl7v4pwvrz3rZw5f4qlpYwk9dLYMSJxElwJyhIPzuZx2PwugIEeXFn2V4zctKPO1jzJ5rURB/T0fFdqdovzHLyRbQGPSNOM/keCylLCPqS1XKXxL1rqha2ox6qxzcR0ppBvyTGuTrpIlDOhcLKntSs7D0fK26EFJ4vVHcU/Dg03uZmv+SeUfIBSVZF6wLbAMHpoHoVs4Zw+bI6jEEgZDEdQMBMlo/ZQeXTh7Q9RodD88+LF1tZfUUNpWoATSAZWag3GrmsAVqkw92q7vZOjAkAxOlnbpEL0mFnO+GcHDES0pAA5xEhP7/Vo7BETHfUMxqh6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vg94QbL673h3WoKmxoKoqsJ4QP+i8Jm/CKFhTKcWEIk=;
 b=SCCPzz6OQEalbRyklGjVPOQ6KCrLm0a/3azCbnpQ/sxpnMjw45JfkxCuvue/Di6V0jJf18i5syMdNS6TThvFRcfV2RDYCUL0k7XKSBmNaRTvJSca18d+AcIDOLtUocLv0lmkDaU5uFG3vA/hpokmBFiiMvFHeW3bsg/MJEWwzbcNZiibrrVhd73t61wJV88OGG0yHF3BdyLzVhqakXDEk/xIeqSM6wALnVt+rFmdwOoEYJDE7sOseBFQS/YvbMPBsISZ/7t04OlVq9wbNz3H+utm+8xwruDm3tGcV/F3K953O3tQ0iMeOWVUf9YqUECTiUOMgMq26tpSorfTavDqQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vg94QbL673h3WoKmxoKoqsJ4QP+i8Jm/CKFhTKcWEIk=;
 b=NS71HM7ZpuPF09KKGeKtrqpCH9/jaJz90FWu19UCxikp8X47C8PEdhddtQQECP/szAnxWlzNSWWAquSQV0L1AoP6sZyJcFpRMNsjAAbBBLjiE4Opg8bslZWIsFdQC+YvYQaiHLRkhm931T8hAkDUokIcO39pti6/mGEi3twFiW1nUI933iCh+mUtzUSUD3agEDRlxW/VEDC3FQXFH/tLCkz6PNkoN2oRG5rhRvB14zC0zXwD0SsEbmp0PpjzNefaxTbXfGOH7Iz45g2mBt0C+uDSSHWe31HjEaYEC4CANVVqqXtRq46e0hfHd3qOHKK2zulhR+r0rd2YSKjfvZlanA==
Received: from DM5PR1401CA0008.namprd14.prod.outlook.com (2603:10b6:4:4a::18)
 by MN2PR12MB3182.namprd12.prod.outlook.com (2603:10b6:208:107::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 09:18:45 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4a:cafe::17) by DM5PR1401CA0008.outlook.office365.com
 (2603:10b6:4:4a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Mon, 12 Jul 2021 09:18:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 09:18:44 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 09:18:44 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Jul 2021 09:18:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/348] 5.4.132-rc1 review
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Message-ID: <f84c4ee2a4904f4b955fcc7f3c29df1d@HQMAIL101.nvidia.com>
Date:   Mon, 12 Jul 2021 09:18:43 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdf21cea-dbac-4044-d0d9-08d945160c72
X-MS-TrafficTypeDiagnostic: MN2PR12MB3182:
X-Microsoft-Antispam-PRVS: <MN2PR12MB31828AA029EC817EDC2B9700D9159@MN2PR12MB3182.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:353;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0tJHOw9ziBfB5Ry+fN+g6b83TH7z3wPd5GA/U1NySUzrusq3HCwypn26kiQuGsTVVD9AqvSW5Gk7kGnUpqzO9lGf4wg99XoJluoJnxHLdgCpoYZGIgL15e45Wlll/vMuK23o3r1ehDOd5R3fUrgF+rGwQ/40yYhysxWpRqvfTgalTFDkQjuriQJ8Byjl5/gD0AS8C+ISLdD3lMRRs6e4VeWDl2bp/dE/GEe/lC54E4Yb7d6kaZYNknIolL+PZ8KjbqoQg5Re5s4lUEeCwOD7mu0nQQpZEgmbHketsVCDCyIM8LgfR3B/gOeu4haZcvsGtboUm7fo7dRBdp2geN+C8aCU0p4i3gmjDsf5jcsRaNecTy4v+a92+Mpsw+WHOp0wcJkx6vrDsNyE640DxnNLBLQ+dymQNpopK6dv0KV2NPapTtmoU1YnKGtoxBMmvR2d3m3sc+azPY2AUek8/kxbab4GfnxbBmvEptZBNXXQiYxduYNGvF9BT6SvwmGTgMvh6Tef8JEFWau1OB++3EvpnOQ8VAfDIf4YkxsXwUN3r9HqNBkH1H52beui/pWxV/BAWMKX4H+hx3I4iaDurZ1lwT1/3q0+7lbqZ4jzbXmQ9CYMBOa2IqFx593Oqhvj9jCtKtCDBE2an2Te8UtC7JOI42XluXo2BfLK6iNygD4jTJrbkrP/M1birF/dCPlfVZoWf6WmyK2FPi3fhgFB6rcYSFOpDUVF/AZO57qXuAsss9LJZRq9QtbeD8MhOM6oL1U6YHvc4QLPe8pe3H+nK79uE6vwjdGO0X2Md7RScdg6pdHJab26NhR8i/eo2cRBHI5F
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(36840700001)(46966006)(83380400001)(70206006)(82310400003)(336012)(47076005)(316002)(6916009)(36860700001)(82740400003)(36906005)(34020700004)(70586007)(4326008)(2906002)(54906003)(86362001)(966005)(7416002)(7636003)(5660300002)(66574015)(186003)(26005)(30864003)(45080400002)(24736004)(478600001)(108616005)(426003)(356005)(8676002)(8936002)(559001)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 09:18:44.8505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf21cea-dbac-4044-d0d9-08d945160c72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3182
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 08:06:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 348 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.132-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git l=
inux-5.4.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.4.132-rc1
>=20
> Quat Le <quat.le@oracle.com>
>     scsi: core: Retry I/O for Notify (Enable Spinup) Required error
>=20
> Johan Hovold <johan@kernel.org>
>     mmc: vub3000: fix control-request direction
>=20
> Bean Huo <beanhuo@micron.com>
>     mmc: block: Disable CMDQ on the ioctl path
>=20
> Long Li <longli@microsoft.com>
>     block: return the correct bvec when checking for gaps
>=20
> Varun Prakash <varun@chelsio.com>
>     scsi: target: cxgbit: Unmap DMA buffer before calling target_execute_cm=
d()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf llvm: Return -ENOMEM when asprintf() fails
>=20
> Dave Hansen <dave.hansen@linux.intel.com>
>     selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really r=
andom
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
>=20
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/huge_memory.c: don't discard hugepage if other processes are mapping=
 it
>=20
> Alex Williamson <alex.williamson@redhat.com>
>     vfio/pci: Handle concurrent vma faults
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     arm64: dts: marvell: armada-37xx: Fix reg for standard variant of UART
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     serial: mvebu-uart: correctly calculate minimal possible baudrate
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     serial: mvebu-uart: do not allow changing baudrate when uartclk is not =
available
>=20
> Nicholas Piggin <npiggin@gmail.com>
>     powerpc: Offline CPU in stop_this_cpu()
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     leds: ktd2692: Fix an error handling path
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     leds: as3645a: Fix error return code in as3645a_parse_node()
>=20
> Chung-Chiang Cheng <shepjeng@gmail.com>
>     configfs: fix memleak in configfs_release_bin_file
>=20
> Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
>     ASoC: atmel-i2s: Fix usage of capture and playback at the same time
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     extcon: max8997: Add missing modalias string
>=20
> Stephan Gerhold <stephan@gerhold.net>
>     extcon: sm5502: Drop invalid register write in sm5502_reg_data
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     phy: ti: dm816x: Fix the error handling path in 'dm816x_usb_phy_probe()
>=20
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>     phy: uniphier-pcie: Fix updating phy parameters
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     soundwire: stream: Fix test for DP prepare complete
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     scsi: mpt3sas: Fix error return value in _scsih_expander_add()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     mtd: rawnand: marvell: add missing clk_disable_unprepare() on error in =
marvell_nfc_resume()
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     of: Fix truncation of memory sizes on 32-bit platforms
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs42l42: Correct definition of CS42L42_ADC_PDN_MASK
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: prox: isl29501: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     serial: 8250: Actually allow UPF_MAGIC_MULTIPLIER baud rates
>=20
> Sergio Paracuellos <sergio.paracuellos@gmail.com>
>     staging: mt7621-dts: fix pci address for PCI memory range
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     staging: rtl8712: fix memory leak in rtl871x_load_fw_cb
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     staging: rtl8712: remove redundant check in r871xu_drv_init
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     staging: gdm724x: check for overflow in gdm_lte_netif_rx()
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     staging: gdm724x: check for buffer overflow in gdm_lte_multi_sdu_pkt()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: magn: rm3100: Fix alignment of buffer in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_wi=
th_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: mxs-lradc: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: hx711: Fix buffer alignment in iio_push_to_buffers_with_times=
tamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: at91-sama5d2: Fix buffer alignment in iio_push_to_buffers_wit=
h_timestamp()
>=20
> Alexandru Ardelean <alexandru.ardelean@analog.com>
>     iio: at91-sama5d2_adc: remove usage of iio_priv_to_dev() helper
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     eeprom: idt_89hpesx: Restore printing the unsupported fwnode name
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     eeprom: idt_89hpesx: Put fwnode in matching case during ->probe()
>=20
> Cl=C3=A9ment Lassieur <clement@lassieur.org>
>     usb: dwc2: Don't reset the core after setting turnaround time
>=20
> Andrew Gabbasov <andrew_gabbasov@mentor.com>
>     usb: gadget: f_fs: Fix setting of device and driver data cross-referenc=
es
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     ASoC: mediatek: mtk-btcvsd: Fix an error handling path in 'mtk_btcvsd_s=
nd_probe()'
>=20
> Srinath Mannam <srinath.mannam@broadcom.com>
>     iommu/dma: Fix IOVA reserve dma ranges
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     s390: appldata depends on PROC_SYSCTL
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     visorbus: fix error return code in visorchipset_init()
>=20
> Joachim Fenkes <FENKES@de.ibm.com>
>     fsi/sbefifo: Fix reset timeout
>=20
> Joachim Fenkes <FENKES@de.ibm.com>
>     fsi/sbefifo: Clean up correct FIFO when receiving reset request from SBE
>=20
> Eddie James <eajames@linux.ibm.com>
>     fsi: occ: Don't accept response from un-initialized OCC
>=20
> Eddie James <eajames@linux.ibm.com>
>     fsi: scom: Reset the FSI2PIB engine for any error
>=20
> Colin Ian King <colin.king@canonical.com>
>     fsi: core: Fix return of error values on failures
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     scsi: FlashPoint: Rename si_flags field
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     leds: lm3692x: Put fwnode in any case during ->probe()
>=20
> Marek Beh=C3=BAn <marek.behun@nic.cz>
>     leds: lm36274: cosmetic: rename lm36274_data to chip
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     leds: lm3532: select regmap I2C API
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     tty: nozomi: Fix the error handling path of 'nozomi_card_init()'
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     firmware: stratix10-svc: Fix a resource leak in an error handling path
>=20
> Yu Kuai <yukuai3@huawei.com>
>     char: pcmcia: error out if 'num_bytes_read' is greater than 4 in set_pr=
otocol()
>=20
> Corentin Labbe <clabbe@baylibre.com>
>     mtd: partitions: redboot: seek fis-index-block in the right node
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     Input: hil_kbd - fix error return code in hil_dev_connect()
>=20
> Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>     ASoC: rsnd: tidyup loop on rsnd_adg_clk_query()
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     backlight: lm3630a_bl: Put fwnode in error case during ->probe()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ASoC: hisilicon: fix missing clk_disable_unprepare() on error in hi6210=
_i2s_startup()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ASoC: rk3328: fix missing clk_disable_unprepare() on error in rk3328_pl=
atform_probe()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buf=
fers_with_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: cros_ec_sensors: Fix alignment of buffer in iio_push_to_buffers_wi=
th_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: light: tcs3472: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: light: tcs3414: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: light: isl29125: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: magn: bmc150: Fix buffer alignment in iio_push_to_buffers_with_tim=
estamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: magn: hmc5843: Fix buffer alignment in iio_push_to_buffers_with_ti=
mestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: prox: as3935: Fix buffer alignment in iio_push_to_buffers_with_tim=
estamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: prox: pulsed-light: Fix buffer alignment in iio_push_to_buffers_wi=
th_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: prox: srf08: Fix buffer alignment in iio_push_to_buffers_with_time=
stamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: humidity: am2315: Fix buffer alignment in iio_push_to_buffers_with=
_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: gyro: bmg160: Fix buffer alignment in iio_push_to_buffers_with_tim=
estamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: vf610: Fix buffer alignment in iio_push_to_buffers_with_times=
tamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: adc: ti-ads1015: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: stk8ba50: Fix buffer alignment in iio_push_to_buffers_with_=
timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: stk8312: Fix buffer alignment in iio_push_to_buffers_with_t=
imestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: mxc4005: Fix overread of data and alignment issue.
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:accel:mxc4005: Drop unnecessary explicit casts in regmap_bulk_read =
calls
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: kxcjk-1013: Fix buffer alignment in iio_push_to_buffers_wit=
h_timestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: hid: Fix buffer alignment in iio_push_to_buffers_with_times=
tamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_ti=
mestamp()
>=20
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: bma180: Fix buffer alignment in iio_push_to_buffers_with_ti=
mestamp()
>=20
> Nuno Sa <nuno.sa@analog.com>
>     iio: adis16400: do not return ints in irq handlers
>=20
> Nuno Sa <nuno.sa@analog.com>
>     iio: adis_buffer: do not return ints in irq handlers
>=20
> Arnd Bergmann <arnd@arndb.de>
>     mwifiex: re-fix for unaligned accesses
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     tty: nozomi: Fix a resource leak in an error handling function
>=20
> Paul E. McKenney <paulmck@kernel.org>
>     rcu: Invoke rcu_spawn_core_kthreads() from rcu_spawn_gp_kthread()
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     staging: fbtft: Rectify GPIO handling
>=20
> Wei Li <liwei391@huawei.com>
>     MIPS: Fix PKMAP with 32-bit MIPS huge page support
>=20
> Leon Romanovsky <leonro@nvidia.com>
>     RDMA/mlx5: Don't access NULL-cleared mpi pointer
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: sched: fix warning in tcindex_alloc_perfect_hash
>=20
> Vadim Fedorenko <vfedorenko@novek.ru>
>     net: lwtunnel: handle MTU calculation in forwading
>=20
> Muchun Song <songmuchun@bytedance.com>
>     writeback: fix obtain a reference to a freeing memcg css
>=20
> Robert Hancock <robert.hancock@calian.com>
>     clk: si5341: Update initialization magic
>=20
> Robert Hancock <robert.hancock@calian.com>
>     clk: si5341: Avoid divide errors due to bogus register contents
>=20
> Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
>     clk: actions: Fix bisp_factor_table based clocks on Owl S500 SoC
>=20
> Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
>     clk: actions: Fix SD clocks factor table on Owl S500 SoC
>=20
> Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
>     clk: actions: Fix UART clock dividers on Owl S500 SoC
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: Fix handling of HCI_LE_Advertising_Set_Terminated event
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid
>=20
> Petr Oros <poros@redhat.com>
>     Revert "be2net: disable bh with spin_lock in be_process_mcc"
>=20
> Bailey Forrest <bcf@google.com>
>     gve: Fix swapped vars when fetching max queues
>=20
> Gary Lin <glin@suse.com>
>     bpfilter: Specify the log level for the kmsg message
>=20
> Sasha Neftin <sasha.neftin@intel.com>
>     e1000e: Check the PCIm state
>=20
> Eric Dumazet <edumazet@google.com>
>     ipv6: fix out-of-bound access in ip6_parse_tlv()
>=20
> Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>     ibmvnic: free tx_pool if tso_pool alloc fails
>=20
> Dany Madden <drt@linux.ibm.com>
>     Revert "ibmvnic: remove duplicate napi_schedule call in open function"
>=20
> Mateusz Palczewski <mateusz.palczewski@intel.com>
>     i40e: Fix autoneg disabling for non-10GBaseT links
>=20
> Dinghao Liu <dinghao.liu@zju.edu.cn>
>     i40e: Fix error handling in i40e_vsi_open
>=20
> Maciej =C5=BBenczykowski <maze@google.com>
>     bpf: Do not change gso_size during bpf_skb_change_proto()
>=20
> Eric Dumazet <edumazet@google.com>
>     ipv6: exthdrs: do not blindly use init_net
>=20
> Jian-Hong Pan <jhp@endlessos.org>
>     net: bcmgenet: Fix attaching to PYH failed on RPi 4B
>=20
> Ping-Ke Shih <pkshih@realtek.com>
>     mac80211: remove iwlwifi specific workaround NDPs of null_response
>=20
> Eric Dumazet <edumazet@google.com>
>     ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()
>=20
> Dongliang Mu <mudongliangabcd@gmail.com>
>     ieee802154: hwsim: Fix memory leak in hwsim_add_one
>=20
> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>     tc-testing: fix list handling
>=20
> Miao Wang <shankerwangmiao@gmail.com>
>     net/ipv4: swap flow ports when validating source
>=20
> Eric Dumazet <edumazet@google.com>
>     vxlan: add missing rcu_read_lock() in neigh_reduce()
>=20
> Eric Dumazet <edumazet@google.com>
>     pkt_sched: sch_qfq: fix qfq_change_class() error path
>=20
> Jakub Kicinski <kuba@kernel.org>
>     tls: prevent oversized sendfile() hangs by ignoring MSG_MORE
>=20
> Yunsheng Lin <linyunsheng@huawei.com>
>     net: sched: add barrier to ensure correct ordering for lockless qdisc
>=20
> Antoine Tenart <atenart@kernel.org>
>     vrf: do not push non-ND strict packets with a source LLA through packet=
 taps again
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: ethernet: ezchip: fix error handling
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: ethernet: ezchip: fix UAF in nps_enet_remove
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: ethernet: aeroflex: fix UAF in greth_of_remove
>=20
> Wang Hai <wanghai38@huawei.com>
>     samples/bpf: Fix the error return code of xdp_redirect's main()
>=20
> Bob Pearson <rpearsonhpe@gmail.com>
>     RDMA/rxe: Fix qp reference counting for atomic ops
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_tproxy: restrict support to TCP and UDP transport protoc=
ols
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_osf: check for TCP packet before further processing
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_exthdr: check for IPv6 packet before further processing
>=20
> Leon Romanovsky <leonro@nvidia.com>
>     RDMA/mlx5: Don't add slave port to unaffiliated list
>=20
> Liu Shixin <liushixin2@huawei.com>
>     netlabel: Fix memory leak in netlbl_mgmt_add_common
>=20
> Yang Li <yang.lee@linux.alibaba.com>
>     ath10k: Fix an error code in ath10k_add_interface()
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     brcmsmac: mac80211_if: Fix a resource leak in an error handling path
>=20
> Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk>
>     brcmfmac: correctly report average RSSI in station info
>=20
> Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk>
>     brcmfmac: fix setting of station info chains bitmask
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     ssb: Fix error return code in ssb_bus_scan()
>=20
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>     wcn36xx: Move hal_buf allocation to devm_kmalloc in probe
>=20
> Dongliang Mu <mudongliangabcd@gmail.com>
>     ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_othe=
rs
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     wireless: carl9170: fix LEDS build errors & warnings
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ath10k: add missing error return code in ath10k_pci_probe()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ath10k: go to path err_unsupported when chip id is not supported
>=20
> Zhihao Cheng <chengzhihao1@huawei.com>
>     tools/bpftool: Fix error return code in do_batch()
>=20
> Colin Ian King <colin.king@canonical.com>
>     drm: qxl: ensure surf.data is ininitialized
>=20
> Kamal Heib <kamalheib1@gmail.com>
>     RDMA/rxe: Fix failure during driver load
>=20
> Leon Romanovsky <leonro@nvidia.com>
>     RDMA/core: Sanitize WQ state received from the userspace
>=20
> Boris Sukholitko <boris.sukholitko@broadcom.com>
>     net/sched: act_vlan: Fix modify to allow 0
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     ehea: fix error return code in ehea_restart_qps()
>=20
> Thomas Hebb <tommyhebb@gmail.com>
>     drm/rockchip: dsi: move all lane config except LCDC mux to bind()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     drm/rockchip: cdn-dp-core: add missing clk_disable_unprepare() on error=
 in cdn_dp_grf_write()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     net: ftgmac100: add missing error return code in ftgmac100_probe()
>=20
> Jerome Brunet <jbrunet@baylibre.com>
>     clk: meson: g12a: fix gp0 and hifi ranges
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     pinctrl: renesas: r8a77990: JTAG pins do not have pull-down capabilities
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     pinctrl: renesas: r8a7796: Add missing bias for PRESET# pin
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     net: pch_gbe: Propagate error from devm_gpio_request_one()
>=20
> Andy Shevchenko <andy.shevchenko@gmail.com>
>     net: mvpp2: Put fwnode in error case during ->probe()
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     video: fbdev: imxfb: Fix an error message
>=20
> Sabrina Dubroca <sd@queasysnail.net>
>     xfrm: xfrm_state_mtu should return at least 1280 for ipv6
>=20
> Jan Kara <jack@suse.cz>
>     dax: fix ENOMEM handling in grab_mapping_entry()
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     ocfs2: fix snprintf() checking
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: Make cpufreq_online() call driver->offline() on errors
>=20
> Nathan Chancellor <nathan@kernel.org>
>     ACPI: bgrt: Fix CFI violation
>=20
> Dwaipayan Ray <dwaipayanray1@gmail.com>
>     ACPI: Use DEVICE_ATTR_<RW|RO|WO> macros
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     blk-wbt: make sure throttle is enabled properly
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     blk-wbt: introduce a new disable state to prevent false positive by rwb=
_enabled()
>=20
> Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
>     extcon: extcon-max8997: Fix IRQ freeing at error path
>=20
> Krzysztof Wilczy=C5=84ski <kw@linux.com>
>     ACPI: sysfs: Fix a buffer overrun problem with description_show()
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: nx - Fix RCU warning in nx842_OF_upd_status
>=20
> Mirko Vogt <mirko-dev|linux@nanl.de>
>     spi: spi-sun6i: Fix chipselect/clock bug
>=20
> Qais Yousef <qais.yousef@arm.com>
>     sched/uclamp: Fix uclamp_tg_restrict()
>=20
> Vincent Donnefort <vincent.donnefort@arm.com>
>     sched/rt: Fix Deadline utilization tracking during policy change
>=20
> Vincent Donnefort <vincent.donnefort@arm.com>
>     sched/rt: Fix RT utilization tracking during policy change
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: clear log tree recovering status if starting transaction fails
>=20
> Axel Lin <axel.lin@ingics.com>
>     regulator: hi655x: Fix pass wrong pointer to config.driver_data
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: nVMX: Ensure 64-bit shift when checking VMFUNC bitmap
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (max31790) Fix fan speed reporting for fan7..12
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (max31722) Remove non-standard ACPI device IDs
>=20
> Dillon Min <dillon.minfei@gmail.com>
>     media: s5p-g2d: Fix a memory leak on ctx->fh.m2m_ctx
>=20
> Anshuman Khandual <anshuman.khandual@arm.com>
>     arm64/mm: Fix ttbr0 values stored in struct thread_info for software-pan
>=20
> Mark Rutland <mark.rutland@arm.com>
>     arm64: consistently use reserved_pg_dir
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     mmc: usdhi6rol0: fix error return code in usdhi6_probe()
>=20
> Zhang Qilong <zhangqilong3@huawei.com>
>     crypto: omap-sham - Fix PM reference leak in omap sham ops
>=20
> Tong Tiangen <tongtiangen@huawei.com>
>     crypto: nitrox - fix unchecked variable in nitrox_register_interrupts
>=20
> Gustavo A. R. Silva <gustavoars@kernel.org>
>     media: siano: Fix out-of-bounds warnings in smscore_load_firmware_famil=
y2()
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     m68k: atari: Fix ATARI_KBD_CORE kconfig unmet dependency warning
>=20
> Johan Hovold <johan@kernel.org>
>     media: gspca/gl860: fix zero-length control requests
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     media: tc358743: Fix error return code in tc358743_probe_of()
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     media: au0828: fix a NULL vs IS_ERR() check
>=20
> Lv Yunlong <lyl2019@mail.ustc.edu.cn>
>     media: exynos4-is: Fix a use after free in isp_video_release
>=20
> Sergey Shtylyov <s.shtylyov@omprussia.ru>
>     pata_ep93xx: fix deferred probing
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     media: rc: i2c: Fix an error message
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     crypto: ccp - Fix a resource leak in an error handling path
>=20
> Mimi Zohar <zohar@linux.ibm.com>
>     evm: fix writing <securityfs>/evm overflow
>=20
> Sergey Shtylyov <s.shtylyov@omp.ru>
>     pata_octeon_cf: avoid WARN_ON() in ata_host_activate()
>=20
> Josh Poimboeuf <jpoimboe@redhat.com>
>     kbuild: Fix objtool dependency for 'OBJECT_FILES_NON_STANDARD_<obj> :=
=3D n'
>=20
> Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
>     kbuild: run the checker after the compiler
>=20
> Qais Yousef <qais.yousef@arm.com>
>     sched/uclamp: Fix locking around cpu_util_update_eff()
>=20
> Qais Yousef <qais.yousef@arm.com>
>     sched/uclamp: Fix wrong implementation of cpu.uclamp.min
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     media: I2C: change 'RST' to "RSET" to fix multiple build errors
>=20
> Sergey Shtylyov <s.shtylyov@omprussia.ru>
>     pata_rb532_cf: fix deferred probing
>=20
> Sergey Shtylyov <s.shtylyov@omprussia.ru>
>     sata_highbank: fix deferred probing
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>     crypto: ux500 - Fix error return code in hash_hw_final()
>=20
> Corentin Labbe <clabbe@baylibre.com>
>     crypto: ixp4xx - dma_unmap the correct address
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: s5p_cec: decrement usage count if disabled
>=20
> Roman Gushchin <guro@fb.com>
>     writeback, cgroup: increment isw_nr_in_flight before grabbing an inode
>=20
> Arnd Bergmann <arnd@arndb.de>
>     ia64: mca_drv: fix incorrect array size calculation
>=20
> Petr Mladek <pmladek@suse.com>
>     kthread_worker: fix return value when kthread_mod_delayed_work() races =
with kthread_cancel_delayed_work_sync()
>=20
> Ming Lei <ming.lei@redhat.com>
>     block: fix discard request merge
>=20
> Steve French <stfrench@microsoft.com>
>     cifs: fix missing spinlock around update to ses->status
>=20
> Jason Gerecke <killertofu@gmail.com>
>     HID: wacom: Correct base usage for capacitive ExpressKey status bits
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ACPI: tables: Add custom DSDT file as makefile prerequisite
>=20
> Paul E. McKenney <paulmck@kernel.org>
>     clocksource: Retry clock read if long delays detected
>=20
> Haiyang Zhang <haiyangz@microsoft.com>
>     PCI: hv: Add check for hyperv_initialized in init_hv_pci_drv()
>=20
> Tony Luck <tony.luck@intel.com>
>     EDAC/Intel: Do not load EDAC driver when running as a guest
>=20
> Hannes Reinecke <hare@suse.de>
>     nvmet-fc: do not check for invalid target port in nvmet_fc_handle_fcp_r=
qst()
>=20
> Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>     platform/x86: toshiba_acpi: Fix missing error code in toshiba_acpi_setu=
p_keyboard()
>=20
> Ming Lei <ming.lei@redhat.com>
>     block: fix race between adding/removing rq qos and normal IO
>=20
> Hui Wang <hui.wang@canonical.com>
>     ACPI: resources: Add checks for ACPI IRQ override
>=20
> Hanjun Guo <guohanjun@huawei.com>
>     ACPI: bus: Call kobject_put() in acpi_init() error path
>=20
> Erik Kaneda <erik.kaneda@intel.com>
>     ACPICA: Fix memory leak caused by _CID repair function
>=20
> Alexander Aring <aahringo@redhat.com>
>     fs: dlm: fix memory leak when fenced
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     random32: Fix implicit truncation warning in prandom_seed_state()
>=20
> Alexander Aring <aahringo@redhat.com>
>     fs: dlm: cancel work sync othercon
>=20
> zhangyi (F) <yi.zhang@huawei.com>
>     block_dump: remove block_dump feature in mark_inode_dirty()
>=20
> Chris Chiu <chris.chiu@canonical.com>
>     ACPI: EC: Make more Asus laptops use ECDT _GPE
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     lib: vsprintf: Fix handling of number field widths in vsscanf
>=20
> YueHaibing <yuehaibing@huawei.com>
>     hv_utils: Fix passing zero to 'PTR_ERR' warning
>=20
> Mario Limonciello <mario.limonciello@amd.com>
>     ACPI: processor idle: Fix up C-state latency if not ordered
>=20
> Bixuan Cui <cuibixuan@huawei.com>
>     EDAC/ti: Add missing MODULE_DEVICE_TABLE
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     HID: do not use down_interruptible() when unbinding devices
>=20
> Shuah Khan <skhan@linuxfoundation.org>
>     media: Fix Media Controller API config checks
>=20
> Axel Lin <axel.lin@ingics.com>
>     regulator: da9052: Ensure enough delay time for .set_voltage_time_sel
>=20
> Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>
>     regulator: mt6358: Fix vdram2 .vsel_mask
>=20
> Heiko Carstens <hca@linux.ibm.com>
>     KVM: s390: get rid of register asm usage
>=20
> Boqun Feng <boqun.feng@gmail.com>
>     lockding/lockdep: Avoid to find wrong lock dep path in check_irq_usage()
>=20
> Boqun Feng <boqun.feng@gmail.com>
>     locking/lockdep: Fix the dep path printing for backwards BFS
>=20
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     btrfs: disable build on platforms having page size 256K
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: abort transaction if we fail to update the delayed inode
>=20
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: fix error handling in __btrfs_update_delayed_inode
>=20
> Suraj Jitindar Singh <sjitindarsingh@gmail.com>
>     KVM: PPC: Book3S HV: Fix TLB management on SMT8 POWER9 and POWER10 proc=
essors
>=20
> Jing Xiangfeng <jingxiangfeng@huawei.com>
>     drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (max31790) Fix pwmX_enable attributes
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (max31790) Report correct current pwm duty cycles
>=20
> Steve Longerbeam <slongerbeam@gmail.com>
>     media: imx-csi: Skip first few frames from a BT.656 source
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: siano: fix device register error path
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: dvb_net: avoid speculation from net slot
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     crypto: shash - avoid comparing pointers to exported functions under CFI
>=20
> Zheyu Ma <zheyuma97@gmail.com>
>     mmc: via-sdmmc: add a check against NULL pointer dereference
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>     mmc: sdhci-sprd: use sdhci_sprd_writew
>=20
> Tong Zhang <ztong0001@gmail.com>
>     memstick: rtsx_usb_ms: fix UAF
>=20
> Dongliang Mu <mudongliangabcd@gmail.com>
>     media: dvd_usb: memory leak in cinergyt2_fe_attach
>=20
> Nick Desaulniers <ndesaulniers@google.com>
>     Makefile: fix GDB warning with CONFIG_RELR
>=20
> Evgeny Novikov <novikov@ispras.ru>
>     media: st-hva: Fix potential NULL pointer dereferences
>=20
> Zheyu Ma <zheyuma97@gmail.com>
>     media: bt8xx: Fix a missing check bug in bt878_probe
>=20
> Lv Yunlong <lyl2019@mail.ustc.edu.cn>
>     media: v4l2-core: Avoid the dangling pointer in v4l2_fh_release
>=20
> Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
>     media: em28xx: Fix possible memory leak of em28xx struct
>=20
> Odin Ugedal <odin@uged.al>
>     sched/fair: Fix ascii art by relpacing tabs
>=20
> Jack Xu <jack.xu@intel.com>
>     crypto: qat - remove unused macro in FW loader
>=20
> Jack Xu <jack.xu@intel.com>
>     crypto: qat - check return code of qat_hal_rd_rel_reg()
>=20
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     media: imx: imx7_mipi_csis: Fix logging of only error event counters
>=20
> Anirudh Rayabharam <mail@anirudhrb.com>
>     media: pvrusb2: fix warning in pvr2_i2c_core_done
>=20
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: cobalt: fix race condition in setting HPD
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     media: cpia2: fix memory leak in cpia2_usb_probe
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: sti: fix obj-$(config) targets
>=20
> Bixuan Cui <cuibixuan@huawei.com>
>     crypto: nx - add missing MODULE_DEVICE_TABLE
>=20
> =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>     hwrng: exynos - Fix runtime PM imbalance on error
>=20
> Zou Wei <zou_wei@huawei.com>
>     regulator: uniphier: Add missing MODULE_DEVICE_TABLE
>=20
> Tian Tao <tiantao6@hisilicon.com>
>     spi: omap-100k: Fix the length judgment problem
>=20
> Jay Fang <f.fangjian@huawei.com>
>     spi: spi-topcliff-pch: Fix potential double free in pch_spi_process_mes=
sages()
>=20
> Jay Fang <f.fangjian@huawei.com>
>     spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: exynos-gsc: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: sti/bdisp: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: s5p-jpeg: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: mtk-vcodec: fix PM runtime get logic
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: sh_vou: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: s5p: fix pm_runtime_get_sync() usage count
>=20
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>     media: mdk-mdp: fix pm_runtime_get_sync() usage count
>=20
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     spi: Make of_register_spi_device also set the fwnode
>=20
> Miklos Szeredi <mszeredi@redhat.com>
>     fuse: reject internal errno
>=20
> Miklos Szeredi <mszeredi@redhat.com>
>     fuse: check connected before queueing on fpq->io
>=20
> Miklos Szeredi <mszeredi@redhat.com>
>     fuse: ignore PG_workingset after stealing
>=20
> Roberto Sassu <roberto.sassu@huawei.com>
>     evm: Refuse EVM_ALLOW_METADATA_WRITES only if an HMAC key is loaded
>=20
> Roberto Sassu <roberto.sassu@huawei.com>
>     evm: Execute evm_inode_init_security() only when an HMAC key is loaded
>=20
> Michael Ellerman <mpe@ellerman.id.au>
>     powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()
>=20
> Yun Zhou <yun.zhou@windriver.com>
>     seq_buf: Make trace_seq_putmem_hex() support data longer than 8
>=20
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>     tracepoint: Add tracepoint_probe_register_may_exist() for BPF tracing
>=20
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>     tracing/histograms: Fix parsing of "sym-offset" modifier
>=20
> Martin Fuzzey <martin.fuzzey@flowbird.group>
>     rsi: fix AP mode with WPA failure due to encrypted EAPOL
>=20
> Marek Vasut <marex@denx.de>
>     rsi: Assign beacon rate settings to the correct rate_info descriptor fi=
eld
>=20
> Michael Buesch <m@bues.ch>
>     ssb: sdio: Don't overwrite const buffer if block_write fails
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()
>=20
> Ondrej Zary <linux@zary.sk>
>     serial_cs: remove wrong GLOBETROTTER.cis entry
>=20
> Ondrej Zary <linux@zary.sk>
>     serial_cs: Add Option International GSM-Ready 56K/ISDN modem
>=20
> Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>     serial: sh-sci: Stop dmaengine transfer in sci_stop_tx()
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     serial: mvebu-uart: fix calculation of clock divisor
>=20
> Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
>     iio: ltr501: ltr501_read_ps(): add missing endianness conversion
>=20
> Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
>     iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR
>=20
> Marc Kleine-Budde <mkl@pengutronix.de>
>     iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and PS=
_DATA as volatile, too
>=20
> frank zago <frank@zago.net>
>     iio: light: tcs3472: do not free unallocated IRQ
>=20
> Martin Fuzzey <martin.fuzzey@flowbird.group>
>     rtc: stm32: Fix unbalanced clk_disable_unprepare() on probe error path
>=20
> Vineeth Vijayan <vneethv@linux.ibm.com>
>     s390/cio: dont call css_wait_for_slow_path() inside a lock
>=20
> Nathan Chancellor <nathan@kernel.org>
>     KVM: PPC: Book3S HV: Workaround high stack usage with clang
>=20
> Robin Murphy <robin.murphy@arm.com>
>     perf/smmuv3: Don't trample existing events with global filter
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>     SUNRPC: Should wake up the privileged task firstly.
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>     SUNRPC: Fix the batch tasks count wraparound.
>=20
> Felix Fietkau <nbd@nbd.name>
>     mac80211: remove iwlwifi specific workaround that broke sta NDP tx
>=20
> Stephane Grosjean <s.grosjean@peak-system.com>
>     can: peak_pciefd: pucan_handle_status(): fix a potential starvation iss=
ue in TX path
>=20
> Oleksij Rempel <linux@rempel-privat.de>
>     can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() af=
ter RCU is done
>=20
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: gw: synchronize rcu operations before removing gw job entry
>=20
> Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>     can: bcm: delay release of struct bcm_op after synchronize_rcu()
>=20
> Stephen Brennan <stephen.s.brennan@oracle.com>
>     ext4: use ext4_grp_locked_error in mb_find_extent
>=20
> Pan Dong <pandong.peter@bytedance.com>
>     ext4: fix avefreec in find_group_orlov
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     ext4: remove check for zero nr_to_scan in ext4_es_scan()
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     ext4: correct the cache_nr in tracepoint ext4_es_shrink_exit
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     ext4: return error code when ext4_fill_flex_info() fails
>=20
> Anirudh Rayabharam <mail@anirudhrb.com>
>     ext4: fix kernel infoleak via ext4_extent_header
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     ext4: cleanup in-core orphan list if ext4_truncate() failed to get a tr=
ansaction handle
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: clear defrag status of a root if starting transaction fails
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: send: fix invalid path for unlink operations after parent orphan=
ization
>=20
> Ludovic Desroches <ludovic.desroches@microchip.com>
>     ARM: dts: at91: sama5d4: fix pinctrl muxing
>=20
> Yang Jihong <yangjihong1@huawei.com>
>     arm_pmu: Fix write counter incorrect in ARMv7 big-endian mode
>=20
> Alexander Larkin <avlarkin82@gmail.com>
>     Input: joydev - prevent use of not validated data in JSIOCSBTNMAP ioctl
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     iov_iter_fault_in_readable() should do nothing in xarray case
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     copy_page_to_iter(): fix ITER_DISCARD case
>=20
> Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>     ntfs: fix validity check for file name attribute
>=20
> Zhangjiantao (Kirin, nanjing) <water.zhangjiantao@huawei.com>
>     xhci: solve a double free problem while doing s4
>=20
> Jing Xiangfeng <jingxiangfeng@huawei.com>
>     usb: typec: Add the missed altmode_id_remove() in typec_register_altmod=
e()
>=20
> Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
>     usb: dwc3: Fix debugfs creation flow
>=20
> Hannu Hartikainen <hannu@hrtk.in>
>     USB: cdc-acm: blacklist Heimann USB Appset device
>=20
> Linyu Yuan <linyyuan@codeaurora.com>
>     usb: gadget: eem: fix echo command packet response issue
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
>=20
> Johan Hovold <johan@kernel.org>
>     Input: usbtouchscreen - fix control-request directions
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     media: dvb-usb: fix wrong definition
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Apply LED fixup for HP Dragonfly G1, too
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Fix bass speaker DAC mapping for Asus UM431D
>=20
> Elia Devito <eliadevito@gmail.com>
>     ALSA: hda/realtek: Improve fixup for HP Spectre x360 15-df0xxx
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Add another ALC236 variant support
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: intel8x0: Fix breakage at ac97 clock measurement
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: scarlett2: Fix wrong resume call
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Fix OOB access at proc output
>=20
> Daehwan Jung <dh10.jung@samsung.com>
>     ALSA: usb-audio: fix rate on Ozone Z90 USB headset
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/ABI/testing/evm                      |  26 ++++-
>  Documentation/admin-guide/kernel-parameters.txt    |   6 ++
>  Documentation/hwmon/max31790.rst                   |   5 +-
>  Makefile                                           |   6 +-
>  arch/arm/boot/dts/sama5d4.dtsi                     |   2 +-
>  arch/arm/kernel/perf_event_v7.c                    |   4 +-
>  arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   2 +-
>  arch/arm64/include/asm/asm-uaccess.h               |   4 +-
>  arch/arm64/include/asm/kernel-pgtable.h            |   6 --
>  arch/arm64/include/asm/mmu_context.h               |   8 +-
>  arch/arm64/include/asm/pgtable.h                   |   1 +
>  arch/arm64/include/asm/uaccess.h                   |   4 +-
>  arch/arm64/kernel/entry.S                          |   6 +-
>  arch/arm64/kernel/setup.c                          |   2 +-
>  arch/arm64/kernel/vmlinux.lds.S                    |   8 +-
>  arch/arm64/mm/proc.S                               |   2 +-
>  arch/ia64/kernel/mca_drv.c                         |   2 +-
>  arch/m68k/Kconfig.machine                          |   3 +
>  arch/mips/include/asm/highmem.h                    |   2 +-
>  arch/powerpc/include/asm/cputhreads.h              |  30 ++++++
>  arch/powerpc/kernel/smp.c                          |  11 ++
>  arch/powerpc/kernel/stacktrace.c                   |  26 +++--
>  arch/powerpc/kvm/book3s_hv.c                       |  13 +--
>  arch/powerpc/kvm/book3s_hv_builtin.c               |   2 +-
>  arch/powerpc/kvm/book3s_hv_nested.c                |   3 +-
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c                |   2 +-
>  arch/s390/Kconfig                                  |   2 +-
>  arch/s390/kvm/kvm-s390.c                           |  18 ++--
>  arch/x86/kvm/vmx/nested.c                          |   2 +-
>  block/blk-merge.c                                  |   8 +-
>  block/blk-rq-qos.h                                 |  24 +++++
>  block/blk-wbt.c                                    |  11 +-
>  block/blk-wbt.h                                    |   1 +
>  crypto/shash.c                                     |  18 +++-
>  drivers/acpi/Makefile                              |   5 +
>  drivers/acpi/acpi_pad.c                            |  24 ++---
>  drivers/acpi/acpi_tad.c                            |  14 +--
>  drivers/acpi/acpica/nsrepair2.c                    |   7 ++
>  drivers/acpi/bgrt.c                                |  57 ++++------
>  drivers/acpi/bus.c                                 |   1 +
>  drivers/acpi/device_sysfs.c                        |  46 ++++----
>  drivers/acpi/dock.c                                |  26 ++---
>  drivers/acpi/ec.c                                  |  16 +++
>  drivers/acpi/power.c                               |   9 +-
>  drivers/acpi/processor_idle.c                      |  40 +++++++
>  drivers/acpi/resource.c                            |   9 +-
>  drivers/ata/pata_ep93xx.c                          |   2 +-
>  drivers/ata/pata_octeon_cf.c                       |   5 +-
>  drivers/ata/pata_rb532_cf.c                        |   6 +-
>  drivers/ata/sata_highbank.c                        |   6 +-
>  drivers/char/hw_random/exynos-trng.c               |   4 +-
>  drivers/char/pcmcia/cm4000_cs.c                    |   4 +
>  drivers/clk/actions/owl-s500.c                     |  62 ++++++-----
>  drivers/clk/clk-si5341.c                           |  19 +++-
>  drivers/clk/meson/g12a.c                           |   2 +-
>  drivers/cpufreq/cpufreq.c                          |  11 +-
>  drivers/crypto/cavium/nitrox/nitrox_isr.c          |   4 +
>  drivers/crypto/ccp/sp-pci.c                        |   6 +-
>  drivers/crypto/ixp4xx_crypto.c                     |   2 +-
>  drivers/crypto/nx/nx-842-pseries.c                 |   9 +-
>  drivers/crypto/omap-sham.c                         |   4 +-
>  drivers/crypto/qat/qat_common/qat_hal.c            |   6 +-
>  drivers/crypto/qat/qat_common/qat_uclo.c           |   1 -
>  drivers/crypto/ux500/hash/hash_core.c              |   1 +
>  drivers/edac/i10nm_base.c                          |   3 +
>  drivers/edac/pnd2_edac.c                           |   3 +
>  drivers/edac/sb_edac.c                             |   3 +
>  drivers/edac/skx_base.c                            |   3 +
>  drivers/edac/ti_edac.c                             |   1 +
>  drivers/extcon/extcon-max8997.c                    |   3 +-
>  drivers/extcon/extcon-sm5502.c                     |   1 -
>  drivers/firmware/stratix10-svc.c                   |  22 ++--
>  drivers/fsi/fsi-core.c                             |   4 +-
>  drivers/fsi/fsi-occ.c                              |   1 +
>  drivers/fsi/fsi-sbefifo.c                          |  10 +-
>  drivers/fsi/fsi-scom.c                             |  16 +--
>  drivers/gpu/drm/qxl/qxl_dumb.c                     |   2 +
>  drivers/gpu/drm/rockchip/cdn-dp-core.c             |   1 +
>  drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |  36 +++++--
>  drivers/hid/hid-core.c                             |  10 +-
>  drivers/hid/wacom_wac.h                            |   2 +-
>  drivers/hv/hv_util.c                               |   4 +-
>  drivers/hwmon/max31722.c                           |   9 --
>  drivers/hwmon/max31790.c                           |  49 +++++----
>  drivers/iio/accel/bma180.c                         |  10 +-
>  drivers/iio/accel/bma220_spi.c                     |  10 +-
>  drivers/iio/accel/hid-sensor-accel-3d.c            |  13 ++-
>  drivers/iio/accel/kxcjk-1013.c                     |  24 +++--
>  drivers/iio/accel/mxc4005.c                        |  12 ++-
>  drivers/iio/accel/stk8312.c                        |  12 ++-
>  drivers/iio/accel/stk8ba50.c                       |  17 ++-
>  drivers/iio/adc/at91-sama5d2_adc.c                 |  33 +++---
>  drivers/iio/adc/hx711.c                            |   4 +-
>  drivers/iio/adc/mxs-lradc-adc.c                    |   3 +-
>  drivers/iio/adc/ti-ads1015.c                       |  12 ++-
>  drivers/iio/adc/ti-ads8688.c                       |   3 +-
>  drivers/iio/adc/vf610_adc.c                        |  10 +-
>  drivers/iio/gyro/bmg160_core.c                     |  10 +-
>  drivers/iio/humidity/am2315.c                      |  16 +--
>  drivers/iio/imu/adis16400.c                        |   3 -
>  drivers/iio/imu/adis_buffer.c                      |   3 -
>  drivers/iio/light/isl29125.c                       |  10 +-
>  drivers/iio/light/ltr501.c                         |  15 ++-
>  drivers/iio/light/tcs3414.c                        |  10 +-
>  drivers/iio/light/tcs3472.c                        |  16 ++-
>  drivers/iio/light/vcnl4035.c                       |   3 +-
>  drivers/iio/magnetometer/bmc150_magn.c             |  11 +-
>  drivers/iio/magnetometer/hmc5843.h                 |   8 +-
>  drivers/iio/magnetometer/hmc5843_core.c            |   4 +-
>  drivers/iio/magnetometer/rm3100-core.c             |   3 +-
>  drivers/iio/potentiostat/lmp91000.c                |   4 +-
>  drivers/iio/proximity/as3935.c                     |  10 +-
>  drivers/iio/proximity/isl29501.c                   |   2 +-
>  drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |  10 +-
>  drivers/iio/proximity/srf08.c                      |  14 +--
>  drivers/infiniband/core/uverbs_cmd.c               |  21 +++-
>  drivers/infiniband/hw/mlx4/qp.c                    |   9 +-
>  drivers/infiniband/hw/mlx5/main.c                  |   4 +-
>  drivers/infiniband/hw/mlx5/qp.c                    |   6 +-
>  drivers/infiniband/sw/rxe/rxe_net.c                |  10 +-
>  drivers/infiniband/sw/rxe/rxe_qp.c                 |   1 -
>  drivers/infiniband/sw/rxe/rxe_resp.c               |   2 -
>  drivers/input/joydev.c                             |   2 +-
>  drivers/input/keyboard/Kconfig                     |   3 -
>  drivers/input/keyboard/hil_kbd.c                   |   1 +
>  drivers/input/touchscreen/usbtouchscreen.c         |   8 +-
>  drivers/iommu/dma-iommu.c                          |   6 +-
>  drivers/leds/Kconfig                               |   1 +
>  drivers/leds/leds-as3645a.c                        |   1 +
>  drivers/leds/leds-ktd2692.c                        |  27 +++--
>  drivers/leds/leds-lm36274.c                        |  82 +++++++-------
>  drivers/leds/leds-lm3692x.c                        |   8 +-
>  drivers/media/common/siano/smscoreapi.c            |  22 ++--
>  drivers/media/common/siano/smscoreapi.h            |   4 +-
>  drivers/media/common/siano/smsdvb-main.c           |   4 +
>  drivers/media/dvb-core/dvb_net.c                   |  25 +++--
>  drivers/media/i2c/ir-kbd-i2c.c                     |   4 +-
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   6 +-
>  drivers/media/i2c/s5c73m3/s5c73m3.h                |   2 +-
>  drivers/media/i2c/s5k4ecgx.c                       |  10 +-
>  drivers/media/i2c/s5k5baf.c                        |   6 +-
>  drivers/media/i2c/s5k6aa.c                         |  10 +-
>  drivers/media/i2c/tc358743.c                       |   1 +
>  drivers/media/mc/Makefile                          |   2 +-
>  drivers/media/pci/bt8xx/bt878.c                    |   3 +
>  drivers/media/pci/cobalt/cobalt-driver.c           |   1 +
>  drivers/media/pci/cobalt/cobalt-driver.h           |   7 +-
>  drivers/media/platform/exynos-gsc/gsc-m2m.c        |   4 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.c |   7 +-
>  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |   6 +-
>  .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |   4 +-
>  .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |   8 +-
>  .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h  |   2 +-
>  drivers/media/platform/s5p-cec/s5p_cec.c           |   7 +-
>  drivers/media/platform/s5p-g2d/g2d.c               |   3 +
>  drivers/media/platform/s5p-jpeg/jpeg-core.c        |   5 +-
>  drivers/media/platform/sh_vou.c                    |   6 +-
>  drivers/media/platform/sti/bdisp/Makefile          |   2 +-
>  drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   7 +-
>  drivers/media/platform/sti/delta/Makefile          |   2 +-
>  drivers/media/platform/sti/hva/Makefile            |   2 +-
>  drivers/media/platform/sti/hva/hva-hw.c            |   3 +-
>  drivers/media/usb/au0828/au0828-core.c             |   4 +-
>  drivers/media/usb/cpia2/cpia2.h                    |   1 +
>  drivers/media/usb/cpia2/cpia2_core.c               |  12 +++
>  drivers/media/usb/cpia2/cpia2_usb.c                |  13 +--
>  drivers/media/usb/dvb-usb/cinergyT2-core.c         |   2 +
>  drivers/media/usb/dvb-usb/cxusb.c                  |   2 +-
>  drivers/media/usb/em28xx/em28xx-input.c            |   8 +-
>  drivers/media/usb/gspca/gl860/gl860.c              |   4 +-
>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   4 +-
>  drivers/media/v4l2-core/v4l2-fh.c                  |   1 +
>  drivers/memstick/host/rtsx_usb_ms.c                |  10 +-
>  drivers/misc/eeprom/idt_89hpesx.c                  |   8 +-
>  drivers/mmc/core/block.c                           |   8 ++
>  drivers/mmc/host/sdhci-sprd.c                      |   1 +
>  drivers/mmc/host/usdhi6rol0.c                      |   1 +
>  drivers/mmc/host/via-sdmmc.c                       |   3 +
>  drivers/mmc/host/vub300.c                          |   2 +-
>  drivers/mtd/nand/raw/marvell_nand.c                |   4 +-
>  drivers/mtd/parsers/redboot.c                      |   7 +-
>  drivers/net/can/peak_canfd/peak_canfd.c            |   4 +-
>  drivers/net/can/usb/ems_usb.c                      |   3 +-
>  drivers/net/ethernet/aeroflex/greth.c              |   3 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   1 +
>  drivers/net/ethernet/emulex/benet/be_cmds.c        |   6 +-
>  drivers/net/ethernet/emulex/benet/be_main.c        |   2 +
>  drivers/net/ethernet/ezchip/nps_enet.c             |   4 +-
>  drivers/net/ethernet/faraday/ftgmac100.c           |   6 +-
>  drivers/net/ethernet/google/gve/gve_main.c         |   4 +-
>  drivers/net/ethernet/ibm/ehea/ehea_main.c          |   9 +-
>  drivers/net/ethernet/ibm/ibmvnic.c                 |  10 +-
>  drivers/net/ethernet/intel/e1000e/netdev.c         |  24 +++--
>  drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   3 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +
>  .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |  10 +-
>  drivers/net/ieee802154/mac802154_hwsim.c           |  11 +-
>  drivers/net/vrf.c                                  |  14 +--
>  drivers/net/vxlan.c                                |   2 +
>  drivers/net/wireless/ath/ath10k/mac.c              |   1 +
>  drivers/net/wireless/ath/ath10k/pci.c              |  14 ++-
>  drivers/net/wireless/ath/ath9k/main.c              |   5 +
>  drivers/net/wireless/ath/carl9170/Kconfig          |   8 +-
>  drivers/net/wireless/ath/wcn36xx/main.c            |  21 ++--
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  37 ++++---
>  .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   8 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +
>  drivers/net/wireless/marvell/mwifiex/pcie.c        |  10 +-
>  drivers/net/wireless/rsi/rsi_91x_hal.c             |   6 +-
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   3 -
>  drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   3 +-
>  drivers/net/wireless/rsi/rsi_main.h                |   1 -
>  drivers/nvme/target/fc.c                           |  10 +-
>  drivers/of/fdt.c                                   |   8 +-
>  drivers/of/of_reserved_mem.c                       |   8 +-
>  drivers/pci/controller/pci-hyperv.c                |   3 +
>  drivers/perf/arm_smmuv3_pmu.c                      |  18 ++--
>  drivers/perf/fsl_imx8_ddr_perf.c                   |   6 +-
>  drivers/phy/socionext/phy-uniphier-pcie.c          |  11 +-
>  drivers/phy/ti/phy-dm816x-usb.c                    |  17 ++-
>  drivers/pinctrl/sh-pfc/pfc-r8a7796.c               |   3 +-
>  drivers/pinctrl/sh-pfc/pfc-r8a77990.c              |   8 +-
>  drivers/platform/x86/toshiba_acpi.c                |   1 +
>  drivers/regulator/da9052-regulator.c               |   3 +-
>  drivers/regulator/hi655x-regulator.c               |  16 +--
>  drivers/regulator/mt6358-regulator.c               |   2 +-
>  drivers/regulator/uniphier-regulator.c             |   1 +
>  drivers/rtc/rtc-stm32.c                            |   6 +-
>  drivers/s390/cio/chp.c                             |   3 +
>  drivers/s390/cio/chsc.c                            |   2 -
>  drivers/scsi/FlashPoint.c                          |  32 +++---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   4 +-
>  drivers/scsi/scsi_lib.c                            |   1 +
>  drivers/soundwire/stream.c                         |  13 ++-
>  drivers/spi/spi-loopback-test.c                    |   2 +-
>  drivers/spi/spi-omap-100k.c                        |   2 +-
>  drivers/spi/spi-sun6i.c                            |   6 +-
>  drivers/spi/spi-topcliff-pch.c                     |   4 +-
>  drivers/spi/spi.c                                  |   1 +
>  drivers/ssb/scan.c                                 |   1 +
>  drivers/ssb/sdio.c                                 |   1 -
>  drivers/staging/fbtft/fb_agm1264k-fl.c             |  20 ++--
>  drivers/staging/fbtft/fb_bd663474.c                |   4 -
>  drivers/staging/fbtft/fb_ili9163.c                 |   4 -
>  drivers/staging/fbtft/fb_ili9320.c                 |   1 -
>  drivers/staging/fbtft/fb_ili9325.c                 |   4 -
>  drivers/staging/fbtft/fb_ili9340.c                 |   1 -
>  drivers/staging/fbtft/fb_s6d1121.c                 |   4 -
>  drivers/staging/fbtft/fb_sh1106.c                  |   1 -
>  drivers/staging/fbtft/fb_ssd1289.c                 |   4 -
>  drivers/staging/fbtft/fb_ssd1325.c                 |   2 -
>  drivers/staging/fbtft/fb_ssd1331.c                 |   6 +-
>  drivers/staging/fbtft/fb_ssd1351.c                 |   1 -
>  drivers/staging/fbtft/fb_upd161704.c               |   4 -
>  drivers/staging/fbtft/fb_watterott.c               |   1 -
>  drivers/staging/fbtft/fbtft-bus.c                  |   3 +-
>  drivers/staging/fbtft/fbtft-core.c                 |  13 ++-
>  drivers/staging/fbtft/fbtft-io.c                   |  12 +--
>  drivers/staging/gdm724x/gdm_lte.c                  |  20 +++-
>  drivers/staging/media/imx/imx-media-csi.c          |  14 ++-
>  drivers/staging/media/imx/imx7-mipi-csis.c         |   6 +-
>  drivers/staging/mt7621-dts/mt7621.dtsi             |   2 +-
>  drivers/staging/rtl8712/hal_init.c                 |   3 +
>  drivers/staging/rtl8712/usb_intf.c                 |  10 +-
>  drivers/target/iscsi/cxgbit/cxgbit_ddp.c           |  19 ++--
>  drivers/target/iscsi/cxgbit/cxgbit_target.c        |  21 +++-
>  drivers/tty/nozomi.c                               |   9 +-
>  drivers/tty/serial/8250/8250_port.c                |  19 +++-
>  drivers/tty/serial/8250/serial_cs.c                |   2 +-
>  drivers/tty/serial/mvebu-uart.c                    |  18 ++--
>  drivers/tty/serial/sh-sci.c                        |   8 ++
>  drivers/usb/class/cdc-acm.c                        |   5 +
>  drivers/usb/dwc2/core.c                            |  30 ++++--
>  drivers/usb/dwc3/core.c                            |   3 +-
>  drivers/usb/gadget/function/f_eem.c                |  43 +++++++-
>  drivers/usb/gadget/function/f_fs.c                 |  65 ++++++-----
>  drivers/usb/host/xhci-mem.c                        |   1 +
>  drivers/usb/typec/class.c                          |   4 +-
>  drivers/vfio/pci/vfio_pci.c                        |  29 +++--
>  drivers/video/backlight/lm3630a_bl.c               |   4 +-
>  drivers/video/fbdev/imxfb.c                        |   2 +-
>  drivers/visorbus/visorchipset.c                    |   6 +-
>  fs/btrfs/Kconfig                                   |   2 +
>  fs/btrfs/delayed-inode.c                           |  18 ++--
>  fs/btrfs/send.c                                    |  11 ++
>  fs/btrfs/transaction.c                             |   6 +-
>  fs/btrfs/tree-log.c                                |   1 +
>  fs/cifs/cifsglob.h                                 |   3 +-
>  fs/cifs/connect.c                                  |   5 +-
>  fs/configfs/file.c                                 |  10 +-
>  fs/dax.c                                           |   3 +-
>  fs/dlm/config.c                                    |   9 ++
>  fs/dlm/lowcomms.c                                  |   2 +-
>  fs/ext4/extents.c                                  |   3 +
>  fs/ext4/extents_status.c                           |   4 +-
>  fs/ext4/ialloc.c                                   |  11 +-
>  fs/ext4/mballoc.c                                  |   9 +-
>  fs/ext4/super.c                                    |  10 +-
>  fs/fs-writeback.c                                  |  39 ++-----
>  fs/fuse/dev.c                                      |  12 ++-
>  fs/ntfs/inode.c                                    |   2 +-
>  fs/ocfs2/filecheck.c                               |   6 +-
>  fs/ocfs2/stackglue.c                               |   8 +-
>  include/crypto/internal/hash.h                     |   8 +-
>  include/linux/bio.h                                |  12 +--
>  include/linux/iio/common/cros_ec_sensors_core.h    |   2 +-
>  include/linux/prandom.h                            |   2 +-
>  include/linux/tracepoint.h                         |  10 ++
>  include/media/media-dev-allocator.h                |   2 +-
>  include/net/ip.h                                   |  12 ++-
>  include/net/ip6_route.h                            |  16 ++-
>  include/net/sch_generic.h                          |  12 +++
>  include/net/tc_act/tc_vlan.h                       |   1 +
>  include/net/xfrm.h                                 |   1 +
>  kernel/kthread.c                                   |  19 ++--
>  kernel/locking/lockdep.c                           | 120 +++++++++++++++++=
+++-
>  kernel/rcu/tree.c                                  |   2 +-
>  kernel/sched/core.c                                |  43 ++++----
>  kernel/sched/deadline.c                            |   2 +
>  kernel/sched/fair.c                                |   8 +-
>  kernel/sched/rt.c                                  |  17 ++-
>  kernel/time/clocksource.c                          |  53 +++++++--
>  kernel/trace/bpf_trace.c                           |   3 +-
>  kernel/trace/trace_events_hist.c                   |   7 ++
>  kernel/tracepoint.c                                |  33 +++++-
>  lib/iov_iter.c                                     |   9 +-
>  lib/kstrtox.c                                      |  13 ++-
>  lib/kstrtox.h                                      |   2 +
>  lib/seq_buf.c                                      |   4 +-
>  lib/vsprintf.c                                     |  82 ++++++++------
>  mm/huge_memory.c                                   |   2 +-
>  mm/z3fold.c                                        |   1 +
>  net/bluetooth/hci_event.c                          |  13 ++-
>  net/bluetooth/mgmt.c                               |   3 +
>  net/bpfilter/main.c                                |   2 +-
>  net/can/bcm.c                                      |   7 +-
>  net/can/gw.c                                       |   3 +
>  net/can/j1939/main.c                               |   4 +
>  net/can/j1939/socket.c                             |   3 +
>  net/core/filter.c                                  |   4 -
>  net/ipv4/esp4.c                                    |   2 +-
>  net/ipv4/fib_frontend.c                            |   2 +
>  net/ipv4/route.c                                   |   3 +-
>  net/ipv6/esp6.c                                    |   2 +-
>  net/ipv6/exthdrs.c                                 |  31 +++---
>  net/mac80211/mlme.c                                |   9 --
>  net/mac80211/sta_info.c                            |   5 -
>  net/netfilter/nft_exthdr.c                         |   3 +
>  net/netfilter/nft_osf.c                            |   5 +
>  net/netfilter/nft_tproxy.c                         |   9 +-
>  net/netlabel/netlabel_mgmt.c                       |  19 ++--
>  net/sched/act_vlan.c                               |   7 +-
>  net/sched/cls_tcindex.c                            |   2 +-
>  net/sched/sch_qfq.c                                |   8 +-
>  net/sunrpc/sched.c                                 |  12 ++-
>  net/tls/tls_sw.c                                   |   2 +-
>  net/xfrm/xfrm_state.c                              |  14 ++-
>  samples/bpf/xdp_redirect_user.c                    |   2 +-
>  scripts/Makefile.build                             |   9 +-
>  scripts/tools-support-relr.sh                      |   3 +-
>  security/integrity/evm/evm_main.c                  |   5 +-
>  security/integrity/evm/evm_secfs.c                 |  13 +--
>  sound/pci/hda/patch_realtek.c                      |  43 ++++++--
>  sound/pci/intel8x0.c                               |   2 +-
>  sound/soc/atmel/atmel-i2s.c                        |  34 ++++--
>  sound/soc/codecs/cs42l42.h                         |   2 +-
>  sound/soc/codecs/rk3328_codec.c                    |  28 +++--
>  sound/soc/hisilicon/hi6210-i2s.c                   |  14 +--
>  sound/soc/mediatek/common/mtk-btcvsd.c             |  24 +++--
>  sound/soc/sh/rcar/adg.c                            |   4 +-
>  sound/usb/format.c                                 |   2 +
>  sound/usb/mixer.c                                  |   8 +-
>  sound/usb/mixer.h                                  |   1 +
>  sound/usb/mixer_scarlett_gen2.c                    |   7 +-
>  tools/bpf/bpftool/main.c                           |   4 +-
>  tools/perf/util/llvm-utils.c                       |   2 +
>  .../selftests/tc-testing/plugin-lib/scapyPlugin.py |   2 +-
>  tools/testing/selftests/x86/protection_keys.c      |   3 +-
>  379 files changed, 2313 insertions(+), 1244 deletions(-)
>=20
>=20
>=20

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.132-rc1-ge00f43b5589c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
