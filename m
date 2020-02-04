Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3E215182F
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 10:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgBDJvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 04:51:01 -0500
Received: from mail-eopbgr1410132.outbound.protection.outlook.com ([40.107.141.132]:25765
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726553AbgBDJvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 04:51:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5K9bADNBwIBMIrAKRE6M/tHpmTHvxD9CgHNzXUnDoQ5SXwi/dlSF6lrszP97OcGqFJbBZdeErLzzUEKyH673pHT37QgQk7NHHF/AyTw4BOQOLac22YXYf2bxJei5j+1FCb/BNZXXW8d25ShHbMBHPKh70uDYkhkQb+/LMX5r4Fj/vbcEurhWP3oMh+pPBN70xAMtDmTFL24kCNdXoiu8O80Y6vP7SBC4xY0EHW011/MAAT5YZ5XHnMggm7HHba5s4dpM4IawIc48PNwOzX7I7vxIul7NXANKCbxqzqMdpNnTXuIKTd0JYn22xF60PgGgGKx5agMNiY/GkrfukShiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzZNwK0+9CJNSAgVDlI0GGwzdNuCmDXANIg2Mcu78gE=;
 b=IpBXjo5mZGFjYE2wHKadtxocnk0lyERGXuPbVm6U9cVLzhaq1lA3k77ZDialcs/9Y2vTHTTW7KUHIROsQKNxLCTnNRgUH6BLJEbItok2/WRlvqkDPPGqhvfj5axSX3Y2yiXvw3CSY2C6p/jDK0Tzkgejta4k3SwH45e/SQq5LuA/OAYe4Q+5H2q+CdKGuMwCu/gE950TjHKCrAmMjt2WW/1HYYh3ZAtphJISbQhr2Bhu9xGsUZCogGAVK2druyFu856rSXSYQgH73tLSZ00I2KYusxahjGspIXfUNIh4BVH9Yzy8kUTNi9D/1P5ngDb0f4V9hr4SYUYu3wtgVwYBbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzZNwK0+9CJNSAgVDlI0GGwzdNuCmDXANIg2Mcu78gE=;
 b=OsWvzK4rBa48gxFYcMNuKsnjbL+LNl56vz+Je1VXRYgi3egZdJQWYPVa1q/UpUXAFJ4gGBElb/R8EUwMWJCGIwFL+PCRMwzsfdFFiYh2ED7pWqp9djwacdMC5E1BEauyuW7LMGbvOqeVfo2qvcdo3pYumYpbjHxUrevPcjfQDRA=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB4797.jpnprd01.prod.outlook.com (20.179.175.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.30; Tue, 4 Feb 2020 09:50:56 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::1045:4879:77ed:8a70]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::1045:4879:77ed:8a70%7]) with mapi id 15.20.2686.030; Tue, 4 Feb 2020
 09:50:56 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: RE: [PATCH 4.4 00/53] 4.4.213-stable review
Thread-Topic: [PATCH 4.4 00/53] 4.4.213-stable review
Thread-Index: AQHV2q371s8BhYMrikS93RDHT0J2SagKwR1g
Date:   Tue, 4 Feb 2020 09:50:56 +0000
Message-ID: <TYAPR01MB2285D96DC944217E7A22F8C6B7030@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20200203161902.714326084@linuxfoundation.org>
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 936b2cf4-a071-426d-b0b5-08d7a957bb32
x-ms-traffictypediagnostic: TYAPR01MB4797:
x-microsoft-antispam-prvs: <TYAPR01MB4797D6142E555D082AC26F80B7030@TYAPR01MB4797.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 03030B9493
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(199004)(189003)(110136005)(6506007)(86362001)(52536014)(2906002)(8936002)(966005)(8676002)(316002)(26005)(66556008)(478600001)(76116006)(66476007)(64756008)(66946007)(66446008)(81166006)(81156014)(33656002)(4326008)(71200400001)(54906003)(7416002)(9686003)(5660300002)(7696005)(55016002)(186003)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB4797;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eznMU/1dLXXayzkZzeQwU9udU9ll8a9sVVbAV2teImzZvmOm+7GaeA35dlJnBJ5hO5JL1l7vCwzTXrl3jCBCsvIvtsapZtE08eVppQ66ZS+ZwBCS9G1JU+hXeJlGPFclxx++Y06ITRoX6IVaqAUQJ4WCfm7EnAPs60Zk5bdQ5ZY5H7Is7QXkpZL278euRkvJshGXaMuInngM8uqU4gMg/BiMpbgzwn09aytIT7u1ebBYjf60y9ZHULV3Y2Igh6VUel0dpn58Vr79noQJKScrxVAXYqsIqHaw9t7FfTTNvFk+Xw/LGOhqFU5noAJ2mnR3SK3LmAW2DgeQVCANRe0NXUNRjpsdNtQfOVjLZIwTY675eZM2iGG8YNys+pxtqbYVP6hGnqwv2BX4z//GfYYtqoQ54uwVTZkHDNWroj6ACM+MG67IDw15+3i6gZ3OKqSUrgKXE14wGgGh9DW83cHbpwqOse5rN0ofe+QtkuL6aRgxHSAXFKjzugcfKmlPc0w+PSGIvJ4isYVydRz5T6YgYu1aQ2sdM4YzUz7w5dcX+BEeZVfjCQFIJqAmkjgihMZP
x-ms-exchange-antispam-messagedata: AcMojIGp25prA4WPJkor7tBRJ9HwjNVueGjXx8MTdwVzlXoiyeZekB64+hu+xWsVIM5R/jpmrhXz5DYwBOysi2qXEJulQa5Ztl8ie4udBD6dFv0SjviV4/nDXs7XsEaF1cKoInZ9s7hhbuOOU90QEw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936b2cf4-a071-426d-b0b5-08d7a957bb32
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2020 09:50:56.2925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wWduqBH+krydvfBww4sIjFqum74oAjPk+hzhxaYYA+9MhfUWTKb1s69Gc8+OmjV3p4ObLHQ+F2wl3ghsZvv5psGDZqVOiSpzvHgM9k579VI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4797
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 03 February 2020 16:19
>=20
> This is the start of the stable review cycle for the 4.4.213 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.

We're seeing an issue with 4.4.213-rc1 (36670370c48b) and 4.4.213-rc2 (758a=
39807529) with our 4 am335x configurations [0]:

   AS      arch/arm/kernel/hyp-stub.o
 arch/arm/kernel/hyp-stub.S:   CC      arch/arm/mach-omap2/sram.o
 Assembler messages:
   AS      arch/arm/kernel/smccc-call.o
 arch/arm/kernel/hyp-stub.S:147: Error: selected processor does not support=
 `ubfx r7,r7,#16,#4' in ARM mode
 scripts/Makefile.build:375: recipe for target 'arch/arm/kernel/hyp-stub.o'=
 failed
 make[1]: *** [arch/arm/kernel/hyp-stub.o] Error 1

The culprit seems to be: 15163bcee7b5 ("ARM: 8955/1: virt: Relax arch timer=
 version check during early boot")
Reverting the same resolves the build issue.

Latest pipeline: https://gitlab.com/cip-project/cip-testing/linux-stable-rc=
-ci/pipelines/114683657

[0] https://gitlab.com/cip-project/cip-kernel/cip-kernel-config/-/blob/mast=
er/4.4.y-cip/arm/
siemens_am335x-axm2_defconfig, siemens_am335x-draco_defconfig, siemens_am33=
5x-dxr2_defconfig, siemens_am335x-etamin_defconfig


Kind regards, Chris

>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-
> review/patch-4.4.213-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> rc.git linux-4.4.y
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
>     Linux 4.4.213-rc1
>=20
> Praveen Chaudhary <praveen5582@gmail.com>
>     net: Fix skb->csum update in inet_proto_csum_replace16().
>=20
> Vasily Averin <vvs@virtuozzo.com>
>     l2t_seq_next should increase position index
>=20
> Vasily Averin <vvs@virtuozzo.com>
>     seq_tab_next() should increase position index
>=20
> Finn Thain <fthain@telegraphics.com.au>
>     net/sonic: Quiesce SONIC before re-initializing descriptor memory
>=20
> Finn Thain <fthain@telegraphics.com.au>
>     net/sonic: Fix receive buffer handling
>=20
> Finn Thain <fthain@telegraphics.com.au>
>     net/sonic: Use MMIO accessors
>=20
> Finn Thain <fthain@telegraphics.com.au>
>     net/sonic: Add mutual exclusion for accessing shared state
>=20
> Madalin Bucur <madalin.bucur@oss.nxp.com>
>     net/fsl: treat fsl,erratum-a011043
>=20
> Manish Chopra <manishc@marvell.com>
>     qlcnic: Fix CPU soft lockup while collecting firmware dump
>=20
> Hayes Wang <hayeswang@realtek.com>
>     r8152: get default setting of WOL before initializing
>=20
> Michael Ellerman <mpe@ellerman.id.au>
>     airo: Add missing CAP_NET_ADMIN check in
> AIROOLDIOCTL/SIOCDEVPRIVATE
>=20
> Michael Ellerman <mpe@ellerman.id.au>
>     airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
>=20
> Vladimir Murzin <vladimir.murzin@arm.com>
>     ARM: 8955/1: virt: Relax arch timer version check during early boot
>=20
> Hannes Reinecke <hare@suse.de>
>     scsi: fnic: do not queue commands during fwreset
>=20
> Nicolas Dichtel <nicolas.dichtel@6wind.com>
>     vti[6]: fix packet tx through bpf_redirect()
>=20
> Johan Hovold <johan@kernel.org>
>     Input: aiptek - use descriptors of current altsetting
>=20
> Arnd Bergmann <arnd@arndb.de>
>     wireless: wext: avoid gcc -O3 warning
>=20
> Cambda Zhu <cambda@linux.alibaba.com>
>     ixgbe: Fix calculation of queue with VFs and flow director on interfa=
ce flap
>=20
> Radoslaw Tyl <radoslawx.tyl@intel.com>
>     ixgbevf: Remove limit of 10 entries for unicast filter list
>=20
> Lubomir Rintel <lkundrak@v3.sk>
>     clk: mmp2: Fix the order of timer mux parents
>=20
> Lee Jones <lee.jones@linaro.org>
>     media: si470x-i2c: Move free() past last use of 'radio'
>=20
> Bin Liu <b-liu@ti.com>
>     usb: dwc3: turn off VBUS when leaving host mode
>=20
> Zhenzhong Duan <zhenzhong.duan@gmail.com>
>     ttyprintk: fix a potential deadlock in interrupt context issue
>=20
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0
>=20
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: gspca: zero usb_buf
>=20
> Sean Young <sean@mess.org>
>     media: digitv: don't continue if remote control state can't be read
>=20
> Jan Kara <jack@suse.cz>
>     reiserfs: Fix memory leak of journal device string
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     mm/mempolicy.c: fix out of bounds write in mpol_parse_str()
>=20
> Dirk Behme <dirk.behme@de.bosch.com>
>     arm64: kbuild: remove compressed images on 'make ARCH=3Darm64
> (dist)clean'
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: pcrypt - Fix user-after-free on module unload
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     vfs: fix do_last() regression
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: af_alg - Use bh_lock_sock in sk_destruct
>=20
> Eric Dumazet <edumazet@google.com>
>     net_sched: ematch: reject invalid TCF_EM_SIMPLE
>=20
> Laura Abbott <labbott@fedoraproject.org>
>     usb-storage: Disable UAS on JMicron SATA enclosure
>=20
> Arnd Bergmann <arnd@arndb.de>
>     atm: eni: fix uninitialized variable warning
>=20
> Krzysztof Kozlowski <krzk@kernel.org>
>     net: wan: sdla: Fix cast from pointer to integer of different size
>=20
> Fenghua Yu <fenghua.yu@intel.com>
>     drivers/net/b44: Change to non-atomic bit operations on pwol_mask
>=20
> Andreas Kemnade <andreas@kemnade.info>
>     watchdog: rn5t618_wdt: fix module aliases
>=20
> Johan Hovold <johan@kernel.org>
>     zd1211rw: fix storage endpoint lookup
>=20
> Johan Hovold <johan@kernel.org>
>     rtl8xxxu: fix interface sanity check
>=20
> Johan Hovold <johan@kernel.org>
>     brcmfmac: fix interface sanity check
>=20
> Johan Hovold <johan@kernel.org>
>     ath9k: fix storage endpoint lookup
>=20
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: Fix false Tx excessive retries reporting.
>=20
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: use NULLFUCTION stack on mac80211
>=20
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: correct packet types for CTS protect, mode.
>=20
> Colin Ian King <colin.king@canonical.com>
>     staging: wlan-ng: ensure error return is actually returned
>=20
> Andrey Shvetsov <andrey.shvetsov@k2l.de>
>     staging: most: net: fix buffer overflow
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: ir-usb: fix IrLAP framing
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: ir-usb: fix link-speed handling
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: ir-usb: add missing endpoint sanity check
>=20
> Johan Hovold <johan@kernel.org>
>     rsi_91x_usb: fix interface sanity check
>=20
> Johan Hovold <johan@kernel.org>
>     orinoco_usb: fix interface sanity check
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: pcm: Add missing copy ops check before clearing buffer
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                                           |   4 +-
>  arch/arm/kernel/hyp-stub.S                         |   7 +-
>  arch/arm64/boot/Makefile                           |   2 +-
>  crypto/af_alg.c                                    |   6 +-
>  crypto/pcrypt.c                                    |   3 +-
>  drivers/atm/eni.c                                  |   4 +-
>  drivers/char/ttyprintk.c                           |  15 ++-
>  drivers/clk/mmp/clk-of-mmp2.c                      |   2 +-
>  drivers/input/tablet/aiptek.c                      |   2 +-
>  drivers/media/radio/si470x/radio-si470x-i2c.c      |   2 +-
>  drivers/media/usb/dvb-usb/digitv.c                 |  10 +-
>  drivers/media/usb/dvb-usb/dvb-usb-urb.c            |   2 +-
>  drivers/media/usb/gspca/gspca.c                    |   2 +-
>  drivers/net/ethernet/broadcom/b44.c                |   9 +-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   3 +-
>  drivers/net/ethernet/chelsio/cxgb4/l2t.c           |   3 +-
>  drivers/net/ethernet/freescale/xgmac_mdio.c        |   7 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  37 ++++--
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   5 -
>  drivers/net/ethernet/natsemi/sonic.c               | 109 ++++++++++++++-=
--
>  drivers/net/ethernet/natsemi/sonic.h               |  25 ++--
>  .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   1 +
>  .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |   2 +
>  drivers/net/usb/r8152.c                            |   9 +-
>  drivers/net/wan/sdla.c                             |   2 +-
>  drivers/net/wireless/airo.c                        |  20 ++-
>  drivers/net/wireless/ath/ath9k/hif_usb.c           |   2 +-
>  drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   4 +-
>  drivers/net/wireless/orinoco/orinoco_usb.c         |   4 +-
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   |   2 +-
>  drivers/net/wireless/rsi/rsi_91x_usb.c             |   2 +-
>  drivers/net/wireless/zd1211rw/zd_usb.c             |   2 +-
>  drivers/scsi/fnic/fnic_scsi.c                      |   3 +
>  drivers/staging/most/aim-network/networking.c      |  10 ++
>  drivers/staging/vt6656/device.h                    |   2 +
>  drivers/staging/vt6656/int.c                       |   6 +-
>  drivers/staging/vt6656/main_usb.c                  |   1 +
>  drivers/staging/vt6656/rxtx.c                      |  26 ++--
>  drivers/staging/wlan-ng/prism2mgmt.c               |   2 +-
>  drivers/usb/dwc3/core.c                            |   3 +
>  drivers/usb/serial/ir-usb.c                        | 136 +++++++++++++++=
+-----
>  drivers/usb/storage/unusual_uas.h                  |   7 +-
>  drivers/watchdog/rn5t618_wdt.c                     |   1 +
>  fs/namei.c                                         |   4 +-
>  fs/reiserfs/super.c                                |   2 +
>  include/linux/usb/irda.h                           |  13 +-
>  mm/mempolicy.c                                     |   6 +-
>  net/core/utils.c                                   |  20 ++-
>  net/ipv4/ip_vti.c                                  |  13 +-
>  net/ipv6/ip6_vti.c                                 |  13 +-
>  net/sched/ematch.c                                 |   3 +
>  net/wireless/wext-core.c                           |   3 +-
>  sound/core/pcm_native.c                            |   2 +-
>  53 files changed, 418 insertions(+), 167 deletions(-)
>=20

