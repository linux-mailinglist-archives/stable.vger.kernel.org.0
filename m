Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867ED4D06AF
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 19:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239840AbiCGSjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 13:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238835AbiCGSjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 13:39:19 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065F831DED
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 10:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646678304; x=1678214304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vWyafve1Ovyezip/0lz+wh9crmTuNgm7DhjE4Sj1yrM=;
  b=eEf/BHIbAg2jEaPwpvmBh8f59IogUq5/gMe+yKzk16Nd2K3WvBMAE1Kf
   FVIXumem+GDUtnLi0RRUUv9pmbpd4oVP9N42eJxvMVtRP6+NWTNlXrtak
   r/XgQp5MNFMo/w/3M7I4G50m1AmEv/KPvaxWsBeNcr9t8S5r2rcs6nrsl
   kltRUbhbCPTUX2TxtnOq0l2F/TVhRYQRRXInuOWHywKmaaWxLWWJjvHzU
   dX531wus4OPVeN09Ec5CJyRuHBzjE1SQj6p9Hsh/6WBpIZTbZK9hTw2Lu
   b2gAHApGg8mSSv30GsvsNJCkTSTvmdFo57L66pNnHz2ESTvXbS3luDTBQ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="315184197"
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="315184197"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 10:38:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="813234114"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga005.fm.intel.com with ESMTP; 07 Mar 2022 10:38:23 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 10:38:23 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 10:38:22 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 7 Mar 2022 10:38:22 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 7 Mar 2022 10:38:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpC+9jD7tFOnrhjdV9cyhWnTwryOLiFD/EIBT8v4Zqvfu66jrMEKXJrqWwdCeB1OuTa0j7reOioNkDovpXFiqFlkQLkgoRUoNgXCIcyEN8kkI9Q7iQLOGNju67wgBfswrKum26q0F8ArxBCaODlRaSEBLfWlJRPUZYi+HZtroYtyy2C+CnrMz0JtXm6yTrYJmHKsytPI7cm0W8XB/eZyWuGQ9tnjdSyQjznA3bg3Q2AbSdgOs34FGFCJfqSI+Lo4ymdIIet2jOT2n0aQTy/aX7MeAFhGuHDoqqGFOYRfBan3sXVOB6Y9iI/Xep0H8UxYsfI+BG7YtSExZhV8KcN6EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8jGInojiYHDS+0UfKIYnF87rNMHNpun7gIbZP3Zbck=;
 b=RyvPWnhkl0WF5d+IQF0QY9Wa79vSz9QaG1HCzcqeyrlboQshMAyG3nFAEoFEUJapJtELhVFzg/O7IBE9lhMMxnBM7NB3GZo3IK5Jo/RlZjQVoU8eK+iabWEjUVJOly7Fb5nsl0xoqzrxAfv7nmW4kxgURCkV6fo2dorL+YLvPi95EaIX3Q+dkqADIdazD0p4feG9Fv6EdpUfp+97tcjKBI/6v9MyayTxlPpn7dkXZMBqrqzetf7SnBIuq8AQHzXmnfzd6CrvXqMMZlXPfS2D9EShHgxREeFXINLxoQ6RJmGqyNb4naZjdPvcYQE5Qb+TOr5jGr3Z26vk6Iw5G2kuKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5382.namprd11.prod.outlook.com (2603:10b6:208:31c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 18:38:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a%9]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 18:38:20 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Greg KH <greg@kroah.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Topic: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Index: AQHYLORhwV6qEFSpOEGERjF7yfXRcKyw00SAgAN34MA=
Date:   Mon, 7 Mar 2022 18:38:20 +0000
Message-ID: <CO1PR11MB5089917F2075935046821599D6089@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220228204700.3260650-1-jacob.e.keller@intel.com>
 <YiNoN+pvklPaIMT4@kroah.com>
In-Reply-To: <YiNoN+pvklPaIMT4@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f16c116c-7523-4872-3007-08da0069a725
x-ms-traffictypediagnostic: BL1PR11MB5382:EE_
x-microsoft-antispam-prvs: <BL1PR11MB5382167E04C5E1F7D06AC581D6089@BL1PR11MB5382.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZO3EsMk3qg3LRROKxgflV81ooMa4B12eCtoHcwrGDOShbwJYK69UHVpNXb7iiD7vRLV2wXd3JUy50P+XHaxfXhkLnpFf9O0Zjlkjx2XmaeYCDVumyOc9oCq9cBx/V0ITBr5Cb2nYoTQhELE8AGvNGIW+PhuGK4Eodect7ENASUzyZDQ7tB4LnGo3+PbzdkDX6w0ri4LS4mK1lR7xaNLTZ8sdQquer1Fsp2+U8BuNnVjbFdNuH/DeYpcIXjRgDVxjgU6yi0ATH24CHZ553nD9e0XYZaiRSHd1MkkdBtTH4feO560htM9P5OGMAOZKEiuC6Z/wVDaqLRlyG24KU6vhtRDPzV5ICpNPlbr8Gc98eJcBDHdV51hwrjJ+Szwb3oPynX/KMm1SZzFm1krdd7dQofocoeFXA+i24tIKReZI5+aLDGKRwMOKxlhi7YkvNFluJRmwSvnBaG7D/WRF6dDJtCWJTFNCxLV7FgD2SA3uogDAlalIrRGuYnMt7XAdAxYtXHxigbHs+8Lihqoy22Rvfp5BvZp7uXgsysFLRjnEhXVd6tKfmEdzHXfsFU2aTeRda0brkveryMK15BA6gkRFbD41MXdIcK44Vn51pFOkcfrvI1fwAYZJkyeoiuUYwDdy9LRmps5UYqdliNHZBhIECxU+/Nx8yG1kFx9E+Pp/TizRFF4llxO0ZtxPTZOAC86yEFUkV+6FOeaRwS/EoGaQHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(66556008)(316002)(66946007)(66476007)(4326008)(8676002)(64756008)(38100700002)(86362001)(38070700005)(6916009)(52536014)(8936002)(82960400001)(122000001)(5660300002)(2906002)(9686003)(76116006)(26005)(186003)(508600001)(53546011)(6506007)(7696005)(71200400001)(55016003)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+GesAwxBGtdSPMfOFPZjDGkqKABGmMywomYgJaYYlGhFuOl8RxbHA+Psp4qp?=
 =?us-ascii?Q?zvIGDKdf8KEwj+rBCzjag6zcRL7ADfADNXpOW32Di/fQB1Df6tnLKLG/7pHn?=
 =?us-ascii?Q?9L8ySzpUKkBJjnpqXFM1CbA7QDF4pKkvnOhbMYZtIDZvfwgA1fhtWHSuijIR?=
 =?us-ascii?Q?YPWgnjaXThga+YGVRx8VAXTzM5pANBaPPLGLvk7Q1s3IQtUbBLsg8GPQ9Af6?=
 =?us-ascii?Q?e5HdHli7UHUWO67sWwAVzkClsNj2GxQ7W1dpXtWfJQqzFirh3iPcxzogxOvt?=
 =?us-ascii?Q?h9S8t7FsED7eH0CyNF+mXA+y20N4iLtISw9vfcgkSPaUXNwfEc4AjjD6wYVx?=
 =?us-ascii?Q?DMdE0OagM1+s9AjLR4L6ZSAjcrHoAtUasyHLAvE67xNcyVqsUOaw0eD5LrKc?=
 =?us-ascii?Q?l6eGe98xWlgskU/dRn9m7QjsiFUUm6UgzyCDs/m5paCVo1qTQe5XURjUuInA?=
 =?us-ascii?Q?SZf3aAO8G+b5E3NwXYA+hCBPPwRLUcG0Hu/C5I7w7xBXGYP/onXvfoZ2IXWi?=
 =?us-ascii?Q?v086Ed8hS11+rurrVx+LPDQMXq5dz4sSdWb5wHKVCAQ2uv1CAHazI7gbECp3?=
 =?us-ascii?Q?Pf8BPyuo4Kase3P7G/DAg7qTZRjinK7E0ZTzvh8XMgShfOrjAtKrfZ56iYg6?=
 =?us-ascii?Q?l8OAxEGUIaf1nDiElrVSYo26mFsI0jnpd+MqjR21JyhnEHuw7TXUR7nPlXce?=
 =?us-ascii?Q?eLdFwOFvwoRSpbh5EpR9PB7K8Em6QXkoVhJHzJhY+lL01G71kd2eYSKFbB2i?=
 =?us-ascii?Q?LXvBqmbCIdgA30oHbnf3MmGcg4p/i62R+Iel7e7s5rztYzJH+HT4HOf0A9nw?=
 =?us-ascii?Q?xnZmeIncPjj8MmIRJcQYZtZH5zP6M3O5og9RUlVl2LptmWJTnB9ycl14rDAU?=
 =?us-ascii?Q?q2zZX5kv2ls8Kca6JIAGxYDymSgdsflTeiVkulFR1fdo6YU1cMwx/dM1IBI3?=
 =?us-ascii?Q?hSOqS85cjPC7iej4J0QHSOc6nryTWKXrTXhdiM/RUlMPpfutuM2WAz7gJrWy?=
 =?us-ascii?Q?kL//KoqEFguY35fLSmFbYwVINLxpsx4AD2S/hj23XEkkhJ+LpwmMdmlHuAhF?=
 =?us-ascii?Q?Oqy929Wf0QXU7rUW3JFqig5Loc1E/f6aXL1BLLUYjmZQG4nukxvMQk1/tMKS?=
 =?us-ascii?Q?294m0CaxrJHcO8GyxcSgvqqyp/LAIUzeIZKKm4MOQmYHCO4xWAzhHyf/EB2W?=
 =?us-ascii?Q?ZiPDIiVFVtNMOQzSbyr3mjIHffGkYIFR9T0zXKs5QIahUJrFIapw3NQW0uy3?=
 =?us-ascii?Q?Acin0VNdkNVcnoOZ7cRRmGKMKweX6Teg6uxw5GKhiCrzKZMeQ9j48m+qiVe4?=
 =?us-ascii?Q?oESeV+gNJaBNB3YM6TzPfNBF9ynIWDk9TKrTGEMdAiPuI2xa2teZ4Oo19CzB?=
 =?us-ascii?Q?2nIxuML/bpKr0ig/aSIQMDgOvjPx/J7bWd1Cxsr3ZkdLtnY7dcGS9rjfeIGs?=
 =?us-ascii?Q?6Fo0prSRmSmvxoGz+ahgmFq0AwLRWIG7t1eBpQqf3HEYORgR8WXyoBh5Q1hM?=
 =?us-ascii?Q?ccnDZajP3RcUI3R+7jMC/g2K2Z/XiuYl6jCnn1ez/DubAGZT2BBx2IFybqnP?=
 =?us-ascii?Q?PFU3ebanW9PJOfl6ASClFshjCsUHzuRqa9K0/eAfLZMbvgO5wRIt2qm3eDyV?=
 =?us-ascii?Q?4Hzrt3orxDnyPjamUHLI+zHP8HJrTr2FWaIxSdCRuzOT+lCMBIlBoDm1BnX8?=
 =?us-ascii?Q?Fam7/g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16c116c-7523-4872-3007-08da0069a725
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 18:38:20.1207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: loAdHpYwpPmZvRIowdtdW0AvqxskB6nymjv7skBOp1tRxbAIRHFF/F79fKmQ3ki2oXDR+r4gUCFKT+kvfh6GjYTmPK74aIf/+avzaRjaDOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5382
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg KH <greg@kroah.com>
> Sent: Saturday, March 05, 2022 5:40 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: stable@vger.kernel.org
> Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handli=
ng and VF
> ndo ops
>=20
> On Mon, Feb 28, 2022 at 12:46:59PM -0800, Jacob Keller wrote:
> > From: Brett Creeley <brett.creeley@intel.com>
> >
> > commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> >
> > [I had to fix the cherry-pick manually as the patch added a line around
> > some context that was missing.]
> >
> > The VF can be configured via the PF's ndo ops at the same time the PF i=
s
> > receiving/handling virtchnl messages. This has many issues, with
> > one of them being the ndo op could be actively resetting a VF (i.e.
> > resetting it to the default state and deleting/re-adding the VF's VSI)
> > while a virtchnl message is being handled. The following error was seen
> > because a VF ndo op was used to change a VF's trust setting while the
> > VIRTCHNL_OP_CONFIG_VSI_QUEUES was ongoing:
> >
> > [35274.192484] ice 0000:88:00.0: Failed to set LAN Tx queue context, er=
ror:
> ICE_ERR_PARAM
> > [35274.193074] ice 0000:88:00.0: VF 0 failed opcode 6, retval: -5
> > [35274.193640] iavf 0000:88:01.0: PF returned error -5 (IAVF_ERR_PARAM)=
 to
> our request 6
> >
> > Fix this by making sure the virtchnl handling and VF ndo ops that
> > trigger VF resets cannot run concurrently. This is done by adding a
> > struct mutex cfg_lock to each VF structure. For VF ndo ops, the mutex
> > will be locked around the critical operations and VFR. Since the ndo op=
s
> > will trigger a VFR, the virtchnl thread will use mutex_trylock(). This
> > is done because if any other thread (i.e. VF ndo op) has the mutex, the=
n
> > that means the current VF message being handled is no longer valid, so
> > just ignore it.
> >
> > This issue can be seen using the following commands:
> >
> > for i in {0..50}; do
> >         rmmod ice
> >         modprobe ice
> >
> >         sleep 1
> >
> >         echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
> >         echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs
> >
> >         ip link set ens785f1 vf 0 trust on
> >         ip link set ens785f0 vf 0 trust on
> >
> >         sleep 2
> >
> >         echo 0 > /sys/class/net/ens785f0/device/sriov_numvfs
> >         echo 0 > /sys/class/net/ens785f1/device/sriov_numvfs
> >         sleep 1
> >         echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
> >         echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs
> >
> >         ip link set ens785f1 vf 0 trust on
> >         ip link set ens785f0 vf 0 trust on
> > done
> >
> > Fixes: 7c710869d64e ("ice: Add handlers for VF netdevice operations")
> > Cc: <stable@vger.kernel.org> # 5.14.x
> > Signed-off-by: Brett Creeley <brett.creeley@intel.com>
> > Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > ---
> > This should apply to 5.14.x
>=20
> 5.14 is long end-of-life, always look at the kernel.org page if you are
> curious what the "active" kernel trees are.
>=20
> thanks,
>=20
> greg k-h

My mistake. I apologize for the wasted time here.

Thanks,
Jake
